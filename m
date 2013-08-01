Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab3HAPyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:54:47 -0400
Received: from [213.199.154.249] ([213.199.154.249]:18050 "EHLO
	db9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756281Ab3HAPyq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:54:46 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h17326ah1de096h8275bh8275dh1de097hz2dh668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
X-WSS-ID: 0MQV01S-01-6UQ-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Tim Gardner <tim.gardner@canonical.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: David Airlie <airlied@linux.ie>
Subject: RE: [PATCH 3.11-rc3+] radeon: si_dpm: Fix 32 bit __divdi3 modpost
 failure
Thread-Topic: [PATCH 3.11-rc3+] radeon: si_dpm: Fix 32 bit __divdi3 modpost
 failure
Thread-Index: AQHOjstvlJjiuOL970CgdA9S5nF3qZmAgBYA
Date: Thu, 1 Aug 2013 15:51:28 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02E52D8FE@sausexdag04.amd.com>
References: <1375370731-64547-1-git-send-email-tim.gardner@canonical.com>
In-Reply-To: <1375370731-64547-1-git-send-email-tim.gardner@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.10.244]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've already got the fix queued in my -fixes branch:
http://cgit.freedesktop.org/~agd5f/linux/commit/?h=drm-fixes-3.11&id=1d2867b98372929129c7f2ce2c83a9b446a1b43a


> -----Original Message-----
> From: Tim Gardner [mailto:tim.gardner@canonical.com]
> Sent: Thursday, August 01, 2013 11:26 AM
> To: dri-devel@lists.freedesktop.org; linux-kernel@vger.kernel.org
> Cc: Tim Gardner; David Airlie; Deucher, Alexander
> Subject: [PATCH 3.11-rc3+] radeon: si_dpm: Fix 32 bit __divdi3 modpost
> failure
> 
> ERROR: "__divdi3" [drivers/gpu/drm/radeon/radeon.ko] undefined!
> make[3]: *** [__modpost] Error 1
> 
> gcc version 4.8.1
> 
> Cc: David Airlie <airlied@linux.ie>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/gpu/drm/radeon/si_dpm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/radeon/si_dpm.c
> b/drivers/gpu/drm/radeon/si_dpm.c
> index 7ad22e87..4182557 100644
> --- a/drivers/gpu/drm/radeon/si_dpm.c
> +++ b/drivers/gpu/drm/radeon/si_dpm.c
> @@ -1767,7 +1767,7 @@ static void
> si_calculate_leakage_for_v_and_t_formula(const struct ni_leakage_coe
>  	s64 temperature, t_slope, t_intercept, av, bv, t_ref;
>  	s64 tmp;
> 
> -	i_leakage = drm_int2fixp(ileakage) / 100;
> +	i_leakage = div64_s64(drm_int2fixp(ileakage), 100);
>  	vddc = div64_s64(drm_int2fixp(v), 1000);
>  	temperature = div64_s64(drm_int2fixp(t), 1000);
> 
> --
> 1.7.9.5
> 


