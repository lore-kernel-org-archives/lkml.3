Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbbAGLQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:16:11 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:35544 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbbAGLQJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:16:09 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v2] isofs: Fix bug in the way to check if the year is a leap year
From: =?iso-8859-1?Q?=D2scar_Forner_Mart=EDnez?= 
	<oscar.forner.martinez@gmail.com>
In-Reply-To: <1420375345-3967-1-git-send-email-oscar.forner.martinez@gmail.com>
Date: Wed, 7 Jan 2015 11:15:57 +0000
Content-Transfer-Encoding: 8BIT
Message-Id: <9B989AC4-AAF6-4C63-9815-E68F2235F1BD@gmail.com>
References: <1420375345-3967-1-git-send-email-oscar.forner.martinez@gmail.com>
To: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have sent that e-mail three days ago. As nobody is the maintainer It is only send for the general list. This is just a reminder for someone who can check it.

On 4 Jan 2015, at 12:42, Oscar Forner Martinez <oscar.forner.martinez@gmail.com> wrote:

> Changed the whole algorithm for a call to mktime64 that takes
> care of all that details.
> 
> Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
> ---
> fs/isofs/util.c | 14 ++------------
> 1 file changed, 2 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/isofs/util.c b/fs/isofs/util.c
> index 01e1ee7..a3f953a 100644
> --- a/fs/isofs/util.c
> +++ b/fs/isofs/util.c
> @@ -2,6 +2,7 @@
>  *  linux/fs/isofs/util.c
>  */
> 
> +#include <linux/time.h>
> #include "isofs.h"
> 
> /* 
> @@ -31,18 +32,7 @@ int iso_date(char * p, int flag)
> 	if (year < 0) {
> 		crtime = 0;
> 	} else {
> -		int monlen[12] = {31,28,31,30,31,30,31,31,30,31,30,31};
> -
> -		days = year * 365;
> -		if (year > 2)
> -			days += (year+1) / 4;
> -		for (i = 1; i < month; i++)
> -			days += monlen[i-1];
> -		if (((year+2) % 4) == 0 && month > 2)
> -			days++;
> -		days += day - 1;
> -		crtime = ((((days * 24) + hour) * 60 + minute) * 60)
> -			+ second;
> +		crtime = mktime64(year+1970, month, day, hour, minute, second);
> 
> 		/* sign extend */
> 		if (tz & 0x80)
> -- 
> 1.9.1
> 

