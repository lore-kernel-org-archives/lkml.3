Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab3G2Qpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:45:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51271 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab3G2Qph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:45:37 -0400
Message-ID: <51F69C2B.6020208@wwwdotorg.org>
Date: Mon, 29 Jul 2013 10:45:31 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "kishon@ti.com" <kishon@ti.com>, Stephen Warren <swarren@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH 2/2] pinctrl: palmas: add pincontrol driver
References: <1374833754-19659-1-git-send-email-ldewangan@nvidia.com> <1374833754-19659-3-git-send-email-ldewangan@nvidia.com> <51F2C970.7000200@wwwdotorg.org> <51F3B8F7.4000809@nvidia.com>
In-Reply-To: <51F3B8F7.4000809@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2013 06:11 AM, Laxman Dewangan wrote:
> Hi Stephen,
> Thanks for detail review.
> Agree on most of review. Some info/answer on some of query.
> 
> On Saturday 27 July 2013 12:39 AM, Stephen Warren wrote:
>> (Also CC'ing in the DT bindings maintainers, hence quoting all of the
>> binding.)
>>
>> On 07/26/2013 04:15 AM, Laxman Dewangan wrote:

>>> +     for (i = 0; i < ARRAY_SIZE(g->opt); i++) {
>>> +             if (g->opt[i]->mux_opt == function)
>>> +                     break;
>>> +     }
>>
>> So, when I create the Tegra bindings, I created the list of mux
>> functions by looking at the logical meaning of each register value
>> (0..3) for each pin, and then made the list of functions have a value
>> for each logical meaning. This requires a mapping table between the
>> pinctrl subsystem's mux function values and the HW mux function values,
>> which is what the loop above implements. Instead, if might be simpler to
>> just have functions named "0", "1", "2", ... and have all pins support
>> those functions. This simplifies the driver, and the DT bindings.
>> Whether doing so would make the DT bindings better probably depends on
>> exactly how the HW's documentation is written...
> 
> I am not sure I got it completely or not. Let me try out this and get
> reviewed by you.

Just to provide some more details, let's say we have two pins A/B/C/D,
each with mux options 0, 1, 2, 3, with the following meaning:

A 0=GPIO 1=SPI1 2=I2C1 3=xxx
B 0=GPIO 1=SPI1 2=I2C1 3=yyy
C 0=GPIO 1=SPI2 2=I2C2 3=yyy
D 0=GPIO 1=SPI2 2=I2C2 3=zzz

The four physical mux options are 0, 1, 2, 3. They will apply to any and
all pins, irrespective of the meaning of those options. It may be
reasonable to use 0/1/2/3 directly in the DT bindings as the mux
options, since their meaning can be looked up in the SoC's data sheet.

The logical mux options are: GPIO, SPI1, SPI2, I2C1, I2C2, xxx, yyy,
zzz. Those indicate which HW blocks are connected to the pins, i.e. the
pins' logical use-cases. It may also be reaonsable to use those logical
options in the DT rather than the physical options since it's more
descriptive. However, the driver would need a table to map from the
logical options to the physical options so that the register could be
programmed. Equally, these logical options are slightly less a direct
representation of HW.

Different people may prefer a different answer to the question of which
of those two options to use. The structure of the SoC documentation may
provide a hint; it would probably be best to use whichever option makes
matching the DT to the documentation easiest.
