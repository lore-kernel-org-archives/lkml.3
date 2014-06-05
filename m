Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbaFEXA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 19:00:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60453 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaFEXAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 19:00:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAG-2HqWtbpKjkNTLAksGZSqskJRfjVOhGkJJFcJUNBFfajLhCg@mail.gmail.com>
References: <1401896895-14262-1-git-send-email-tiwai@suse.de>
	<CACVXFVPpmdXJV2CC-U=bsA820VD42i2-OqBfNfTPPaMergu8TQ@mail.gmail.com>
	<CAG-2HqU=LAXr0o2e9RRCmrX1eWouhepEZHaPfBjrs64xUeb=gw@mail.gmail.com>
	<CACVXFVP1uS7szLqvabtMbiaUgd13bWoYXv5q-Az7wBia=ogf7Q@mail.gmail.com>
	<s5hfvjj1n90.wl%tiwai@suse.de>
	<CACVXFVP5CSNoyThAcsmihYg_bkq2wn1JtiFJ_7ehpxwjBSaZxQ@mail.gmail.com>
	<s5hbnu71mf1.wl%tiwai@suse.de>
	<CACVXFVPWq93u5KmLhr+g23t4AiGAnLfd+hX3viajzR_KN+sMrw@mail.gmail.com>
	<CAG-2HqXiFgy5M=k55iOYAdXezxsN-ZanWRWDgH-6fuU-uLawOQ@mail.gmail.com>
	<CACVXFVNKGPyv6AVUctotD=Sc97VRRGCXVzJ50pprjCNB7jhUxg@mail.gmail.com>
	<CAG-2HqWtbpKjkNTLAksGZSqskJRfjVOhGkJJFcJUNBFfajLhCg@mail.gmail.com>
Date: Fri, 6 Jun 2014 07:00:22 +0800
Message-ID: <CACVXFVOgr1y5KQxGDzvyPfqKHo0e3CsN+3HWo-_dxo6bmufbLQ@mail.gmail.com>
Subject: Re: [PATCH v2] firmware loader: allow disabling of udev as firmware loader
From: Ming Lei <ming.lei@canonical.com>
To: Tom Gundersen <teg@jklm.no>
Cc: Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Stefan Roese <sr@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Abhay Salunke <Abhay_Salunke@dell.com>,
        Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 11:15 PM, Tom Gundersen <teg@jklm.no> wrote:
> On Thu, Jun 5, 2014 at 4:54 PM, Ming Lei <ming.lei@canonical.com> wrote:
>>> Ubuntu currently enables the firmware loader in both the kernel and in
>>> udev, so would not yet have a problem here at the moment. However, I
>>> spoke with Martin Pitt and he told me that both Debian and Ubuntu
>>> would like to switch this off in udev once it is possible (i.e., once
>>> this patch has been merged I guess). Fedora already did, and speaking
>>> for Arch we definitely would like to do the same. I did not check with
>>> other distros, but I'm pretty sure "everyone" will disable this in
>>> udev by the next cycle. At which point having it enabled in the kernel
>>> will cause real problems and bug reports.
>>
>> That won't cover the case of old distributions with new kernel,
>
> Again: disabling this option will not give problems (unless you have a
> custom setup), even on old userspace, only keeping it enabled on
> future userspace may.
>
>> do
>> you want to break/confuse these users?
>
> Not really, no :)
>
>>> For distro kernels that's not a problem, as they know what to do, but
>>> I guess for random kernel users we should give them the correct
>>> recommendation.
>>
>> Also I remember that android users put firmware under their
>> special path.
>
> That may be, but I don't think this text is primarily aimed at the
> people who put together Android systems... Surely their non-standard
> userspace means that a lot of the advice (and it is nothing else than
> advice!) in the help text does not necessarily apply?
>
>>>>>> It only falls back if the request fw is _not_ found from direct loading,
>>>>>> so it is reasonable to try to continue to look for it from user space.
>>>>
>>>>> Some drivers fall back to different firmware (e.g. different revision
>>>>> suffix) if the requested file isn't found.  So, this happens in
>>>>> reality.
>>>>
>>>> So do you think the fallback is better or worse? For CPU microcode
>>>> case, maybe it is fine, but for other devices, maybe it is better to
>>>> get a firmware for working at least.
>>>
>>> What usecase do you have in mind here? For people using stock udev,
>>> enabling the fallback will not give any benefit, but it will soon
>>
>> Again, we have old distributions, also it should make sense to fall back
>> to userspace for non-exist firmwares under default path.
>
> Even on old distributions, falling back to stock udev will not give
> any benefits. It will look in the same paths as the kernel and fail in
> the same way.
>
>>> start giving real problems...
>>
>> If there isn't firmwares at default path for devices, the device may
>> not work, and that is the real problem.
>
> These devices will never have worked with stock udev, as it looks in
> the same path as the kernel (the paths the kernel looks in was taken
> from udev to make sure they work the sam). So this must be a
> special/custom setup by someone who knows what they are doing, and
> hopefully knows how to answer the Kconfig.

I have to say all your statement about old distributions is just your
take for granted, and you can't verified on all old distributions at all.
That is said, disabling fallback may cause regression on these
distributions.

Given that the user helper(fallback) has been used for tens of
years on these distributions, I suggest you to change Kconfig
help message as something like below:

If your aren't sure, please check your udev/systemd version, if it
is below than XXX or no udev/systemd shipped in your system,
say Y here, otherwise say N.

Thanks,
--
Ming Lei
