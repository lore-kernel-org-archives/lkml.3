Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaAQQrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:47:35 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40470 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbaAQQrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:47:31 -0500
Message-ID: <52D95EA1.6000608@ti.com>
Date: Fri, 17 Jan 2014 10:47:29 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: ti-abb: Add support for interleaved LDO registers
References: <1389900750-27625-1-git-send-email-nm@ti.com> <20140117160821.GV17314@sirena.org.uk>
In-Reply-To: <20140117160821.GV17314@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 10:08 AM, Mark Brown wrote:
> On Thu, Jan 16, 2014 at 01:32:30PM -0600, Nishanth Menon wrote:
>> Certain platforms such as DRA7 have quirky memory maps such as:
>> PRM_ABBLDO_DSPEVE_CTRL	0x4ae07e20
>> PRM_ABBLDO_IVA_CTRL	0x4ae07e24
>> other-registers
>> PRM_ABBLDO_DSPEVE_SETUP	0x4ae07e30
>> PRM_ABBLDO_IVA_SETUP	0x4ae07e34
>>
>> These need the address allocation to be either shared OR unique
>> allocation per register instance.
> 
> Is there a system controller involved here by any chance?
> 
Nope. ABB LDO module is a standalone instance whose register set
happens to be part of a memory range, as I recently got to know, is a
favorite for our hardware designers to put "misc" modules at SoC
integration time - Sigh! I guess I have made more than enough stink
about this internally already :(.

-- 
Regards,
Nishanth Menon
