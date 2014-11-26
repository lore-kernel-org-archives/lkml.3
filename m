Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbaKZR1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:27:13 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:40085 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaKZR1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:27:11 -0500
Message-ID: <54760D6A.9080306@mentor.com>
Date: Wed, 26 Nov 2014 19:27:06 +0200
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Question about fixed regulator DT properties
References: <546B5EF9.3080102@mentor.com> <546CAB49.8030103@mentor.com> <20141125121749.GV7712@sirena.org.uk>
In-Reply-To: <20141125121749.GV7712@sirena.org.uk>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 25.11.2014 14:17, Mark Brown wrote:
> On Wed, Nov 19, 2014 at 04:38:01PM +0200, Vladimir Zapolskiy wrote:
>> Hello Mark,
>>
>> On 18.11.2014 17:00, Vladimir Zapolskiy wrote:
> 
> Your mail is really quite long and all in quotes which makes it hard to
> follow, brevity is really helpful to readers.

my sole purpose was to describe the problems I encounter in details,
sorry for excessive verbosity.

Just to summarize my findings:
a) "enable-active-high" property has no effect on GPIO output,
b) "regulator-boot-on" does not mean that the regulator is controlled by
bootloader or firmware exclusively.

>>> | regulator-boot-on | enable-active-high | GPIO polarity | GPIO output |
>>> +-------------------+--------------------+---------------+-------------+
>>> |        no         |         yes        |  active high  |    low      |
>>> |        no         |          no        |  active low   |   high      |
> 
>>> I'd rather think that both resulting GPIO outputs are incorrect or
>>> better to say do not correspond to my perception of "regulator-boot-on"
>>> and "enable-active-high" DTS properties described in the documentation,
>>> however above "enable-active-high" and actual GPIO polarity are the same
>>> (when they are not, it is another open topic for discussion).
> 
> What you're saying seems sensible.

Good, I read it as a confirmation that the problem exists.

>>> Should documentation be updated to reflect "regulator-boot-on" role that
>>> a regulator is re-enabled by the kernel?
> 
> I'm confused about this.  That's the sole purpose of the flag and as far
> as I can tell it's what the documentation says.

Documentation/devicetree/bindings/regulator/regulator.txt says:

  - regulator-boot-on: bootloader/firmware enabled regulator

I would suggest to add Linux kernel to that list of regulator
controllers, if it is the intention. In its current state the
documentation makes an impression that "regulator-boot-on" property
instructs the kernel to ignore regulator setup, since it is already
controlled by bootloader or firmware.

>>> Should "enable-active-high" be replaced by getting GPIO flags directly?
> 
> Probably makes sense, it predates those flags by quite some time.
> 

If you have no objection I'll take a look how to fix it by removing
"enable-active-high" flag completely from the driver's logic,
fortunately the flag has no tangible effect at the moment as it is shown
by my analysis.

--
With best wishes,
Vladimir
