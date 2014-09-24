Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaIXJod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:44:33 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37062 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaIXJoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:44:30 -0400
Message-ID: <54229276.5050000@ti.com>
Date: Wed, 24 Sep 2014 15:14:22 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 2/6] phy: improved lookup method
References: <1408620803-10464-1-git-send-email-heikki.krogerus@linux.intel.com> <1408620803-10464-3-git-send-email-heikki.krogerus@linux.intel.com> <5411C0B2.3060505@ti.com> <20140912140720.GC30816@xps8300> <54130729.5010206@ti.com> <20140915123508.GA16653@xps8300> <20140918102505.GB8567@xps8300> <54200A13.6050201@ti.com> <20140923105311.GB18814@xps8300> <5421536D.4050601@ti.com> <20140923114353.GC18814@xps8300>
In-Reply-To: <20140923114353.GC18814@xps8300>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 23 September 2014 05:13 PM, Heikki Krogerus wrote:
> On Tue, Sep 23, 2014 at 04:33:09PM +0530, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Tuesday 23 September 2014 04:23 PM, Heikki Krogerus wrote:
>>> On Mon, Sep 22, 2014 at 05:07:55PM +0530, Kishon Vijay Abraham I wrote:
>>>> On Thursday 18 September 2014 03:55 PM, Heikki Krogerus wrote:
>>>>> On Mon, Sep 15, 2014 at 03:35:08PM +0300, Heikki Krogerus wrote:
>>>>>> On Fri, Sep 12, 2014 at 08:16:01PM +0530, Kishon Vijay Abraham I wrote:
>>>>>>> Assume you have 2 phys in your system..
>>>>>>> static struct phy_lookup usb_lookup = {
>>>>>>> 	.phy_name	= "phy-usb.0",
>>>>>>> 	.dev_id		= "usb.0",
>>>>>>> 	.con_id		= "usb",
>>>>>>> };
>>>>>>>
>>>>>>> static struct phy_lookup sata_lookup = {
>>>>>>> 	.phy_name	= "sata-usb.1",
>>>>>>> 	.dev_id		= "sata.0",
>>>>>>> 	.con_id		= "sata",
>>>>>>> };
>>>>>>>
>>>>>>> First you do modprobe phy-usb, the probe of USB PHY driver gets invoked and it
>>>>>>> creates the PHY. The phy-core will find a free id (now it will be 0) and then
>>>>>>> name the phy as phy-usb.0.
>>>>>>> Then with modprobe phy-sata, the phy-core will create phy-sata.1.
>>>>>>>
>>>>>>> This is an ideal case where the .phy_name in phy_lookup matches.
>>>>>>>
>>>>>>> Consider if the order is flipped and the user does modprobe phy-sata first. The
>>>>>>> phy_names won't match anymore (the sata phy device name would be "sata-usb.0").
>>>>>
>>>>> Actually, I don't think there would be this problem if we used the
>>>>> name of the actual device which is the parent of phy devices, right?
>>>>
>>>> hmm.. but if the parent is a multi-phy phy provider (like pipe3 PHY driver), we
>>>> might end up with the same problem.
>>>
>>> I'm not completely sure what you mean? If you are talking about
>>> platforms with multiple instances of a single phy, I don't see how
>>> there could ever be a scenario where we did not know the order in
>>> which they were enumerated. Can you give an example again?
>>
>> If a single IP implements multiple PHYs (phy-miphy365x.c in linux-phy next),
>> the parent for all the phy devices would be the same.
> 
> OK, got it. So I guess we need to match to the phy dev and to the phy
> name. First to the dev and then in case the phy name is defined in the
> lookup, to that as well. That should cover both cases.

So what would be the phy name? I mean it's completely user-defined or it's
derived from device name?

Isn't making the PHY to be aware of it's user much simpler?

Thanks
Kishon
