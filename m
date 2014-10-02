Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaJBLxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 07:53:04 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:26447 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaJBLxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 07:53:00 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
X-AuditID: cbfec7f4-b7f156d0000063c7-e3-542d3c9ae5d7
Content-transfer-encoding: 8BIT
Message-id: <542D3C96.7000400@samsung.com>
Date: Thu, 02 Oct 2014 13:52:54 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
To: Inki Dae <inki.dae@samsung.com>, Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH] drm/exynos: fix vblank handling during dpms off
References: <542B9A0E.7020206@samsung.com>
 <1412151287-12845-1-git-send-email-a.hajda@samsung.com>
 <542D13CC.5000304@samsung.com> <542D2E7C.1020904@samsung.com>
In-reply-to: <542D2E7C.1020904@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xq7qzbHRDDF70sFj0njvJZNF06BSb
	xcKHd5ktrnx9z2Yx6f4EFosX9y4CZRdcZbM42/SG3eLyrjlsFjPO72Oy2PzhJZA1GUjc/s3n
	wOvR0tzD5rH32wIWjzvX9rB5bP/2gNXjfvdxJo/e5ndsHn1bVjF6fN4kF8ARxWWTkpqTWZZa
	pG+XwJWx62U/W8Fh9opFm86zNzBOZOti5OSQEDCR+HPrHjuELSZx4d56oDgXh5DAUkaJmw+m
	sYIkeAUEJX5MvsfSxcjBwSwgL3HkUjaEqS4xZUouRPknRokPJxrYIcq1JI48bGYBsVkEVCWW
	fFvFDGKzCWhK/N18E2yvqECExMm7e8DqRQR8JWauWcwEMohZYCuzxPpV7WAJYQEXiasTPjNB
	bFjCKLFj43qwgzgFtCXOHXnFPoFRYBaS+2Yh3DcL4b4FjMyrGEVTS5MLipPScw31ihNzi0vz
	0vWS83M3MUJi58sOxsXHrA4xCnAwKvHwZjTohAixJpYVV+YeYpTgYFYS4T1lqRsixJuSWFmV
	WpQfX1Sak1p8iJGJg1OqgbEo4MbhExc7j0yv8lFbsDucWWur/tenOnef3whjcji8yGrT+Yry
	KXnXmyzKn7maRH5t+x7YELst5Z3D6sWcamwpq8+k/ld9rnVsn90FDcZXPPNV83vZAl5+Vg3a
	f8yaVYLv9abOxfrTeK+IHlWQ+Jf46/iiTUIGyo1sz9i2S19iiEg6F5t/mk+JpTgj0VCLuag4
	EQBRDomnewIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

+CC possible victims

On 10/02/2014 12:52 PM, Inki Dae wrote:
> On 2014년 10월 02일 17:58, Joonyoung Shim wrote:
>> Hi Andrzej,
>>
>> On 10/01/2014 05:14 PM, Andrzej Hajda wrote:
>>> The patch disables vblanks during dpms off only if pagefilp has
>>> not been finished. It also replaces drm_vblank_off with drm_crtc_vblank_put.
>>> It fixes issue with page_flip ioctl not being able to acquire vblank counter.
>> This problem isn't related with pageflip, it just causes from
>> 7ffd7a68511c710b84db3548a1997fd2625f580a commit (drm: Always reject
>> drm_vblank_get() after drm_vblank_off()).
>>
>> We need to use drm_vblank_on() as a counterpart to drm_vblank_off()
>> after the commit .

This patch should break also other drivers, it seems at least following
drms could be affected:
armada, sti, tegra.

I guess after disabling and re-enabling crtc vblanks should stop
working, unless there are other bugs.

Regards
Andrzej

