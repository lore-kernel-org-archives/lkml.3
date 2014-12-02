Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602AbaLCAEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:04:23 -0500
Received: from lvnode1.ve.v10networks.ca ([209.141.36.111]:45101 "EHLO
	lvnode1.ve.v10networks.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271AbaLCAEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:04:22 -0500
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2014 19:04:21 EST
Content-class: urn:content-classes:message
Subject: RE: [PATCH 1/1] X86: Mark the Hyper-V clocksource as being continuous
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Date: Tue, 2 Dec 2014 15:57:50 -0800
Message-ID: <A70AC0C1B7E7FD478A6BF19705461AA01109C0@IMBER.smb.curriegrad2004.ca>
In-Reply-To: <1417568621-23143-1-git-send-email-kys@microsoft.com>
X-MS-Has-Attach: 
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] X86: Mark the Hyper-V clocksource as being continuous
Thread-Index: AdAOi50foAfX2fVsSiSSu7Ia31mqHwAACfVw
References: <1417568621-23143-1-git-send-email-kys@microsoft.com>
From: "Jeff Leung" <jleung@v10networks.ca>
To: "K. Y. Srinivasan" <kys@microsoft.com>, <x86@kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <devel@linuxdriverproject.org>, <olaf@aepfle.de>, <apw@canonical.com>,
        <jasowang@redhat.com>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does this mean that host-to guest timesync now works properly with Linux
guests?

-- Jeff

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org]
> On Behalf Of K. Y. Srinivasan
> Sent: Tuesday, December 2, 2014 17:04
> To: x86@kernel.org; gregkh@linuxfoundation.org;
linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; tglx@linutronix.de; hpa@zytor.com
> Cc: K. Y. Srinivasan; stable@vger.kernel.org
> Subject: [PATCH 1/1] X86: Mark the Hyper-V clocksource as being
continuous
> 
> The clocksource based on Hyper-V per-partition reference count MSR is
continuous. Mark
> it accordingly.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> cc: stable@vger.kernel.org
> ---
>  arch/x86/kernel/cpu/mshyperv.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mshyperv.c
b/arch/x86/kernel/cpu/mshyperv.c index
> a450373..939155f 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -107,6 +107,7 @@ static struct clocksource hyperv_cs = {
>  	.rating		= 400, /* use this when running on Hyperv*/
>  	.read		= read_hv_clock,
>  	.mask		= CLOCKSOURCE_MASK(64),
> +	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
>  };
> 
>  static void __init ms_hyperv_init_platform(void)
> --
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
linux-kernel" in the body of a
> message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

