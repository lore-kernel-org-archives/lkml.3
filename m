Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaEZPPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:15:05 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:40701 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbaEZPPC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:15:02 -0400
Subject: Re: [PATCH v4 2/8] OF: Introduce DT overlay support.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <20140526150942.GA26787@earth.universe>
Date: Mon, 26 May 2014 18:14:52 +0300
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
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
Content-Transfer-Encoding: 8BIT
Message-Id: <D9B0A90F-F089-48B1-926C-87689889AF42@konsulko.com>
References: <E204285C-D6CD-4518-A94F-26BF0570C1B1@konsulko.com> <CAMuHMdUWfQ=2xPhNsS36mT6nv-CfR3_1exZ+5qYgdkjbBntrWg@mail.gmail.com> <20140516105814.3EA3FC403C2@trevor.secretlab.ca> <CAMuHMdWw39n8O0fFWECR6v6GaEJ3aB5S3ront4eDdXwxNO6Fgw@mail.gmail.com> <20140520055026.E3A98C412DA@trevor.secretlab.ca> <CAMuHMdXjWENrq0MW-DU2x7WnaCsWyipN4DO=y0ZTL+3G_fPYGg@mail.gmail.com> <20140526104824.63F13C42129@trevor.secretlab.ca> <CAMuHMdUGdjVKBR5rRzZ274rf7p8XfztNRWEojH1RrZV8c_V1uA@mail.gmail.com> <20140526112348.907B7C421A5@trevor.secretlab.ca> <A6195DFD-0447-4444-AC09-501C43F09924@konsulko.com> <20140526150942.GA26787@earth.universe>
To: Sebastian Reichel <sre@ring0.de>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On May 26, 2014, at 6:09 PM, Sebastian Reichel wrote:

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
> As a result the overlay handling would basically have the same
> behaviour as diff and patch :)
> 

This is already supported; nodes and properties can be prefixed with a minus
sign '-' and operate as expected :)

i.e. "-property;" removes a property and "-node { };" removes a node. 

> P.S.: Sorry if this has already been suggested. I have only read
> mails from PATCHv4.
> 
> -- Sebastian

Regards

-- Pantelis

