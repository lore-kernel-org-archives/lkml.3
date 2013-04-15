Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab3DOQVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:21:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39910 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab3DOQVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:21:39 -0400
Message-ID: <516C2905.8000200@ti.com>
Date: Mon, 15 Apr 2013 19:21:25 +0300
From: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Grygorii Strashko <grygorii.strashko@ti.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Nishanth Menon <nm@ti.com>, Tero Kristo <t-kristo@ti.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC v1] regulator: core: introduce regulator chain locking scheme
References: <1366031015-17073-1-git-send-email-grygorii.strashko@ti.com> <1366031015-17073-2-git-send-email-grygorii.strashko@ti.com> <20130415155040.GD15837@opensource.wolfsonmicro.com>
In-Reply-To: <20130415155040.GD15837@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.145.64]
X-EXCLAIMER-MD-CONFIG: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 04/15/2013 06:50 PM, Mark Brown wrote:
>> In addition, such locking scheme allows to have access to the supplier
>> regulator API from inside child's (consumer) regulator API.
> I've still not seen any use case articulated for doing this...
Use case is introduced in ABB series:

http://www.mail-archive.com/linux-omap@vger.kernel.org/msg88293.html

During voltage scaling we would like to have the following sequence:

cpufreq_cpu0
     |
     |---> set_voltage(ABB)
                 |
                 |->set_voltage(AVS)
                         |
                         |-->set_voltage(smps123)


Where smps123 is a regulator, connected ot i2c bus. In this particular 
case "regulator chain" guarantees proper order of calls of voltage 
scaling sequence.

Regards,
Andrii
