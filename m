Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033Ab3GaEBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 00:01:37 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:28900
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735Ab3GaEBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 00:01:36 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Wang Dongsheng-B40534 <B40534@freescale.com>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michael@ellerman.id.au" <michael@ellerman.id.au>,
        "srivatsa.bhat@linux.vnet.ibm.com" <srivatsa.bhat@linux.vnet.ibm.com>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
CC: "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: RE: [PATCH V2 5/6] cpuidle/powerpc: Backend-powerpc idle driver for
 powernv and pseries.
Thread-Topic: [PATCH V2 5/6] cpuidle/powerpc: Backend-powerpc idle driver
 for powernv and pseries.
Thread-Index: AQHOjZo+M+JnZ6Klfk+lGV+P8Xj57Zl+Ja6A
Date: Wed, 31 Jul 2013 04:01:31 +0000
Message-ID: <ABB05CD9C9F68C46A5CEDC7F15439259FF29B4@039-SN2MPN1-021.039d.mgd.msft.net>
References: <20130731025840.19448.24468.stgit@deepthi>
 <20130731025934.19448.16658.stgit@deepthi>
In-Reply-To: <20130731025934.19448.16658.stgit@deepthi>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.117]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6V41gW1008944



> 
> -static int pseries_cpuidle_add_cpu_notifier(struct notifier_block *n,
> +static int powerpc_cpuidle_add_cpu_notifier(struct notifier_block *n,
>  			unsigned long action, void *hcpu)
>  {
>  	int hotcpu = (unsigned long)hcpu;
>  	struct cpuidle_device *dev =
> -			per_cpu_ptr(pseries_cpuidle_devices, hotcpu);
> +			per_cpu_ptr(powerpc_cpuidle_devices, hotcpu);
> 
>  	if (dev && cpuidle_get_driver()) {
>  		switch (action) {
> @@ -235,16 +270,16 @@ static int pseries_cpuidle_add_cpu_notifier(struct
> notifier_block *n,
>  }
> 
>  static struct notifier_block setup_hotplug_notifier = {
> -	.notifier_call = pseries_cpuidle_add_cpu_notifier,
> +	.notifier_call = powerpc_cpuidle_add_cpu_notifier,
>  };
> 
I think Daniel means move the notifier to cpuidle framework, not just powerpc.

And should be remove all about *device*. If the notifier handle using device,
you can use "cpuidle_devices".

- dongsheng

> -static int __init pseries_processor_idle_init(void)
> +static int __init powerpc_processor_idle_init(void)
>  {
>  	int retval;
> 
> -	retval = pseries_idle_probe();
> +	retval = powerpc_idle_probe();
>  	if (retval)
>  		return retval;
> 
> -	pseries_cpuidle_driver_init();
> -	retval = cpuidle_register_driver(&pseries_idle_driver);
> +	powerpc_cpuidle_driver_init();
> +	retval = cpuidle_register_driver(&powerpc_idle_driver);
>  	if (retval) {
> -		printk(KERN_DEBUG "Registration of pseries driver failed.\n");
> +		printk(KERN_DEBUG "Registration of powerpc driver failed.\n");
>  		return retval;
>  	}
> 
>  	update_smt_snooze_delay(-1, per_cpu(smt_snooze_delay, 0));
> 
> -	retval = pseries_idle_devices_init();
> +	retval = powerpc_idle_devices_init();
Should be remove all *device*, using cpuidle_register.

- dongsheng

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
