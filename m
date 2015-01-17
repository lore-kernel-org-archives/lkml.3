Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbbAQXiF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 18:38:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbbAQXiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 18:38:03 -0500
Date: Sat, 17 Jan 2015 15:09:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Shirish Gajera <gajerashirish@gmail.com>
Cc: eric.rost@mybabylon.net, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: skein: Remove all do{} while (0) loop from
 single statement.
Message-ID: <20150117230940.GA20797@kroah.com>
References: <20150111234105.GA2744@shirish-ThinkPad-Edge-E430>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150111234105.GA2744@shirish-ThinkPad-Edge-E430>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 03:41:05PM -0800, Shirish Gajera wrote:
> This patch fixes the checkpatch.pl warning:
> 
> WARNING: Single statement macros should not use a do {} while (0) loop
> 
> I remove do while from the single statement macro.
> 
> Signed-off-by: Shirish Gajera <gajerashirish@gmail.com>
> ---
>  drivers/staging/skein/skein_block.c | 31 +++++++++----------------------
>  1 file changed, 9 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
> index 66261ab..f89b410 100644
> --- a/drivers/staging/skein/skein_block.c
> +++ b/drivers/staging/skein/skein_block.c
> @@ -67,10 +67,8 @@ do {                                         \
>  } while (0)
>  
>  #if SKEIN_UNROLL_256 == 0
> -#define R256(p0, p1, p2, p3, ROT, r_num) /* fully unrolled */ \
> -do {                                                          \
> -	ROUND256(p0, p1, p2, p3, ROT, r_num);                 \
> -} while (0)
> +#define R256(p0, p1, p2, p3, ROT, r_num)	\
> +	ROUND256(p0, p1, p2, p3, ROT, r_num)
>  
>  #define I256(R)                                                           \
>  do {                                                                      \
> @@ -82,10 +80,7 @@ do {                                                                      \
>  } while (0)
>  #else
>  /* looping version */
> -#define R256(p0, p1, p2, p3, ROT, r_num) \
> -do { \
> -	ROUND256(p0, p1, p2, p3, ROT, r_num); \
> -} while (0)
> +#define R256(p0, p1, p2, p3, ROT, r_num) ROUND256(p0, p1, p2, p3, ROT, r_num)
>  
>  #define I256(R) \
>  do { \
> @@ -154,10 +149,8 @@ do {                                                         \
>  } while (0)
>  
>  #if SKEIN_UNROLL_512 == 0
> -#define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num) /* unrolled */ \
> -do {                                                                    \
> -	ROUND512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num);           \
> -} while (0)
> +#define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num)	\
> +	ROUND512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num)
>  
>  #define I512(R)                                                           \
>  do {                                                                      \
> @@ -173,10 +166,8 @@ do {                                                                      \
>  } while (0)
>  
>  #else /* looping version */
> -#define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num)                 \
> -do {                                                                     \
> -	ROUND512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num);            \
> -} while (0)
> +#define R512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num)		\
> +	ROUND512(p0, p1, p2, p3, p4, p5, p6, p7, ROT, r_num)
>  
>  #define I512(R)                                                           \
>  do {                                                                      \
> @@ -263,10 +254,8 @@ do {                                                                          \
>  #if SKEIN_UNROLL_1024 == 0
>  #define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, \
>  	      ROT, rn)                                                        \
> -do {                                                                          \
>  	ROUND1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
> -		  pF, ROT, rn);                                               \
> -} while (0)
> +		  pF, ROT, rn)
>  
>  #define I1024(R)                                                          \
>  do {                                                                      \
> @@ -291,10 +280,8 @@ do {                                                                      \
>  #else /* looping version */
>  #define R1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, pF, \
>  	      ROT, rn)                                                        \
> -do {                                                                          \
>  	ROUND1024(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, pA, pB, pC, pD, pE, \
> -		  pF, ROT, rn);                                               \
> -} while (0)
> +		  pF, ROT, rn)
>  
>  #define I1024(R)                                                           \
>  do {                                                                       \
> -- 
> 1.9.1

Doesn't apply to my tree :(
