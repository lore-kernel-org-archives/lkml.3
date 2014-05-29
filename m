Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622AbaE2On1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:43:27 -0400
Received: from mail1.windriver.com ([147.11.146.13]:33803 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbaE2On0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 10:43:26 -0400
Date: Thu, 29 May 2014 10:43:21 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Fabian Frederick <fabf@skynet.be>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH V2 3/3] init/calibrate.c: no prefix in logging
Message-ID: <20140529144321.GB32669@windriver.com>
References: <20140529101458.047becb88f3ba83196045465@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140529101458.047becb88f3ba83196045465@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[[PATCH V2 3/3] init/calibrate.c: no prefix in logging] On 29/05/2014 (Thu 10:14) Fabian Frederick wrote:

> define pr_fmt without prefix to avoid any default prefix update

Again, it isn't clear to me what you are trying to achieve here.
The printk.h header already has the define which you add here.

A general rule for commits is to cover off three points.

1) Describe what the user visible symptom is, i.e. "printk from
calibrate.c are appearing with verbose prefix blah blah..."

2) Describe the underlying reason for the bug/issue, i.e. "This happens
because macro blah comes from foo.h but only when bar is defined."

3) Describe how your fix works and why it is the right/best fix for the
issue, i.e. "Here we introduce blah blah which will ensure ...."

Also, to make life easier for maintainers, you probably want to add a
0/N lead-in (see --cover-letter) which describes what you are trying to
achieve with the whole series, and when you create a v2 of the series,
you need to list in there for the maintainer how v2 differs from v1.

Finally try not to send a v2 within hours of sending a v1 -- give a
chance for the v1 to get looked at 1st; typically at least one day.

Thanks,
Paul.
--

> 
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  init/calibrate.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/init/calibrate.c b/init/calibrate.c
> index fb9be44..169e98d 100644
> --- a/init/calibrate.c
> +++ b/init/calibrate.c
> @@ -4,6 +4,8 @@
>   *  Copyright (C) 1991, 1992  Linus Torvalds
>   */
>  
> +#define pr_fmt(fmt) fmt
> +
>  #include <linux/jiffies.h>
>  #include <linux/delay.h>
>  #include <linux/init.h>
> -- 
> 1.9.1
> 
