Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab3KVOcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 09:32:09 -0500
Received: from service87.mimecast.com ([91.220.42.44]:60572 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab3KVOcI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 09:32:08 -0500
Message-ID: <1385130723.3333.62.camel@hornet>
Subject: Re: linux-next: vexpress boot test failed on vexpress-a9
From: Pawel Moll <pawel.moll@arm.com>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Fathi Boudra <fathi.boudra@linaro.org>,
        "ryan.harkin@linaro.org" <ryan.harkin@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Milosz Wasilewski <milosz.wasilewski@linaro.org>
Date: Fri, 22 Nov 2013 14:32:03 +0000
In-Reply-To: <CA+G9fYs8faqriTXahi_u6btK5QcrSzQA+wwpP25s2bL4k7ooWg@mail.gmail.com>
References: <CA+G9fYs8faqriTXahi_u6btK5QcrSzQA+wwpP25s2bL4k7ooWg@mail.gmail.com>
X-Mailer: Evolution 3.8.4-0ubuntu1
Mime-Version: 1.0
X-OriginalArrivalTime: 22 Nov 2013 14:32:03.0734 (UTC) FILETIME=[9CCCF360:01CEE78F]
X-MC-Unique: 113112214320501501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-22 at 09:33 +0000, Naresh Kamboju wrote:
> Boot failed log:
> --------------------
> mmci-pl18x 10005000.mmci: dummy supplies not allowed

This message is irrelevant.

> mmci-pl18x 10005000.mmci: Failed getting OCR mask: 0
> mmci-pl18x 10005000.mmci: mmc0: PL180 manf 41 rev0 at 0x10005000 irq 41,42 (pio)
> mmci-pl18x 10005000.mmci: no support for card's volts
>
> mmc0: error -22 whilst initialising SD card
> mmci-pl18x 10005000.mmci: no support for card's volts
> mmc0: error -22 whilst initialising SD card
>
> This issue was reported by QA team and fixed by Fathi [1] couple of
> months back. Now this patch is applied on mainline [2]. But boot test
> still failed [4].

Just tried, seems to work for me:

/ # uname -a
Linux (none) 3.12.0-next-20131122 #3 SMP Fri Nov 22 09:48:12 GMT 2013 armv7l GNU/Linux
/ # dmesg | grep mmc
mmci-pl18x 10005000.mmci: dummy supplies not allowed
mmci-pl18x 10005000.mmci: mmc0: PL180 manf 41 rev0 at 0x10005000 irq 41,42 (pio)
mmc0: new SD card at address 88f7
mmcblk0: mmc0:88f7 SD02G 1.84 GiB 
 mmcblk0: p1 p2

It's next-20131122 compiled with vexpress_defconfig and stock tree.

Paweł





