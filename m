Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaFWLoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:44:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48218 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751310AbaFWLoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:44:23 -0400
Message-ID: <53A81314.6030902@free-electrons.com>
Date: Mon, 23 Jun 2014 13:44:20 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>, Rob Herring <robherring2@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: mvebu: Fix missing binding documentation for
 Armada 38x
References: <1403196043-6317-1-git-send-email-gregory.clement@free-electrons.com> <20140620185241.GC21711@titan.lakedaemon.net> <CAL_JsqKinUvcJ+OOoD70zD6CH393cgZWC+4gRO=8XORyE6fVKA@mail.gmail.com> <20140620235753.GS21711@titan.lakedaemon.net>
In-Reply-To: <20140620235753.GS21711@titan.lakedaemon.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/06/2014 01:57, Jason Cooper wrote:
> On Fri, Jun 20, 2014 at 05:33:06PM -0500, Rob Herring wrote:
>> On Fri, Jun 20, 2014 at 1:52 PM, Jason Cooper <jason@lakedaemon.net> wrote:
>>> On Thu, Jun 19, 2014 at 06:40:43PM +0200, Gregory CLEMENT wrote:
>>>> For the Armada 380 and Armada 385 SoCs, the common bindings for those
>>>> 2 SoCs, was forgotten. This patch add the documentation for the
>>>> marvell,aramda38x property.
>>>>
>>>> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>>>> --
>>>> Hi,
>>>>
>>>> This fix should be merged in 3.16. For 3.15 I am not sure as it is not
>>>> a regression.
>>>>
>>>> Changelog:
>>>> v1->v2
>>>>
>>>> - Reformulate to make clear that we will need marvell,armada38x _and_ a
>>>> SoC specific string. For consistency I duplicated what we have done in
>>>> armada-370-xp.txt
>>>>
>>>>
>>>> Thanks,
>>>> Gregory
>>>>
>>>>
>>>>  Documentation/devicetree/bindings/arm/armada-38x.txt | 17 +++++++++++++++--
>>>>  1 file changed, 15 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/arm/armada-38x.txt b/Documentation/devicetree/bindings/arm/armada-38x.txt
>>>> index 11f2330a6554..fa08760046df 100644
>>>> --- a/Documentation/devicetree/bindings/arm/armada-38x.txt
>>>> +++ b/Documentation/devicetree/bindings/arm/armada-38x.txt
>>>> @@ -6,5 +6,18 @@ following property:
>>>>
>>>>  Required root node property:
>>>>
>>>> - - compatible: must contain either "marvell,armada380" or
>>>> -   "marvell,armada385" depending on the variant of the SoC being used.
>>>> +compatible: must contain "marvell,armada38x"
>>>
>>> I agree with Sergei on this one.  We generally avoid wildcards in
>>> compatible strings.  Is there a use case where specifying one of the
>>> below wouldn't be sufficient?
>>
>> Isn't this a case of just documenting what is already in use?
> 
> Technically, yes.  However, there are no products shipping with this SoC
> yet.  So there aren't any _real_ users other than the developers
> bringing in mainline support.

Indeed there not yet user that we were aware of who use it. Moreover given the
state of the support for armada 380 and armada 385 in 3.15, I doubt that there
would be any product shipped using this dts.

About marvell,armada38x, we more or less mimic what we have done with armada-370-xp.
But armada385 really seemed to be a superset of armada380 (with more CPUs and more
PCIe slot). So a better approach could be to use "marvell,armada380" for Armada 380
and "marvell,armada385","marvell,armada380" for Armada 385.

Moreover it you have a look on "marvell,aramda-370-xp", it is only used in
arch/arm/mach-mvebu/board-v7.c with no real benfice against the use of "marvell,aramda370"
and "marvell,armadaxp" in the same way we already do for armada 38x family!!

Using "marvell,aramda-370-xp" was a mistake because the device tree was very new
for us. We made a link between the compatible string and the name of the file but
we didn't have to do this. It is too late to change "marvell,aramda-370-xp" but it
is still time to do it for "marvell,aramda-38x"

A new patch is coming.


Thanks,

Gregory


> 
>> I agree wildcards alone are not good, but along with a specific
>> compatible is okay. But also there should be some need to have the
>> common property.
> 
> I'm curious what you would consider to be a sufficient need?  This can
> be easily handled by a match table, but a match table could also be
> considered rather heavy for this task.
> 
> I think any implementation-based justification is prone to opening a can
> of worms.  And I'm struggling to see a DT-only justification...
> 
> thx,
> 
> Jason.
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
