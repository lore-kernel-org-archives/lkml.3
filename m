Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaANLoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:44:11 -0500
Received: from plane.gmane.org ([80.91.229.3]:51540 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbaANLoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:44:09 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH 1/2] lib/lcm.c: Ensure correct result whenever it fits
Date: Tue, 14 Jan 2014 12:43:51 +0100
Organization: D03
Message-ID: <87y52i94aw.fsf@rasmusvillemoes.dk>
References: <1387291572-12348-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-17.imf.au.dk
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Cancel-Lock: sha1:N8G+J6dExsto36qfAh1tM5IdRbY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:

Ping...

> Ensure that lcm(a,b) returns the mathematically correct result,
> provided it fits in an unsigned long. The current version returns
> garbage if a*b overflows, even if the final result would fit.
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
> There are of course still plenty of cases where the return value is
> wrong.
>
>  lib/lcm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/lcm.c b/lib/lcm.c
> index b9c8de4..01b3aa9 100644
> --- a/lib/lcm.c
> +++ b/lib/lcm.c
> @@ -7,7 +7,7 @@
>  unsigned long lcm(unsigned long a, unsigned long b)
>  {
>  	if (a && b)
> -		return (a * b) / gcd(a, b);
> +		return (a / gcd(a, b)) * b;
>  	else if (b)
>  		return b;

