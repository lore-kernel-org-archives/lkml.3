Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaKZINZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 03:13:25 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbaKZINX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 03:13:23 -0500
Message-ID: <54758B9C.3050107@nod.at>
Date: Wed, 26 Nov 2014 09:13:16 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rafael.j.wysocki@intel.com, pebolle@tiscali.nl,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: defconfig: Enable CONFIG_FHANDLE
References: <1416958612-7448-1-git-send-email-richard@nod.at> <20141125235108.GB3138@kroah.com> <54751A95.60805@nod.at> <20141126005542.GA14758@kroah.com>
In-Reply-To: <20141126005542.GA14758@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.11.2014 um 01:55 schrieb Greg KH:
> On Wed, Nov 26, 2014 at 01:11:01AM +0100, Richard Weinberger wrote:
>> Am 26.11.2014 um 00:51 schrieb Greg KH:
>>> On Wed, Nov 26, 2014 at 12:36:52AM +0100, Richard Weinberger wrote:
>>>> systemd has a hard dependency on CONFIG_FHANDLE.
>>>
>>> It's been this way for a very long time, why is this suddenly an issue?
>>
>> Because nobody cared to create patch and just called systemd names? ;-)
> 
> systemd documents what is needed in order for it to boot properly quite
> well, I don't see why this needs to be here.

Because not every kernel developer knows the contents of the damn systemd readme file.
Face it, systemd is common userspace and if a defconfig is unable to boot common userspace
we have a problem.

Yesterday I was hunting down a regression in libvirt on the shiny new openSUSE 13.2,
I had to build an older kernel.
So I did a defconfig because I know that config has all drivers for my KVM setup.
(No, I my laptop don't has to power to build the bloated .config from suse)
But systemd went nuts (in terms of doing completely crap things beside of not spawning
a getty).
After one hour of painful systemd debugging I found out that I was missing
CONFIG_FHANDLE.

I really don't understand why you are so opposed to that change.
Let's make thing easier for us.

>>> Do these files even make any sense anymore?  Who uses them?  The distros
>>> sure do not...
>>
>> Maybe I'm oldschool but I expect a defconfig kernel to be able to boot a
>> recent distro.
> 
> You are :)
> How does the defconfig know your hardware in order to be able to find
> the root disk properly?  Video device?  USB keyboard?  and so on...
> 
> I thought we were getting rid of the defconfig files entirely one of
> these days, didn't some arches already do this?

Please don't.

Thanks,
//richard
