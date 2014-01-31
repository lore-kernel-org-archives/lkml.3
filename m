Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbaAaOWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:22:07 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:51779
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753963AbaAaOWF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:22:05 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VPS-6(z579ehz9371I103dK542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275dh1de097hz2dh109h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h22d0h2336h2438h2461h2487h24d7h2516h1155h)
X-WSS-ID: 0N09RWG-08-AZB-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: drm/radeon/dpm: fix uninitialized read from stack in
 kv_dpm_late_enable
Thread-Topic: drm/radeon/dpm: fix uninitialized read from stack in
 kv_dpm_late_enable
Thread-Index: AQHPHiqgl4bmHAqS5Uy0KM2EnAp1O5qe4ybw
Date: Fri, 31 Jan 2014 14:21:56 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D03EC73132@satlexdag05.amd.com>
References: <20140131021730.GA11601@redhat.com>
In-Reply-To: <20140131021730.GA11601@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.180.168.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Dave Jones [mailto:davej@redhat.com]
> Sent: Thursday, January 30, 2014 9:18 PM
> To: Linux Kernel Mailing List
> Cc: Deucher, Alexander
> Subject: drm/radeon/dpm: fix uninitialized read from stack in
> kv_dpm_late_enable
> 
> If we take the false branch of the if quoted in the diff below, we
> end up doing a return ret, without ever having initialized it.
> 
> Picked up by coverity.
> 
> Signed-off-by: Dave Jones <davej@fedoraproject.org>

Applied.  Thanks!

Alex

> 
> diff --git a/drivers/gpu/drm/radeon/kv_dpm.c
> b/drivers/gpu/drm/radeon/kv_dpm.c
> index b6e01d5d2cce..351db361239d 100644
> --- a/drivers/gpu/drm/radeon/kv_dpm.c
> +++ b/drivers/gpu/drm/radeon/kv_dpm.c
> @@ -1223,7 +1223,7 @@ int kv_dpm_enable(struct radeon_device *rdev)
> 
>  int kv_dpm_late_enable(struct radeon_device *rdev)
>  {
> -	int ret;
> +	int ret = 0;
> 
>  	if (rdev->irq.installed &&
>  	    r600_is_internal_thermal_sensor(rdev->pm.int_thermal_type)) {


