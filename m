Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaEZXsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 19:48:15 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57633 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaEZXsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 19:48:13 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5383D2AD.2050605@roeck-us.net>
Date: Mon, 26 May 2014 16:47:57 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
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
References: <1396615441-29630-1-git-send-email-pantelis.antoniou@konsulko.com>	<1396615441-29630-3-git-send-email-pantelis.antoniou@konsulko.com>	<20140514100856.5198DC4153D@trevor.secretlab.ca>	<E204285C-D6CD-4518-A94F-26BF0570C1B1@konsulko.com>	<CAMuHMdUWfQ=2xPhNsS36mT6nv-CfR3_1exZ+5qYgdkjbBntrWg@mail.gmail.com>	<20140516105814.3EA3FC403C2@trevor.secretlab.ca>	<CAMuHMdWw39n8O0fFWECR6v6GaEJ3aB5S3ront4eDdXwxNO6Fgw@mail.gmail.com>	<20140520055026.E3A98C412DA@trevor.secretlab.ca>	<CAMuHMdXjWENrq0MW-DU2x7WnaCsWyipN4DO=y0ZTL+3G_fPYGg@mail.gmail.com>	<20140526104824.63F13C42129@trevor.secretlab.ca>	<CAMuHMdUGdjVKBR5rRzZ274rf7p8XfztNRWEojH1RrZV8c_V1uA@mail.gmail.com>	<20140526112348.907B7C421A5@trevor.secretlab.ca>	<A6195DFD-0447-4444-AC09-501C43F09924@konsulko.com>	<20140526213303.C1C73C40E11@trevor.secretlab.ca> <CAMuHMdWoQd=EJ7ToWMrSq728HL7d7Ht1YmaNUO1EYZBU0eB1FQ@mail.gmail.com>
In-Reply-To: <CAMuHMdWoQd=EJ7ToWMrSq728HL7d7Ht1YmaNUO1EYZBU0eB1FQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2014 02:44 PM, Geert Uytterhoeven wrote:
> Hi Grant,
>
> On Mon, May 26, 2014 at 11:33 PM, Grant Likely
> <grant.likely@secretlab.ca> wrote:
>> After thinking about it more, I think it is very likely that removing
>> all the overlays is the correct thing to do in the kexec use-case. When
>> kexec-ing, it makes sense that we'd want the exact same behaviour from
>> the kexec'ed kernel. That means we want the device drivers to do the
>> same thing including loading whatever overlays they depend on.
>
> Are the device drivers loading the overlays?
> That sounds a bit backwards to me.
>

Depends on what you mean with 'device driver'. In our case we have a driver
dedicated to handle card status. Quite similar to what the connector subsystem
does but with significantly more functionality (including devicetree overlay
management).

Guenter

