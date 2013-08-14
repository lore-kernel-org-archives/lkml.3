Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215Ab3HNTRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:17:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758446Ab3HNTRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:17:41 -0400
Date: Wed, 14 Aug 2013 12:17:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Rusk <Mark.Rusk@hp.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/misc/hpilo: Correct panic when an AUX iLO is
 detected
Message-ID: <20130814191740.GA25559@kroah.com>
References: <1376404333-33815-1-git-send-email-Mark.Rusk@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376404333-33815-1-git-send-email-Mark.Rusk@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 09:32:13AM -0500, Mark Rusk wrote:
>  Using an uninitialized variable 'devnum' after 'goto out;' was causing
>  panic.  Just go ahead and return, we need to ignore AUX iLO devs.
> 
>  Oops: 0002 [#1] SMP
>    .
>    .
>    .
>  RIP  [<ffffffffa033e270>] ilo_probe+0xec/0xe7c [hpilo]
> ---
>  drivers/misc/hpilo.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

I think you forgot to run this patch through the checkpatch.pl tool
before you sent it out, right (hint, no signed-off-by line...)

Please fix it up and resend, so that it can be applied...

greg k-h
