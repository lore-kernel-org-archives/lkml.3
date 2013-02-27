Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab3B0KLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 05:11:42 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:61862 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab3B0KLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 05:11:40 -0500
MIME-Version: 1.0
In-Reply-To: <20130226235918.530615135@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
	<20130226235918.530615135@linuxfoundation.org>
Date: Wed, 27 Feb 2013 11:11:38 +0100
Message-ID: <CAMeQTsadxx_hEkJ0Jd5wHp2UNERh1+c5Z-VV-Zi4=xz=VJ3d+A@mail.gmail.com>
Subject: Re: [ 54/86] drm/i915: Set i9xx sdvo clock limits according to specifications
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 1:08 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
>
> commit 4f7dfb6788dd022446847fbbfbe45e13bedb5be2 upstream.
>
> The Intel PRM says the M1 and M2 divisors must be in the range of 10-20 and 5-9.
> Since we do all calculations based on them being register values (which are
> subtracted by 2) we need to specify them accordingly.
>
> Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
> Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=56359
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  drivers/gpu/drm/i915/intel_display.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -142,8 +142,8 @@ static const intel_limit_t intel_limits_
>         .vco = { .min = 1400000, .max = 2800000 },
>         .n = { .min = 1, .max = 6 },
>         .m = { .min = 70, .max = 120 },
> -       .m1 = { .min = 10, .max = 22 },
> -       .m2 = { .min = 5, .max = 9 },
> +       .m1 = { .min = 8, .max = 18 },
> +       .m2 = { .min = 3, .max = 7 },
>         .p = { .min = 5, .max = 80 },
>         .p1 = { .min = 1, .max = 8 },
>         .p2 = { .dot_limit = 200000,

Is this really stable material? It fixes no known issues and the bug
report seems to be a different problem.

-Patrik
