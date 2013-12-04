Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab3LDM5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:57:51 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:34119 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932201Ab3LDM5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:57:48 -0500
Message-ID: <529F2677.3070208@schinagl.nl>
Date: Wed, 04 Dec 2013 13:56:23 +0100
From: Oliver Schinagl <oliver@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: grant.likely@linaro.org,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dev@linux-sunxi.org,
        maxime.ripard@free-electrons.com, ijc@hellion.org.uk,
        hdegoede@redhat.com, oliver+list@schinagl.nl
Subject: Re: [PATCH 2/3] ARM: sunxi: Add an ahci-platform compatible AHCI
 driver for the Allwinner SUNXi series of SoCs
References: <1386159055-10264-1-git-send-email-oliver@schinagl.nl> <1386159055-10264-3-git-send-email-oliver@schinagl.nl> <20131204123708.GD3158@htj.dyndns.org>
In-Reply-To: <20131204123708.GD3158@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04-12-13 13:37, Tejun Heo wrote:
> On Wed, Dec 04, 2013 at 01:10:54PM +0100, oliver@schinagl.nl wrote:
>> From: Oliver Schinagl <oliver@schinagl.nl>
>>
>> This patch adds support for the sunxi series of SoC's by allwinner. It
>> plugs into the ahci-platform framework.
>>
>> Note: Currently it uses a somewhat hackish approach that probably needs
>> a lot more work, but does the same as the IMX SoC's.
>>
>> Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
>> ---
>>   .../devicetree/bindings/ata/ahci-sunxi.txt         |  24 ++
>>   drivers/ata/Kconfig                                |   9 +
>>   drivers/ata/Makefile                               |   1 +
>>   drivers/ata/ahci_platform.c                        |  12 +
>>   drivers/ata/ahci_sunxi.c                           | 305 +++++++++++++++++++++
> I'm not really liking the way things are going.  Do we really need
> separate drivers for each platform ahci implementation.  Are they
> really that different?  Would it be impossible to make ahci_platform
> generic enough so that we don't eventually end up with a gazillion
> ahci_XXX drivers?
I took the imx driver as example, as I wasn't sure on where to start. 
But I don't think it's possible yet without improving ahci_platform as I 
suggested in the cover letter. So if ahci_platform needs to be improved, 
I guess a separate patch series would be more appropriate?

So would it be acceptable to have this as the 2nd (and last?) 
ahci_platform driver and go from there? Or do you want to block new 
ahci_XXX drivers until ahci_platform has been improved?

Oliver
>

