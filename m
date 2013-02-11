Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab3BKRSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:18:30 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:53228 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757838Ab3BKRS2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:18:28 -0500
Subject: Re: [PATCH] platform: Fix platform device resource linking
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20130208220213.4525A3E2C27@localhost>
Date: Mon, 11 Feb 2013 19:18:23 +0200
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <286283B8-CC31-4DCD-8EA5-AD67D0CB483B@antoniou-consulting.com>
References: <1357252270-5955-1-git-send-email-panto@antoniou-consulting.com> <20130103224020.GB4571@kroah.com> <CD23CDD8-5740-4649-8876-ADDFCFF30C35@antoniou-consulting.com> <20130117163159.GD1396@kroah.com> <95056678-DF1A-4C49-BEAE-C5EBD7E56405@antoniou-consulting.com> <20130117170719.GB9163@kroah.com> <87DCB3B7-0A5A-42F0-BF9C-0E91B56960C6@antoniou-consulting.com> <20130118030017.GA11423@kroah.com> <82FE4A4D-DCA8-4C2C-97E7-6B73D424DCF5@antoniou-consulting.com> <20130208220213.4525A3E2C27@localhost>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Feb 9, 2013, at 12:02 AM, Grant Likely wrote:

> On Fri, 18 Jan 2013 11:05:14 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
>> Hi Greg,
>> 
>> On Jan 18, 2013, at 5:00 AM, Greg Kroah-Hartman wrote:
>> 
>>> On Thu, Jan 17, 2013 at 07:27:21PM +0200, Pantelis Antoniou wrote:
>>>>>> In a nutshell, we have to exercise the platform device subsystem, in ways
>>>>>> that never happened before, so all sorts of weird bugs that no-one has seen
>>>>>> before.
>>>>> 
>>>>> Why do you have to do this?  What are you doing that is so different
>>>>> from everyone else?  What drivers are you using that trigger this type
>>>>> of thing?
>>>>> 
>>>> 
>>>> This is all part of a larger patchset; I guess you weren't directly CCed.
>>>> The name of the patchset is 'Introducing Device Tree Overlays' and is a
>>>> method of changing the live device tree and have the changes reflected to
>>>> the kernel's state.
>>> 
>>> Ok, no wonder I was confused :)
>>> 
>>> How about cc:ing me on the next round of these patches, all of the,
>>> which will give me the proper background as to what is going on?
>>> 
>> 
>> Will do. I'm still waiting for some feedback from the DT maintainers, but
>> I will make sure that you will be CCed on the next revision.
>> 
>> You can of course take a look at it and comment on the current version too. 
>> 
>>>>>> In that case, the code path for creating platform devices from DT is
>>>>>> not the same as the one that is used when creating platform device from
>>>>>> a board file.
>>>>> 
>>>>> Why not?
>>>>> 
>>>> 
>>>> Because while DT creates platform devices, it doesn't use the platform device
>>>> methods to do so, rather than builds the platform device itself. This is 
>>>> something that was overlooked.
>>> 
>>> Can't this be fixed?  What does the platform device core need to do to
>>> resolve this?
>>> 
>> 
>> Hmm, due to historical reasons the two ways of creating platform devices
>> have diverged. The core of the issue is that while OF creates platform devices
>> it does so in it's own way.
> 
> It's actually the other way around. The DT code path used to be a
> completely separate of_platform_bus_type that didn't share any code with
> platform_bus_type. So in fact, the code patches have converged instead
> of diverged.
> 
> When I merged the paths there were some breakages that prevented me from
> using platform_device_add() directly. Most of those are now gone and
> 
> I've got a patch in my tree which makes the OF code use
> platform_device_add(). That makes this patch series unnecessary. The
> patch is currently in linux-next. Assuming I don't run into any major
> problems it will be merged in v3.9
> 

I'm fine with this, as long as nothing breaks. I'll wait until it lands in
mainline to test it.

>> The problem with doing anything like this would be that a whole bunch of
>> devices/arches depend on DT, and if anything breaks there will be a lot of
>> angry people with pitchforks after the culprit.
> 
> Pitchforks? pish. It's the torches that are dangerous.
> 

Fire bad. Got it.

> g.

What about the other (more substantial) patches that are in limbo? Any word
on them?

Regards

-- Pantelis

