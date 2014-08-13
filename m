Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbaHMCxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 22:53:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:62008 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbaHMCxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 22:53:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,854,1400050800"; 
   d="scan'208";a="584086407"
Message-ID: <53EAD278.2010003@intel.com>
Date: Wed, 13 Aug 2014 10:50:32 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
CC: torvalds@linux-foundation.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] I2C: Make I2C core able to be module when I2C_ACPI is
 selected.
References: <1407740455-21269-1-git-send-email-tianyu.lan@intel.com> <20140812095321.GU1657@lahna.fi.intel.com> <20140813020250.GA2853@katana>
In-Reply-To: <20140813020250.GA2853@katana>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年08月13日 10:03, Wolfram Sang wrote:
> On Tue, Aug 12, 2014 at 12:53:21PM +0300, Mika Westerberg wrote:
>> On Mon, Aug 11, 2014 at 03:00:55PM +0800, Lan Tianyu wrote:
>>> Commit da3c6647(I2C/ACPI: Clean up I2C ACPI code and Add CONFIG_I2C_ACPI
>>> config) adds a new kernel config I2C_ACPI and make I2C core built in
>>> when the config is selected. This is wrong because distributions
>>> etc generally compile I2C as a module and the commit broken that.
>>> This patch is to make I2C core able to be a module when I2C_ACPI is
>>> selected. Original issue the commit da3c6647 tried to avoid will
>>> be fixed in ACPICA and it's rarely triggered during unloading module. 
>>>
>>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>>
>> I wonder if we can do
>>
>> 	depends on I2C=y
>>
>> here? If I understand it right, then we only build the ACPI_I2C if I2C
>> is compiled into the kernel. That way the problem da3c6647 tried to
>> solve doens't re-appear.
>>
>> We can later on relax this once ACPICA has been fixed. Thoughts?
> 
> I had the same idea yet my travel to Chicago interrupted thinking about
> it further. Once I get rid of my jetlag, I'll have a closer look. Unless
> you already came up with the perfect solution until then, of course ;)
>

Hi Mika & Wolfram:
	I have one concern about "depends on I2C=y". If distribution config
file selects I2C core as a module, the original code can enumerate I2C
slave devices from ACPI table. But now I2C_ACPI depends on I2C core
built in, the I2C module can't enumerate devices from ACPI table. This
maybe a regression for distribution?

-- 
Best regards
Tianyu Lan
