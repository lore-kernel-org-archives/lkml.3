Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968052Ab3HIQXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:23:40 -0400
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:35190
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934397Ab3HIQXj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:23:39 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h17326ah1de096h8275bh8275dh1de097hz2dh668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1155h)
X-WSS-ID: 0MR9UUB-02-6U0-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Andi Kleen <ak@linux.intel.com>, "airlied@linux.ie" <airlied@linux.ie>
Subject: RE: [PATCH] radeon: Use Linux division macro in
 si_calculate_leakage_for_v_and_t_formula
Thread-Topic: [PATCH] radeon: Use Linux division macro in
 si_calculate_leakage_for_v_and_t_formula
Thread-Index: AQHOlRlUcb3Agc3om0+FYGno+7EDR5mNDy3Q
Date: Fri, 9 Aug 2013 16:22:59 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02E538681@sausexdag04.amd.com>
References: <1376063907-7770-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1376063907-7770-1-git-send-email-andi@firstfloor.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.177.96.15]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix is already merged:
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=adfb8e51332153016857194b85309150ac560286


> -----Original Message-----
> From: Andi Kleen [mailto:andi@firstfloor.org]
> Sent: Friday, August 09, 2013 11:58 AM
> To: linux-kernel@vger.kernel.org
> Cc: Andi Kleen; airlied@linux.ie; Deucher, Alexander
> Subject: [PATCH] radeon: Use Linux division macro in
> si_calculate_leakage_for_v_and_t_formula
> 
> From: Andi Kleen <ak@linux.intel.com>
> 
> This fixes my 32bit build which failed with:
> 
> drivers/built-in.o: In function
> `si_calculate_leakage_for_v_and_t_formula':
> /home/ak/lsrc/git/linux-2.6/drivers/gpu/drm/radeon/si_dpm.c:1770:
> undefined reference to `__divdi3'
> 
> Cc: airlied@linux.ie
> Cc: alexander.deucher@amd.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  drivers/gpu/drm/radeon/si_dpm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/radeon/si_dpm.c
> b/drivers/gpu/drm/radeon/si_dpm.c
> index 7ad22e8..4182557 100644
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
> 1.8.3.1
> 


