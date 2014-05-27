Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbaE0MLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 08:11:48 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:58649 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaE0MLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 08:11:45 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v4 2/8] OF: Introduce DT overlay support.
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
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
In-Reply-To: <CAMuHMdWoQd=EJ7ToWMrSq728HL7d7Ht1YmaNUO1EYZBU0eB1FQ@mail.gmail.com>
References: <1396615441-29630-1-git-send-email-pantelis.antoniou@konsulko.com>
	<1396615441-29630-3-git-send-email-pantelis.antoniou@konsulko.com>
	<20140514100856.5198DC4153D@trevor.secretlab.ca>
	<E204285C-D6CD-4518-A94F-26BF0570C1B1@konsulko.com>
	<CAMuHMdUWfQ=2xPhNsS36mT6nv-CfR3_1exZ+5qYgdkjbBntrWg@mail.gmail.com>
	<20140516105814.3EA3FC403C2@trevor.secretlab.ca>
	<CAMuHMdWw39n8O0fFWECR6v6GaEJ3aB5S3ront4eDdXwxNO6Fgw@mail.gmail.com>
	<20140520055026.E3A98C412DA@trevor.secretlab.ca>
	<CAMuHMdXjWENrq0MW-DU2x7WnaCsWyipN4DO=y0ZTL+3G_fPYGg@mail.gmail.com>
	<20140526104824.63F13C42129@trevor.secretlab.ca>
	<CAMuHMdUGdjVKBR5rRzZ274rf7p8XfztNRWEojH1RrZV8c_V1uA@mail.gmail.com>
	<20140526112348.907B7C421A5@trevor.secretlab.ca>
	<A6195DFD-0447-4444-AC09-501C43F09924@konsulko.com>
	<20140526213303.C1C73C40E11@trevor.secretlab.ca>
	<CAMuHMdWoQd=EJ7ToWMrSq728HL7d7Ht1YmaNUO1EYZBU0eB1FQ@mail.gmail.com>
Date: Tue, 27 May 2014 13:11:40 +0100
Message-Id: <20140527121140.1BCE9C40A5A@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2014 23:44:41 +0200, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Hi Grant,
> 
> On Mon, May 26, 2014 at 11:33 PM, Grant Likely
> <grant.likely@secretlab.ca> wrote:
> > After thinking about it more, I think it is very likely that removing
> > all the overlays is the correct thing to do in the kexec use-case. When
> > kexec-ing, it makes sense that we'd want the exact same behaviour from
> > the kexec'ed kernel. That means we want the device drivers to do the
> > same thing including loading whatever overlays they depend on.
> 
> Are the device drivers loading the overlays?
> That sounds a bit backwards to me.

In a lot of cases, yes. For example, the beaglebone capebus driver would
be responsible for identifying and requesting or loading the correct
overlay to describe the hardware.

Having userspace provide an arbitrary overlay is only one of the use
cases.

g.

