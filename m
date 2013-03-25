Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab3CYMz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 08:55:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497Ab3CYMz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 08:55:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130309202537.GD16399@redhat.com>
References: <20130309202537.GD16399@redhat.com> <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi> <1362723313-839-5-git-send-email-lucas.demarchi@profusion.mobi>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        lucas.de.marchi@gmail.com, James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/7] KEYS: split call to call_usermodehelper_fns()
Date: Mon, 25 Mar 2013 12:55:19 +0000
Message-ID: <7566.1364216119@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> Looks correct, but can't we simpluify it a bit?
> 
> 	info = call_usermodehelper_setup(session_keyring);
> 	if (!info)
> 		return ENOMEM;

-ENOMEM;-)

> 	key_get(session_keyring));
> 	return call_usermodehelper_exec(info);

Looks reasonable.  I like it better this way as it makes working out how to
deal with all the error cases so much simpler:-).

Acked-by: David Howells <dhowells@redhat.com>
