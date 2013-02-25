Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab3BYQxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 11:53:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab3BYQxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 11:53:16 -0500
Date: Mon, 25 Feb 2013 17:51:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] usermodehelper: Fix -ENOMEM return logic
Message-ID: <20130225165147.GA1024@redhat.com>
References: <1361802350-9299-1-git-send-email-lucas.demarchi@profusion.mobi> <10238.1361804714@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10238.1361804714@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25, David Howells wrote:
>
> Lucas De Marchi <lucas.demarchi@profusion.mobi> wrote:
>
> > This patch fixes both call_usermodehelper_fns() to never call the
> > cleanup function in case retval == -ENOMEM and also the callers to
> > actually check the return value of this function.
>
> I suspect it's probably better to always call the cleanup function from
> call_usermodehelper_fns() rather than have the cleanup done by the caller in
> some circumstances and not others - would it make sense to change the cleanup
> function to take the pointer to the caller data rather than to take the
> subprocess_info struct?

I this this will comlicate the logic even more, the "caller data"
has to be kmalloced/kfreed as well.

Btw. __orderly_poweroff() doesn't need any tricks, afaics. I'll send
a simple cleanup in a minute.

Oleg.

