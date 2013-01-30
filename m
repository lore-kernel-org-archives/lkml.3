Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab3A3N2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:28:03 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:37603 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab3A3N2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:28:01 -0500
MIME-Version: 1.0
In-Reply-To: <20130129233842.GA8024@kahuna>
References: <1359474865-15408-1-git-send-email-ruslan.bilovol@ti.com>
	<20130129160243.GA3389@kahuna>
	<CAB=otbSV6CH4WOrr577bHXFcjEVRGjZxatgy4CJ3cr0M0h4vfw@mail.gmail.com>
	<20130129233842.GA8024@kahuna>
Date: Wed, 30 Jan 2013 15:20:31 +0200
Message-ID: <CAB=otbQLxb26srPckpts6om7Y34oDecogfM_V2+8Bcgixg=LEQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] ARM: update cpuinfo to print CPU model name
From: Ruslan Bilovol <ruslan.bilovol@gmail.com>
To: Nishanth Menon <nm@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        eduardo.valentin@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 1:38 AM, Nishanth Menon <nm@ti.com> wrote:
> On 01:08-20130130, Ruslan Bilovol wrote:
>> Hi,
>>
>> On Tue, Jan 29, 2013 at 6:02 PM, Nishanth Menon <nm@ti.com> wrote:
>> >
>> > On 17:54-20130129, Ruslan Bilovol wrote:
>> > > Hi,
>> > >
>> > > The following patches update cpuinfo to print CPU
>> > > model name for ARM. First patch exactly makes needed
>> > > changes for ARM architecture.
>> > > Second patch adds this ability to OMAP4 SoCs.
>> > >
>> > > This adds a common approach to show SoC name.
>> > >
>> > > Looks like there were few attempts to do similar
>> > > changes to cpuinfo without any luck.
>> > >
>> > > So - comments are welcome
>> > >
>> > > Ruslan Bilovol (2):
>> > >   ARM: kernel: update cpuinfo to print CPU model name
>> > >   ARM: OMAP4: setup CPU model name during ID initialisation
>> >
>> > We had an discussion on similar lines but a generic suggestion:
>> > https://patchwork.kernel.org/patch/98720/
>> > SoCinfo framework which was supposed to introduce this
>> >
>> > Would'nt that be a better approach to take than an OMAP only solution?
>>
>> My goal is only to say what is the SoC model name in the /proc/cpuinfo
>> (And it is not an OMAP-only solution - it is common. Support for OMAP
>> is added in second patch)
>> This is the only type of information that we can apply for any SoC.
>> My point is - any SoC-specific information should go through some other
>> way - like SoCinfo framework mentioned by you.
>> And additional point - in cpuinfo we already have CPU name and Machine name.
>> The SoC name (that is something between these two things) looks also relevant
> Looking at the sample output in patch #1/2
> OMAP4470 ES1.0 HS
>
> OMAP4470 is SoC name
> ES1.0 is SoC revision
> HS is SoC type

Will fix it in next patchseries. Let's leave only only SoC name

>
> We even have SoC features (e.g. at boot NEON etc..)
>
> Is the intent to put all this inside /proc/cpuinfo?? I bet every SoC has
> it's own interesting data it'd like to have (like some of the info
> populated by DT even). I am hardpressed to think this fits inside
> /proc/cpuinfo. I might even suspect that the list of interesting
> information might even vary per SoC.

No, I don't think we need all these information in cpuinfo - just because
it will be different for different SoC - so the file structure will be
very different..
Let's have only SoC name in cpuinfo.

>
> having machine name is something ARM specific? dumping it on my linux
> machines (x86[1] and sparc[2]) dont seem to show that.

Yes - it's ARM specific.

>
> but in the interest of not breaking existing interfaces, new interfaces
> should potentially belong elsewhere.. my 2 cents.
>
> [1] http://pastebin.com/CF8HPDAC (Xubuntu 12.04 3.2.0-36)
> [2] http://pastebin.com/qNwWHwiu (Debian 3.2.35-2)

Just look at changes in cpuinfo for ARM between kernels:
3.4 kernel: http://pastebin.com/TfmE7b2b
3.8-rc3: http://pastebin.com/zvvTGeNt

The file structure has huge changes

> --
> Regards,
> Nishanth Menon
