Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaKZTOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 14:14:04 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:52381 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaKZTOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 14:14:00 -0500
Message-ID: <5476266E.9040901@mentor.com>
Date: Wed, 26 Nov 2014 21:13:50 +0200
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Question about fixed regulator DT properties
References: <546B5EF9.3080102@mentor.com> <546CAB49.8030103@mentor.com> <20141125121749.GV7712@sirena.org.uk> <54760D6A.9080306@mentor.com> <20141126175304.GM7712@sirena.org.uk>
In-Reply-To: <20141126175304.GM7712@sirena.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, MarkOn 26.11.2014 19:53, Mark Brown wrote:
> On Wed, Nov 26, 2014 at 07:27:06PM +0200, Vladimir Zapolskiy wrote:
>> On 25.11.2014 14:17, Mark Brown wrote:
> 
>> b) "regulator-boot-on" does not mean that the regulator is controlled by
>> bootloader or firmware exclusively.
> 
> That's correct...
> 
>>>>> Should documentation be updated to reflect "regulator-boot-on" role that
>>>>> a regulator is re-enabled by the kernel?
> 
>>> I'm confused about this.  That's the sole purpose of the flag and as far
>>> as I can tell it's what the documentation says.
> 
>> Documentation/devicetree/bindings/regulator/regulator.txt says:
> 
>>   - regulator-boot-on: bootloader/firmware enabled regulator
> 
>> I would suggest to add Linux kernel to that list of regulator
>> controllers, if it is the intention. In its current state the
>> documentation makes an impression that "regulator-boot-on" property
>> instructs the kernel to ignore regulator setup, since it is already
>> controlled by bootloader or firmware.
> 
> No, not at all.  It's referring to the state when Linux starts.
> 

thank you for clarification, to grasp the underlying policy let me ask
for some more information.

If I want to enable a fixed regulator (not controlled by
bootloader/firmware) by Linux on boot or when fixed.ko module is bound,
shall I specify the same "regulator-boot-on" property? At least this is
the practical way to enable a fixed and/or gpio regulator right now, but
is it correct?

Or should the regulator always be enabled externally (assuming
"regulator-always-on" is omitted) after registration independently on
"regulator-boot-on" property?

--
With best wishes,
Vladimir
