Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab3ILSXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:23:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3645 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab3ILSXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:23:06 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=xO-QsMQb2p8A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=KyqusYxP5W0A:10 a=CkKqYb2iJrORr8SVaMAA:9 a=CjuIK1q_8ugA:10 a=9J5VuaLb3qoA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 12 Sep 2013 14:23:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RT]  hwlat-detector: Don't ignore threshold module
 parameter
Message-ID: <20130912142304.48e3bcf0@gandalf.local.home>
In-Reply-To: <1377842245.5422.7.camel@marge.simpson.net>
References: <20130819213324.405942342@goodmis.org>
	<1377842245.5422.7.camel@marge.simpson.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't be afraid to Cc LKML with rt kernel patches. linux-rt-users is
for users not kernel developers. People like Peter Zijlstra will never
see this patch.

On Fri, 30 Aug 2013 07:57:25 +0200
Mike Galbraith <bitbucket@online.de> wrote:

> If the user specified a threshold at module load time, use it.

This could use a little better change log.

Other than that,

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> Signed-off-by: Mike Galbraith <bitbucket@online.de>
> 
> --- a/drivers/misc/hwlat_detector.c	2013-08-30 07:16:05.387959392 +0200
> +++ b/drivers/misc/hwlat_detector.c	2013-08-30 07:10:52.958670183 +0200
> @@ -413,7 +413,7 @@ static int init_stats(void)
>  		goto out;
>  
>  	__reset_stats();
> -	data.threshold = DEFAULT_LAT_THRESHOLD;	    /* threshold us */
> +	data.threshold = threshold ?: DEFAULT_LAT_THRESHOLD;	    /* threshold us */
>  	data.sample_window = DEFAULT_SAMPLE_WINDOW; /* window us */
>  	data.sample_width = DEFAULT_SAMPLE_WIDTH;   /* width us */
>  
> 

