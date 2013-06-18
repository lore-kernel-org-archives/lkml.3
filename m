Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab3FRJ5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:57:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58129 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab3FRJ5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:57:19 -0400
Message-ID: <51C02EC7.7060908@ti.com>
Date: Tue, 18 Jun 2013 15:26:23 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <arnd@arndb.de>,
        <swarren@nvidia.com>, <sylvester.nawrocki@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <cesarb@cesarb.net>, <davem@davemloft.net>,
        <rnayak@ti.com>, <shawn.guo@linaro.org>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <nsekhar@ti.com>
Subject: Re: [PATCH v7 2/9] usb: phy: omap-usb2: use the new generic PHY framework
References: <1371113039-5784-1-git-send-email-kishon@ti.com> <1371113039-5784-3-git-send-email-kishon@ti.com> <20130618094058.GQ5461@arwen.pp.htv.fi> <51C02D0F.6010302@ti.com> <20130618095040.GZ5461@arwen.pp.htv.fi>
In-Reply-To: <20130618095040.GZ5461@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 18 June 2013 03:20 PM, Felipe Balbi wrote:
> Hi,
>
> On Tue, Jun 18, 2013 at 03:19:03PM +0530, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Tuesday 18 June 2013 03:10 PM, Felipe Balbi wrote:
>>> Hi,
>>>
>>> On Thu, Jun 13, 2013 at 02:13:52PM +0530, Kishon Vijay Abraham I wrote:
>>>> @@ -159,6 +191,12 @@ static int omap_usb2_probe(struct platform_device *pdev)
>>>>   	otg->start_srp		= omap_usb_start_srp;
>>>>   	otg->phy		= &phy->phy;
>>>>
>>>> +	pm_runtime_enable(phy->dev);
>>>
>>> enabling pm_runtime here has the potential to cause a real big problem.
>>> How have you tested this patch ?
>>
>> performed boot and enumeration testing. What issue do you expect here?
>
> hint: look at drvdata usage around the driver. Where is it initialized ?
> Where is it used ?

hmm.. since runtime_get calls weren't made very early, I think I dint 
see any issues. Thanks for pointing this.

Thanks
Kishon
