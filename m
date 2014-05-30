Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768AbaE3QMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:12:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56104 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbaE3QMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:12:47 -0400
Message-ID: <5388ADFB.1060505@wwwdotorg.org>
Date: Fri, 30 May 2014 10:12:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3/5] misc: fuse: Add efuse driver for Tegra
References: <1401281677-32110-1-git-send-email-pdeschrijver@nvidia.com> <1401281677-32110-4-git-send-email-pdeschrijver@nvidia.com> <538784C1.6000504@wwwdotorg.org> <20140530113618.GQ5961@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20140530113618.GQ5961@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 05:36 AM, Peter De Schrijver wrote:
> On Thu, May 29, 2014 at 09:04:33PM +0200, Stephen Warren wrote:
>> On 05/28/2014 06:54 AM, Peter De Schrijver wrote:
>>> Implement fuse driver for Tegra20, Tegra30, Tegra114 and Tegra124.
>>
>>> diff --git a/Documentation/ABI/testing/sysfs-driver-tegra-fuse b/Documentation/ABI/testing/sysfs-driver-tegra-fuse
>>
>>> +Description:	read-only access to the efuses on Tegra20, Tegra30, Tegra114
>>> +		and Tegra124 SoC's from NVIDIA. The efuses contain write once
>>> +		data programmed at the factory. The data is layed out in 32bit
>>> +		words in LSB first formnat. The number of valid bits depends
>>
>> s/formnat/format/
>>
>>> +		on the word and the SoC. The mapping is as follows:
>>> +
>>> +		For Tegra20:
>>> +		Word 0 - 1    : bit 0
>>> +		Word 2        : unused
>>> +		Word 3        : bits 0 - 31
>>> +		Word 4        : bits 0 - 7
>>
>> Do we really need these long tables that indicate which bits are used?
>> As I mentioned before, when I asked for documentation of the format of
>> these files, all I wanted was a brief not indicating that the data was
>> binary, and that each bit potentially represents a fuse... Either we
>> should leave it at that, or actually document what each bit represents,
>> which would hopefully be a pointless duplication of the TRM.
> 
> Some fuses are OEM defined, so there is no way to document all fuses there.
> Would you be ok with just dropping the tables then?

Yes.

> So, the description would become:
> 
> Description:    read-only access to the efuses on Tegra20, Tegra30, Tegra114
>                 and Tegra124 SoC's from NVIDIA. The efuses contain write once
>                 data programmed at the factory. The data is layed out in 32bit
>                 words in LSB first format. The number of valid bits depends
>                 on the word and the SoC.

Almost. That's still missing the key information that the data format is
one bit per fuse, and the ordering. Perhaps change from:

The data is layed out in 32bit words in LSB first format.

to:

The data is laid out in 32bit words in LSB first format. Each bit
represents a single fuse value. Bits order/assignment exactly matches
the HW registers, including any unused bits.
