Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab3BRF2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:28:21 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:37885 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab3BRF2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:28:17 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Wim Van Sebroeck <wim@iguana.be>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "fabio.porcedda@gmail.com" <fabio.porcedda@gmail.com>,
        "Lin, JM" <JM.Lin@atmel.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 3/8] watchdog/at91sam9_wdt: Convert to use the
 watchdog framework
Thread-Topic: [PATCH v4 3/8] watchdog/at91sam9_wdt: Convert to use the
 watchdog framework
Thread-Index: AQHOAErejbt0IsRv/EC3VNSIaMSDMph399SAgAc1hOA=
Date: Mon, 18 Feb 2013 05:27:38 +0000
Message-ID: <B256D81BAE5131468A838E5D7A24364145F0DD11@penmbx01>
References: <1359702386-21284-1-git-send-email-wenyou.yang@atmel.com>
 <1359702386-21284-4-git-send-email-wenyou.yang@atmel.com>
 <20130213231007.GE7867@spo001.leaseweb.com>
In-Reply-To: <20130213231007.GE7867@spo001.leaseweb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

> This code not only converts the watchdog to the new framework,
> but it also adds the is_enable related code changes which should
> be a seperate patch.
> 
> So I took your original patch and changed it to the below at91sam9_wdt
> watchdog conversion patch. Note: this is also without Fabio's timeout-sec
> patch, this one needs to come after the conversion.
> 
> Please test this patch and let me know if this works (the watchdog should
> behave the same before as after this patch).

Sorry for so late reply due to Chinese New Year's holiday.

I applied it on the linux-watchdog trees, 
and tested it on at91sam9m10g45ek both DT and non-DT support, at91sam9g25ek with DT support.

It works OK after one compilation error fixed.

> +	at91wdt_private.next_heartbeat = jiffies + wdd->timeout * HZ;
 +  at91wdt_private.next_heartbeat = jiffies + at91_wdt_dev.timeout * HZ;

Thank you very much.

Best Regards,
Wenyou Yang

