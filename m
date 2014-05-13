Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761065AbaEMK1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:27:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49976 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760964AbaEMK1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:27:15 -0400
Message-ID: <5371F35B.6090909@ti.com>
Date: Tue, 13 May 2014 13:26:35 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>, <joelf@ti.com>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: Re: [PATCH 0/4] ARM/DT: edma: Get IP configuration from hardware
References: <1399967028-24757-1-git-send-email-peter.ujfalusi@ti.com> <5371D8D8.8000003@ti.com>
In-Reply-To: <5371D8D8.8000003@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 11:33 AM, Sekhar Nori wrote:
> On Tuesday 13 May 2014 01:13 PM, Peter Ujfalusi wrote:
>> Hi,
>>
>> We are requesting redundant information via DT for the driver since the very same
>> data is available in the HW: by reading and decoding the content of CCCFG
>> register we can get:
>> Number of channels: NUM_DMACH
>> Number of regions: NUM_REGN
>> Number of slots (PaRAM sets): NUM_PAENTRY
>> Number of TC/EQ: NUM_EVQUE
>>
>> So these does not need to be provided by the DT binding.
>>
>> The driver will no longer look for these properties from DT and they can be
>> removed from the binding documentation and from the dtsi files as well.
>> The change will not introduce regression when new kernel is booted using older
>> DTB (since we just ignore the mentioned properties).
> 
> Peter, to which baseline do these patches apply? I tried applying them
> to v3.15-rc5 but 1/4 doesn't apply cleanly.

It is on top of next-20140509.
Now that I looked at my branch, I missed one small patch from the series which
could cause the issue (removing the memset from edma_of_parse_dt).

I'll resend ASAP with that patch included.

> 
> Thanks,
> Sekhar
> 


-- 
Péter
