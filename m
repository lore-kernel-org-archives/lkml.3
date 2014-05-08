Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaEHKax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:30:53 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34362 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbaEHKav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:30:51 -0400
Date: Thu, 8 May 2014 13:30:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: lirc: Fix sparse warnings
Message-ID: <20140508103028.GD26890@mwanda>
References: <1399543908-31900-1-git-send-email-tuomas.tynkkynen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399543908-31900-1-git-send-email-tuomas.tynkkynen@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 01:11:48PM +0300, Tuomas Tynkkynen wrote:
> Fix sparse warnings by adding __user and __iomem annotations where
> necessary and removing certain unnecessary casts.
> 
> Signed-off-by: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>

This patch adds spaces between the cast and the variable.  There
shouldn't be a cast.  That rule is so people remember that casting is a
high precedence operation.

Joe recently added a check for cast spacing to ./scripts/checkpatch.pl
--strict.  Run your patch through ./scripts/checkpatch.pl --strict and
fix the warnings.

> @@ -470,36 +471,36 @@ static long lirc_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>  
>  	switch (cmd) {
>  	case LIRC_GET_FEATURES:
> -		result = put_user(features, (__u32 *) arg);
> +		result = put_user(features, (__u32 __user *) arg);

arg is alway a u32 __user pointer.  Do this at the start of the
function.

	u32 __user *uptr = (u32 __user *)arg;

Then replace all the "arg" references with "uptr".  Btw, the difference
between __u32 and u32 is that __u32 is for code which is shared with
user space and u32 is only allowed in kernel code.

regards,
dan carpenter

