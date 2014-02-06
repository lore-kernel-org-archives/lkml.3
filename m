Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbaBFQqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:46:03 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54912 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbaBFQqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:46:00 -0500
Message-ID: <52F3BC41.1030901@wwwdotorg.org>
Date: Thu, 06 Feb 2014 09:45:53 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Danny Huang <dahuang@nvidia.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 3/6] misc: fuse: Add efuse driver for Tegra
References: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com> <1390952176-30402-4-git-send-email-pdeschrijver@nvidia.com> <52F28DE2.1040207@wwwdotorg.org> <20140206091114.GK19389@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20140206091114.GK19389@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 02:11 AM, Peter De Schrijver wrote:
> On Wed, Feb 05, 2014 at 08:15:46PM +0100, Stephen Warren wrote:
>> On 01/28/2014 04:36 PM, Peter De Schrijver wrote:
>>> Implement fuse driver for Tegra20, Tegra30, Tegra114 and Tegra124.

>>> diff --git a/Documentation/ABI/testing/sysfs-driver-tegra-fuse b/Documentation/ABI/testing/sysfs-driver-tegra-fuse
>>> +What:		/sys/devices/*/<our-device>/fuse
>>> +Date:		December 2013
>>> +Contact:	Peter De Schrijver <pdeschrijver@nvidia.com>
>>> +Description:	read-only access to the efuses on Tegra20, Tegra30, Tegra114
>>> +		and Tegra124 SoC's from NVIDIA. The efuses contain write once
>>> +		data programmed at the factory.
>>> +Users:		any user space application which wants to read the efuses on
>>> +		Tegra SoC's
>>
>> Surely this file should describe the format of the file, since that's
>> part of the ABI too, right?
>>
> 
> Part of the fuse data is ODM defined so possibly board specific.

I didn't mean the interpretation of which fuses mean what semantically,
but rather the data format of the file. IIRC looking at the code, it's
just a binary dump of the fuses, but it might be worth spelling out that
it's a byte-oriented binary file, with fuse 0 in bit 0 of byte 0 etc.?

