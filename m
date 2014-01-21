Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbaAUWcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:32:18 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60913 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067AbaAUWcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:32:14 -0500
Message-ID: <52DEF56C.1000209@ti.com>
Date: Tue, 21 Jan 2014 16:32:12 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: ti-abb: Add support for interleaved LDO registers
References: <1389900750-27625-1-git-send-email-nm@ti.com> <20140121185553.GW17314@sirena.org.uk> <52DED341.3030503@ti.com> <20140121215624.GC17314@sirena.org.uk>
In-Reply-To: <20140121215624.GC17314@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 03:56 PM, Mark Brown wrote:
> On Tue, Jan 21, 2014 at 02:06:25PM -0600, Nishanth Menon wrote:
> 
>> Without this change, on DRA7 I get:
>> [    0.579500] abb_mpu: 1060 <--> 1210 mV
>> [    0.580321] abb_ivahd: 1055 <--> 1250 mV
>> [    0.580583] ti_abb 4ae07e20.regulator-abb-dspeve: can't request
>> region for resource [mem 0x4ae07e20-0x4ae07e2f]
>> [    0.580610] ti_abb: probe of 4ae07e20.regulator-abb-dspeve failed
>> with error -16
>> [    0.581216] abb_gpu: 1090 <--> 1280 mV
> 
> OK, that's not to do with nocache, that's to do with duplicate
> request_mem_region() calls.  Of course the trick here is that if the
> other thing that requests the memory region doesn't do it then we have a
> problem.  
Yes. Both mappings are for ABB driver itself due to the interleaved
addresses for two ABB instances :(

> 
> I really can't help thinking that a system controller node as the parent
> is going to make things happier for devices that share this register
> bank.  I guess it might be possible to also do it with single register
> memory regions but I'd not be surprised if that wasn't possible and it
> doesn't seem as idiomatic.
> 
I am tempted by syscon and using regmap. but doing a syscon on entire
control module has impact to a bunch of drivers as you can expect.

The other alternative will be to use reg-names and map individual
registers (there are just setup and control registers to deal with per
abb instance). That will coexist with other pinctrl, bandgap and other
drivers which are not based off syscon.


-- 
Regards,
Nishanth Menon
