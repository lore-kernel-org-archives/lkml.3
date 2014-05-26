Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaEZPO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:14:26 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59351 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaEZPOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:14:24 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53835A40.8050902@roeck-us.net>
Date: Mon, 26 May 2014 08:14:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@ring0.de>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Subject: Re: [PATCH v4 2/8] OF: Introduce DT overlay support.
References: <E204285C-D6CD-4518-A94F-26BF0570C1B1@konsulko.com> <CAMuHMdUWfQ=2xPhNsS36mT6nv-CfR3_1exZ+5qYgdkjbBntrWg@mail.gmail.com> <20140516105814.3EA3FC403C2@trevor.secretlab.ca> <CAMuHMdWw39n8O0fFWECR6v6GaEJ3aB5S3ront4eDdXwxNO6Fgw@mail.gmail.com> <20140520055026.E3A98C412DA@trevor.secretlab.ca> <CAMuHMdXjWENrq0MW-DU2x7WnaCsWyipN4DO=y0ZTL+3G_fPYGg@mail.gmail.com> <20140526104824.63F13C42129@trevor.secretlab.ca> <CAMuHMdUGdjVKBR5rRzZ274rf7p8XfztNRWEojH1RrZV8c_V1uA@mail.gmail.com> <20140526112348.907B7C421A5@trevor.secretlab.ca> <A6195DFD-0447-4444-AC09-501C43F09924@konsulko.com> <20140526150942.GA26787@earth.universe>
In-Reply-To: <20140526150942.GA26787@earth.universe>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2014 08:09 AM, Sebastian Reichel wrote:
> Hi,
>
> On Mon, May 26, 2014 at 02:55:37PM +0300, Pantelis Antoniou wrote:
>> On May 26, 2014, at 2:23 PM, Grant Likely wrote:
>>> On Mon, 26 May 2014 12:57:32 +0200, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>> Heeheehee. We're back where we started. The original question is whether
>>> or not that is a valid approach. If the overlay represents something
>>> that can be hot plugged/unplugged, then passing it through to the second
>>> kernel would be the wrong thing to do. If it was a permenant addition,
>>> then it probably doesn't need to be removed.
>>>
>>> We do actually keep the overlay info in memory for the purpose of
>>> removal exactly so we can support hot unbinding of devices and drivers
>>> that make use of overlays.
>>
>> We can support either method. I am not feeling any wiser about which one should be
>> the default TBH, so what about exporting a property and let the platform
>> figure out which is more appropriate?
>
> What about supporting "negative" overlays (so an overlay, that
> removes DT entries)? That way one could reverse apply an overlay.
> All the dependency stuff would basically be the users problem.  The
> kernel only checks if it can apply an overlay (and return some error
> code if it can't). This this code is needed anyway to check the
> input from userspace.
>

Does that mean that I would need to describe such a negative overlay
for each overlay to be able to get it removed ?

This would introduce an endless source of problems with bad "reverse"
overlay descriptions. Sure, that would "be the users problem",
but I don't think that would make it better.

Guenter

