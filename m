Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525Ab3CLUbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:31:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab3CLUbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:31:49 -0400
Date: Tue, 12 Mar 2013 13:31:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Oleg Nesterov <oleg@redhat.com>, lucas.de.marchi@gmail.com,
        David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/7] usermodehelper: Export _exec() and _setup()
 functions
Message-Id: <20130312133148.106946def5edb288aafdfb51@linux-foundation.org>
In-Reply-To: <1363049291-946-2-git-send-email-lucas.demarchi@profusion.mobi>
References: <1363049291-946-1-git-send-email-lucas.demarchi@profusion.mobi>
	<1363049291-946-2-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Mar 2013 21:48:06 -0300 Lucas De Marchi <lucas.demarchi@profusion.mobi> wrote:

> call_usermodehelper_setup() + call_usermodehelper_exec() need to be
> called instead of call_usermodehelper_fns() when the cleanup function
> needs to be called even when an ENOMEM error occurs. In this case using
> call_usermodehelper_fns() the user can't distinguish if the cleanup
> function was called or not.

call_usermodehelper_exec() was exported to modules but
call_usermodehelper_setup() was not?

