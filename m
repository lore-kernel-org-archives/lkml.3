Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbaCYWrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 18:47:41 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:64832 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaCYWri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 18:47:38 -0400
Date: Tue, 25 Mar 2014 23:47:39 +0100
From: Mathieu Maret <mathieu.maret@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, arve@android.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/2] staging: binder: Code simplification
Message-ID: <20140325224739.GA6448@zebulon>
References: <1395785001-4153-1-git-send-email-mathieu.maret@gmail.com>
 <1395785001-4153-2-git-send-email-mathieu.maret@gmail.com>
 <1395786108.3726.4.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395786108.3726.4.camel@joe-AO722>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Tue, 2014-03-25 at 23:03 +0100, Mathieu Maret wrote:
> > Remove duplicate code
> []
> > diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> []
> > @@ -2685,11 +2685,9 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> >  		break;
> >  	case BINDER_VERSION: {
> >  		struct binder_version __user *ver = ubuf;
> > -		if (size != sizeof(struct binder_version)) {
> > -			ret = -EINVAL;
> > -			goto err;
> > -		}
> > -		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION,
> > +
> > +		if (size != sizeof(struct binder_version) ||
> > +			put_user(BINDER_CURRENT_PROTOCOL_VERSION,
> >  			&ver->protocol_version)) {
> 
> When you do this, please align continuations at the appropriate
> open parenthesis using maximal initial tabs and minimal spaces
> for alignment.
> 
> 		if (size != sizeof(struct binder_version) ||
> 		    put_user(BINDER_CURRENT_PROTOCOL_VERSION,
> 			     &ver->protocol_version)) {
> 
> 2 tabs then 4 spaces then "put_user"
> 3 tabs then 5 spaces then "&ver->"
> 
> using scripts/checkpatch.pl --strict should alert you to this.
> 
> And, either don't submit this until after 3.15-rc1 is out
> and Greg KH starts taking patches again, or expect to be
> very patient about getting any update on this.
>

Joe,

Thanks for your help and tips.
--strict is now on my todo list !

See you after 3.15-rc1


