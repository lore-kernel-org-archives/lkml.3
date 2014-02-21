Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689AbaBUQBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:01:52 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49640 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639AbaBUQBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:01:50 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA5W=t9+OmZXZuJT-1EsZXmTUBrX4eHjJcmQg676SOjSng@mail.gmail.com>
References: <20140220235118.191692546@linuxfoundation.org> <20140220235119.236520201@linuxfoundation.org>
 <CA+5PVA55O2GwUE8oMHShgKgQPA89z5RTbn6yCvOPBMGsf70kBw@mail.gmail.com>
 <5307683C.50209@suse.de> <CA+5PVA5W=t9+OmZXZuJT-1EsZXmTUBrX4eHjJcmQg676SOjSng@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 21 Feb 2014 17:01:28 +0100
Message-ID: <CAPXgP12Vs3LtVPOxF-Tnn4H7NjD6unXtPEOjFzRRhJhf0xndRQ@mail.gmail.com>
Subject: Re: [PATCH 3.13 35/99] tty: Set correct tty name in active sysfs attribute
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Hannes Reinecke <hare@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>,
        Jiri Slaby <jslaby@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        Werner Fink <werner@suse.de>, Ray Strode <halfline@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 3:56 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> On Fri, Feb 21, 2014 at 9:52 AM, Hannes Reinecke <hare@suse.de> wrote:
>> On 02/21/2014 03:48 PM, Josh Boyer wrote:
>>> On Thu, Feb 20, 2014 at 6:52 PM, Greg Kroah-Hartman
>>> <gregkh@linuxfoundation.org> wrote:
>>>> 3.13-stable review patch.  If anyone has any objections, please let me know.
>>>>
>>>> ------------------
>>>>
>>>> From: Hannes Reinecke <hare@suse.de>
>>>>
>>>> commit d8a5dc3033af2fd6d16030d2ee4fbd073460fe54 upstream.
>>>>
>>>> The 'active' sysfs attribute should refer to the currently active tty
>>>> devices the console is running on, not the currently active console.
>>>>
>>>> The console structure doesn't refer to any device in sysfs, only the tty
>>>> the console is running on has.  So we need to print out the tty names in
>>>> 'active', not the console names.
>>>>
>>>> This resolves an issue on s390 platforms in determining the correct
>>>> console device to use.
>>>
>>> Just to be double sure this is seen, Ray points out that it breaks
>>> current plymouth because the heuristic changed.  Hold off on this one?
>>>
>> Without this patch systemd won't present a login console for s390.
>> I'd prefer fixing plymouth.
>
> Sure.  Except fixing plymouth is easy to do, but not easy to actually
> get deployed on all of the old userspace.  So if someone runs a 3.14
> kernel on any distro that doesn't have a fixed plymouth, it's broken.
> By including this patch, you're basically trading one broken userspace
> component for another.
>
> Is there some other way this could be fixed in-kernel that would allow
> both to work?

Why did the tty0 change to tty1 now? That doesn't look like a "driver
name" vs. "device name" issue?

Kay
