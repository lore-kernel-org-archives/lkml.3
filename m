Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab3KOIej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 03:34:39 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:36840 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754944Ab3KOIec convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 03:34:32 -0500
Subject: Re: [PATCH v3 2/3] OF: Introduce DT overlay support.
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20131114212206.EAD1BC402B4@trevor.secretlab.ca>
Date: Fri, 15 Nov 2013 09:34:21 +0100
Cc: Rob Herring <robherring2@gmail.com>,
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
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D048F1EA-B78C-4B10-9A6D-726A17036B42@antoniou-consulting.com>
References: <1383923170-24914-1-git-send-email-panto@antoniou-consulting.com > <1383923170-24914-3-git-send-email-panto@antoniou-consulting.com> < 20131111184245.D569DC4234A@trevor.secretlab.ca> < ED51965C-6EC8-48AE-A59C-CD09FFD57731@antoniou-consulting.com> < 20131114013124.7DD0AC404DF@trevor.secretlab.ca> < E4922A5F-11B3-4167-91EF-C0D5F3F77D40@antoniou-consulting.com> <20131114212206.EAD1BC402B4@trevor.secretlab.ca>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Nov 14, 2013, at 10:22 PM, Grant Likely wrote:

> On Thu, 14 Nov 2013 11:01:35 +0100, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
>> On Nov 14, 2013, at 2:31 AM, Grant Likely wrote:
>>> On Tue, 12 Nov 2013 10:30:37 +0100, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
>>>> On Nov 11, 2013, at 7:42 PM, Grant Likely wrote:
>>>>> On Fri,  8 Nov 2013 17:06:09 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
>>>> I'm of the opinion that 'platform_device' shouldn't exist at all btw :)
>>>> Most of it's functionality can pretty easily be subsumed by device proper
>>>> and the world would be a better place :)
>>> 
>>> I'm fine for merging some/all of the platform_device fields into struct
>>> device. There are a few things, like resources, which would probably be
>>> useful to have common on all struct device variants. However,
>>> platform_device is far more about matching drivers to devices. Even if
>>> all of platform_device went into struct device, there would still need
>>> to be the platform_bus_type as the collection point for the device
>>> drivers.
>>> 
>> 
>> We don't really need the resources structures on OF. That information is
>> present in OF format, which we can use to generate transient resources for
>> usage with the standard kernel interfaces.
>> 
>> BTW, last time I checked resource handling was broken on release.
>> There are a few patches I sent out fixing it but they were probably ignored.
> 
> Please send them again. They probably got lost.
> 
>>>>> Can overlays interact in bad ways? If overlay 1 is installed before
>>>>> overlay 2, what happens if overlay 1 is removed?
>>>>> 
>>>> 
>>>> Yes, they can. It is not something easily fixed; the proper way would
>>>> be to calculate overlay intersection points and refuse to unload.
>>> 
>>> I think this is important. If it cannot be solved immediately, then the
>>> kernel should enforce overlays always get removed in the reverse order
>>> that they were added. There may be use-cases that don't like it, but it
>>> is safe.
>> 
>> OK, that makes sense.
>> 
>> We are not talking about a global overlay stack though, we're talking about
>> an overlay stack for overlays that overlap.
> 
> I'm actually talking about a global overlay stack. Otherwise you've
> still got the ever-increasing-phandles problem again.
> 

A global overlay stack is easiest. Let's do that first.

There are use cases for multiple overlay stacks though. Take for instance the
case where you have multiple plugin connectors.

Each one can lead to creating a new platform device under ocp, but there is
no overlap.

Of course stackable expansion boards work just fine with a global overlay stack :)

> Cheers,
> g.

Regards

-- Pantelis

