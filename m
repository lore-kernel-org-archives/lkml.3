Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab3BAWiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 17:38:46 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:34792 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757779Ab3BAWio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 17:38:44 -0500
MIME-Version: 1.0
In-Reply-To: <20130128141153.GA3060@ennui.austin.ibm.com>
References: <20121121211529.GA27696@obsidianresearch.com>
	<CAM0nabE9qORsD1bMDm6EUZogPqb2m-X8rZ-xVqJecM7oJyaciw@mail.gmail.com>
	<20130125202538.GA16038@obsidianresearch.com>
	<20130128141153.GA3060@ennui.austin.ibm.com>
Date: Fri, 1 Feb 2013 16:38:42 -0600
Message-ID: <CAM0nabE887HW1rk2Gu1+5iHk0_MS1iX8HCmDQBXmDkVtVgBNRA@mail.gmail.com>
Subject: Re: [tpmdd-devel] [PATCH] TPM: Work around buggy TPMs that block
 during continue self test
From: Kent Yoder <shpedoikal@gmail.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>,
        Mathias Leblanc <mathias.leblanc@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 8:11 AM, Kent Yoder <key@linux.vnet.ibm.com> wrote:
> On Fri, Jan 25, 2013 at 01:25:38PM -0700, Jason Gunthorpe wrote:
>> On Tue, Jan 22, 2013 at 05:29:23PM -0600, Kent Yoder wrote:
>> > Hi Jason,
>> >
>> > On Wed, Nov 21, 2012 at 3:15 PM, Jason Gunthorpe
>> > <jgunthorpe@obsidianresearch.com> wrote:
>> > > We've been testing an alternative TPM for our embedded products and
>> > > found random kernel boot failures due to time outs after the continue
>> > > self test command.
>> > >
>> > > This was happening randomly, and has been *very* hard to track down, but it
>> > > looks like with this chip there is some kind of race with the tpm_tis_status()
>> > > check of TPM_STS_COMMAND_READY. If things get there 'too fast' then
>> > > it sees the chip is ready, or tpm_tis_ready() works. Otherwise it takes
>> > > somewhere over 400ms before the chip will return TPM_STS_COMMAND_READY.
>> > >
>> > > Adding some delay after tpm_continue_selftest() makes things reliably
>> > > hit the failure path, otherwise it is a crapshot.
>> >
>> >   I've staged this patch here, please test:
>> >
>> > https://github.com/shpedoikal/linux.git tpmdd-01-22-13
>>
>> Thanks Kent, I will try to test your branch next week, if I am able.
>>
>> Can you also grab
>>
>> https://github.com/jgunthorpe/linux/commit/98b2a198b43b41b0535200bf475160786398f114
>
>  Thanks, I missed this, I'll start testing it.

  Ok, after yet another round of fixes to the stm i2c driver, I have a
staging tree.  I'll submit this as-is next week unless something super
ground-breaking comes up.

https://github.com/shpedoikal/linux.git tpmdd-01-31-13

Thanks,
Kent

>> And did you have any comments on:
>>
>> https://github.com/jgunthorpe/linux/commit/9981e3e622bf702394982117134bed731ffd6f7e
>
>   This one is a bit out of date atm, for instance the __dev* stuff is
> going away.  The thing that most makes me hesitant though is the config
> if (X86 || OF).  A hardware platform or a firmware type..  What platform
> should this actually target?
>
> Kent
>
>> Both were posted to the list a bit ago.
>>
>> Regards,
>> --
>> Jason Gunthorpe <jgunthorpe@obsidianresearch.com>        (780)4406067x832
>> Chief Technology Officer, Obsidian Research Corp         Edmonton, Canada
>>
>> ------------------------------------------------------------------------------
>> Master Visual Studio, SharePoint, SQL, ASP.NET, C# 2012, HTML5, CSS,
>> MVC, Windows 8 Apps, JavaScript and much more. Keep your skills current
>> with LearnDevNow - 3,200 step-by-step video tutorials by Microsoft
>> MVPs and experts. ON SALE this month only -- learn more at:
>> http://p.sf.net/sfu/learnnow-d2d
>> _______________________________________________
>> tpmdd-devel mailing list
>> tpmdd-devel@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>>
