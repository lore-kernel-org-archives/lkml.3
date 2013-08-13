Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab3HMJTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:19:11 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:63980 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab3HMJTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:19:07 -0400
Message-ID: <5209FA05.6090702@gmail.com>
Date: Tue, 13 Aug 2013 11:19:01 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH 4/9] PCI: mvebu: add support for reset on GPIO
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376333215-12885-5-git-send-email-sebastian.hesselbarth@gmail.com> <BA285A30-3E38-4F7A-BD5E-3271AD1A46BE@codeaurora.org>
In-Reply-To: <BA285A30-3E38-4F7A-BD5E-3271AD1A46BE@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added DT maintainers directly for a question below]

On 08/13/13 02:56, Kumar Gala wrote:
> On Aug 12, 2013, at 1:46 PM, Sebastian Hesselbarth wrote:
>
>> This patch adds a check for DT passed reset-gpios property and deasserts/
>> asserts reset pin on probe/remove with configurable delay. Corresponding
>> binding documentation is also updated.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
[...]
>> diff --git a/Documentation/devicetree/bindings/pci/mvebu-pci.txt b/Documentation/devicetree/bindings/pci/mvebu-pci.txt
>> index 638673a..f2fa261 100644
>> --- a/Documentation/devicetree/bindings/pci/mvebu-pci.txt
>> +++ b/Documentation/devicetree/bindings/pci/mvebu-pci.txt
>> @@ -76,6 +76,8 @@ and the following optional properties:
>> - marvell,pcie-lane: the physical PCIe lane number, for ports having
>>    multiple lanes. If this property is not found, we assume that the
>>    value is 0.
>> +- reset-gpios: optional gpio to PERST#
>> +- reset-delay-ms: delay in ms to wait after reset de-assertion
>
> Both of these should probably be marvell,reset...

Kumar,

as Thomas already mentioned, non-prefixed "foo-gpios" are quite common.
As reset gpios are likely to be common among SoC pci controller setups,
I though I'd stick with the non-prefixed property. But I have no strong
opinion about it - but let's see how DT jurisdiction will vote :)

> Does reset-delay-ms vary per board? I can't remember where the
discussion got to about configuration info.

Hmm, for Dove SoC, I only have one board to test - but the driver
currently is for 4 different SoCs. I just did some quick evaluation
of the reset delay required to bring up the device on the D3Plug.
Using 10ms was too short, 20ms worked.

I guess there will be other SoC/boards requiring different delays
but I am fine with hardcoded 20ms and re-introduce reset-delay property
only if it is really required. The driver's default is 20ms anyway.

>>
>> Example:
>
> It's usually good to update example to show all optional properties.

Ok, will add the properties to one of the example ports.

Thanks,

Sebastian

