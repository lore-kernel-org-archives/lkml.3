Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab3CZXfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:35:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904Ab3CZXfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:35:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1364338701-24306-1-git-send-email-mmarek@suse.cz>
References: <1364338701-24306-1-git-send-email-mmarek@suse.cz>
To: Michal Marek <mmarek@suse.cz>
Cc: dhowells@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MODSIGN: Discard previous signature when signing modules
Date: Tue, 26 Mar 2013 23:34:50 +0000
Message-ID: <960.1364340890@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek <mmarek@suse.cz> wrote:

> The format only supports one signature, so discard any previous
> signature before signing the module.

That's not totally true.  The format does not preclude multiple signatures.
You can just add another signature block on the end that signs everything
inside of that, including all previous signatures.  The alteration to the code
to check all of them would be very small, I think.

David
