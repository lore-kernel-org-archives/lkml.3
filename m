Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbaAVUsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:48:13 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35533 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867AbaAVUsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:48:09 -0500
Message-ID: <52E02E85.3030509@ti.com>
Date: Wed, 22 Jan 2014 14:48:05 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: ti-abb: Add support for interleaved LDO registers
References: <1389900750-27625-1-git-send-email-nm@ti.com> <20140121185553.GW17314@sirena.org.uk> <52DED341.3030503@ti.com> <20140121215624.GC17314@sirena.org.uk> <52DEF56C.1000209@ti.com> <20140122201932.GD17314@sirena.org.uk>
In-Reply-To: <20140122201932.GD17314@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 02:19 PM, Mark Brown wrote:
> On Tue, Jan 21, 2014 at 04:32:12PM -0600, Nishanth Menon wrote:
> 
>> The other alternative will be to use reg-names and map individual
>> registers (there are just setup and control registers to deal with per
>> abb instance). That will coexist with other pinctrl, bandgap and other
>> drivers which are not based off syscon.
> 
> Yes, I suspect that's going to be a lot easier to deploy given that
> there are existing drivers using the current non-syscon setup.  I'm
> totally fine with that approach.
> 
ok - thanks for confirming - this also means that existing compatible
flags will have to change - but they were present solely to encode the
offset of setup and control from each other.

Considering that we never had any dtsi in upstream (since they were
all pending clock dts support for TI platforms), I will go with the
assumption of not needing to maintain backward compatible for dtbs
that could never have been generated in upstream kernel.

-- 
Regards,
Nishanth Menon
