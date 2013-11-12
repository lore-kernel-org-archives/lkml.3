Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab3KLVED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:04:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab3KLVD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:03:59 -0500
Date: Wed, 13 Nov 2013 06:06:41 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexandre Demers <alexandre.f.demers@gmail.com>,
        linux-kernel@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] Silence r8712u info and add verbose option v2
Message-ID: <20131112210641.GB23241@kroah.com>
References: <1384281793-4733-1-git-send-email-alexandre.f.demers@gmail.com>
 <52827E16.1030001@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52827E16.1030001@lwfinger.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 01:14:30PM -0600, Larry Finger wrote:
> On 11/12/2013 12:43 PM, Alexandre Demers wrote:
> > r8712u pollutes dmesg and logs. Silence it and add a verbose option to KConfig if we ever
> > really want to hear about it.
> >
> > v2: keep netdev_info instead of replacing it by a KERN_NOTICE
> >
> > ---
> >   drivers/staging/rtl8712/Kconfig        | 7 +++++++
> >   drivers/staging/rtl8712/rtl871x_mlme.c | 7 ++++---
> >   2 files changed, 11 insertions(+), 3 deletions(-)
> 
> Do you really want the "v2" to be part of the patch title in the git repos? I 
> expect not, thus you should put it inside the []. All that stuff is stripped off 
> when the patch is merged.
> 
> Similarly, do you want the v2 line in the patch description to be part of the 
> permanent record? If not, move it below the --- line.
> 
> You are also missing a Signed-off-by: line. Have you read 
> Documentation/SubmittingPatches? At least you should run every patch through 
> scripts/checkpatch.pl before submitting it.
> 
> Finally, why do you want to add another Kconfig variable? I suggest either 
> deleting the logging statement, or commenting it out. I'm not sure that this 
> info would ever need logging.

To be a bit more clear here, we are activly _removing_ driver and
subsystem specific DEBUG configuration flags, and moving everything to
using the dynamic debug infrastructure in the kernel, as no user ever
rebuilds their kernels/drivers, and we want to be able to get debugging
information from them at times.

thanks,

greg k-h
