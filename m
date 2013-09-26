Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab3IZAYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 20:24:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51528 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab3IZAYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 20:24:14 -0400
Date: Wed, 25 Sep 2013 17:24:13 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        codonell <codonell@redhat.com>, Eduard Benes <ebenes@redhat.com>,
        Karel Srot <ksrot@redhat.com>, Matt Newsome <mnewsome@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] tty: Fix SIGTTOU not sent with tcflush()
Message-ID: <20130926002413.GA17587@kroah.com>
References: <52437AA2.5040907@hurleysoftware.com>
 <1380154395-4232-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380154395-4232-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 08:13:04PM -0400, Peter Hurley wrote:
> Commit 'e7f3880cd9b98c5bf9391ae7acdec82b75403776'
>   tty: Fix recursive deadlock in tty_perform_flush()
> introduced a regression where tcflush() does not generate
> SIGTTOU for background process groups.
> 
> Make sure ioctl(TCFLSH) calls tty_check_change() when
> invoked from the line discipline.
> 
> Cc: stable@vger.kernel.org # v3.10+
> Reported-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/tty_ioctl.c | 3 +++
>  1 file changed, 3 insertions(+)

Thanks for tracking this down, I'll queue it up tomorrow.

greg k-h
