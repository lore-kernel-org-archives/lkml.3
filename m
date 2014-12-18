Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbaLRHyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 02:54:32 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:59039 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbaLRHya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 02:54:30 -0500
From: Arnd Bergmann <arnd@linaro.org>
To: Chunyan Zhang <zhang.chunyan@linaro.org>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com, john.stultz@linaro.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhang.lyra@gmail.com
Subject: Re: [PATCH v3] mtd: test: Replace timeval with ktime_t in speedtest.c and torturetest.c
Date: Thu, 18 Dec 2014 08:53:10 +0100
Message-ID: <4170676.z5yoWA4Rtc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418873011-4974-1-git-send-email-zhang.chunyan@linaro.org>
References: <1418873011-4974-1-git-send-email-zhang.chunyan@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:BJk5aANBSCGVLBOeYpIQ+3w8hebTHxSBvIvdB9cQ2J8GPUabDs9
 KMvibfjS8chJ459aXtkloTilu42o/eR20KMRtChjOIkevYrpnKyEEmtbDtmr0sih2CoRPqN
 08Jv7fucNPCvh0meDbeHP6mRTm6tCH4jxjmn+E2AaxJqdTBygdEAcY2lmfbcuxMwfNc/5BE
 VBopYNkUvFoEo/TUOvj3w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 December 2014 11:23:31 Chunyan Zhang wrote:
> This patch changes the 32-bit time type (timeval) to the 64-bit one
> (ktime_t), since 32-bit time types will break in the year 2038.
> 
> I use ktime_t instead of timeval to define 'start' and 'finish'
> which are used to get the time for tow points.
> 
> This patch also changes do_gettimeofday() to ktime_get() accordingly,
> since ktime_get returns a ktime_t, but do_gettimeofday returns a
> struct timeval, and the other reason is that ktime_get() uses
> the monotonic clock.
> 
> This patch is based on another patch which privides a millisecond
> time difference function 'ktime_ms_delta' in ktime.h
> 
> http://lkml.iu.edu//hypermail/linux/kernel/1412.2/00625.html
> 
> Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> 

The new version still looks good to me, but as there is now a
dependency on another patch, I'd suggest we queue this up in the
y2038 branch together with the patch that introduces ktime_ms_delta.

David or Brian, can you provide an Ack for this, or do you have
any objections?

	Arnd
