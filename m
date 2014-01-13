Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaAMToB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:44:01 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57649 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbaAMTn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:43:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Feng Kan <fkan@apm.com>
Subject: Re: [PATCH V2 1/6] Documentation: add dts binding for X-Gene reboot dts node.
Date: Mon, 13 Jan 2014 20:43:51 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
References: <1389135041-16062-1-git-send-email-fkan@apm.com> <201401131619.35030.arnd@arndb.de> <CAL85gmCTsxng3jCaAcCjePE6Pxu7Jg98TDUqQrDFzsfW2GQwEg@mail.gmail.com>
In-Reply-To: <CAL85gmCTsxng3jCaAcCjePE6Pxu7Jg98TDUqQrDFzsfW2GQwEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401132043.52491.arnd@arndb.de>
X-Provags-ID: V02:K0:AMxYXJhJITb/GN6YTSC+7MrvAICASYGLI3IXZkbpl09
 TqQ3EjRMYZVJD/gFfTikmJeDl2lDOozveqqIluaacdU1Oi87T7
 UPvJeFXfAFkipF1+wP2iUKA8riMIDm9LyYb33RPjrHGUAjKlrN
 w15S0444v0uU9e8Ru/Pk5e3n4iq1+rEL+RDr0MCtCAGsbwL1dA
 4NsQ1XBY0YQJ4EBE9uM9Awm5ptvO1NzC7EUe6ur/ENkd2ej/9A
 zQE9GTGeIlyWIzN9V4ChCl1C6xmrenaC+S1v3wvJHeK99zdek2
 uL3DU1Tqp0rWHOuStVtVyN2rel96Qd68KSDeuoMgftsMRUG7Ao
 Jfdpp/iQTNPOPNl3mjLg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 January 2014, Feng Kan wrote:
> FKAN: I could remove this dts node and create another dts node that
> describe the range of registers on the SCU and use that node in this driver.
> I am not sure which subsystem I can use to handle this case, I do see a reset
> subsystem in the kernel but more used for ip resets. Please kindly let
> me know. Thanks for the great feedback.

Is this related to the standard ARM SCU that manages multiprocessor
systems, or a different unit that uses the same name?

Since this is a global register range with a variety of things in it,
the best candidate IMHO would be to use the "syscon" driver. You can
mark the device node as 'compatible="apm,xgene-scu","syscon"' to let
it get picked up by the drivers/mfd/syscon driver, which creates
a "regmap" structure for it.

The reset driver then uses a DT reference with a phandle to the
SCU node and calls syscon_regmap_lookup_by_phandle() to get the
regmap. It can get the register number inside the regmap from DT
as well and use the regmap API to perform the reset.

	Arnd
