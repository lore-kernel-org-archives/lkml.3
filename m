Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaCVRCL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 13:02:11 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:11433
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751883AbaCVRCI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 13:02:08 -0400
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zzc89bh1443I1432Izz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh8275dh1de097h186068hz2dh839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
X-WSS-ID: 0N2UKN7-07-3HF-02
X-M-MSG: 
Message-ID: <532DC200.7070409@amd.com>
Date: Sat, 22 Mar 2014 18:01:52 +0100
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [bisected] drm/radeon: fences regression
References: <532DA935.4010907@odi.ch>
In-Reply-To: <532DA935.4010907@odi.ch>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
X-Originating-IP: [10.224.155.56]
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ortwin,

unfortunately the iMacs are notorious problematic and it's likely that 
something didn't worked before and you never noticed it because the 
kernel didn't complained. Have you ever tried to use UVD on that system?

On the other hand the failed UVD init shouldn't affect the rest of the 
system (3D should work fine), so there is really something odd here.

Please open up a bug report on 
https://bugs.freedesktop.org/enter_bug.cgi?product=DRI component 
DRM/Radeon and attach at least the full dmesg output of 3.13 as well as 
3.12.

Thanks in advance,
Christian.

Am 22.03.2014 16:16, schrieb Ortwin Glück:
> Hi,
>
> I am seeing a GPU lockup from any v3.13 up to 3.14-rc7, which 
> basically renders my computer unusable under recent kernels :-(
>
> [   55.762710] radeon 0000:01:00.0: GPU lockup CP stall for more than 
> 10000msec
> [   55.762715] radeon 0000:01:00.0: GPU lockup (waiting for 
> 0x0000000000000004 last fence id 0x000000000000000 on ring 5)
> [   55.762717] [drm:uvd_v1_0_ib_test] *ERROR* radeon: fence wait 
> failed (-35).
> [   55.762720] [drm:radeon_ib_ring_tests] *ERROR* radeon: failed 
> testing IB on ring 5 (-35).
>
> Hardware is an iMac 11,2 with a Radeon 4670 M96XT (RV730), 256MB GDDR3.
>
>
> Bisected to this commit:
>
> commit f9eaf9ae782d6480f179850e27e6f4911ac10227
> Author: Christian König <christian.koenig@amd.com>
> Date:   Tue Oct 29 20:14:47 2013 +0100
>
>     drm/radeon: rework and fix reset detection v2
>
>     Stop fiddling with jiffies, always wait for 
> RADEON_FENCE_JIFFIES_TIMEOUT.
>     Consolidate the two wait sequence implementations into just one 
> function.
>     Activate all waiters and remember if the reset was already done 
> instead of
>     trying to reset from only one thread.
>
>     v2: clear reset flag earlier to avoid timeout in IB test
>
> Unfortunately this patch no longer cleanly unapplies on v3.13.


