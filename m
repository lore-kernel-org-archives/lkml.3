Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab3FDJny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:43:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53611 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab3FDJnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:43:53 -0400
Message-ID: <51ADB6BF.6020205@ti.com>
Date: Tue, 4 Jun 2013 15:13:27 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "balbi@ti.com" <balbi@ti.com>
Subject: Re: [RFC PATCH] regulator: palmas: enable all modes for SMPS10
References: <1369911393-25747-1-git-send-email-kishon@ti.com> <20130530113247.GI5180@sirena.org.uk> <51A74D70.5060303@nvidia.com> <20130601184511.GC16790@sirena.org.uk> <51AA456E.3030307@nvidia.com> <20130601210511.GT16790@sirena.org.uk> <51ADAE78.4050900@ti.com> <20130604093816.GY31367@sirena.org.uk>
In-Reply-To: <20130604093816.GY31367@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 04 June 2013 03:08 PM, Mark Brown wrote:
> On Tue, Jun 04, 2013 at 02:38:08PM +0530, Kishon Vijay Abraham I wrote:
>> On Sunday 02 June 2013 02:35 AM, Mark Brown wrote:
>
>>> This is still not making any sense.  The quality of regulation and
>>> output voltage are essentially orthogonal, and obviously there's a
>>> specific API for bypass which is something different again to both
>>> mode and output voltage selection.
>
>> Do you recommend adding API's (similar to bypass) for BOOST and SWITCH?
>
> No.  A boost regulator is still a voltage regulator, it just happens to
> raise rather than lower the voltage but it's otherwise a normal
> regulator.  I'm not sure what you mean by "SWITCH" - from the name it'd
> just be a bypass?

Copy-pasting Laxman's explanation

<...>

Palma have SMPS10 regulator which can generate two voltage level 3.75 
and 5V.
This SMPS10 has the two outputs OUT1 and OUT2 and having one input IN1.

SMPS10-OUT2 is always connected to SMPS10-IN1 via following logic:
- Through parasitic diode (no sw control)
- In bypass mode (bit  configuration is there to enable/disable Bypass)
- In Boost mode (bit configuration is there to enable/disable Boost mode)

SMPS10-OUT1 is connected to the SMPS10-OUT2 pin through Switch (SW 
control for enabling/disabling this switch).

<...>

Thanks
Kishon
