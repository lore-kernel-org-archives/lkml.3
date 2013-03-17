Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab3CQOoI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 10:44:08 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:46518 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab3CQOoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 10:44:04 -0400
MIME-Version: 1.0
In-Reply-To: <1363531017.2423.50.camel@zim.stowe>
References: <20130316213512.2974.17303.stgit@amt.stowe> <20130316213519.2974.38954.stgit@amt.stowe>
 <20130316221159.GA3702@kroah.com> <1363477853.2423.25.camel@zim.stowe>
 <20130317010317.GB9641@kroah.com> <1363493482.16793.69.camel@ul30vt.home>
 <20130317053611.GC948@kroah.com> <1363527503.16793.75.camel@ul30vt.home>
 <CAPXgP12vmx9j_jJW3HXb2deRapFKAofTVzEbdyS=Z1VUBswE_Q@mail.gmail.com>
 <1363530028.2423.43.camel@zim.stowe> <CAPXgP13+BACQEid=xcFLDv+Tm3A1pCqDDfP4K+ZZrwGZBQ9A8g@mail.gmail.com>
 <1363531017.2423.50.camel@zim.stowe>
From: Kay Sievers <kay@vrfy.org>
Date: Sun, 17 Mar 2013 15:43:42 +0100
Message-ID: <CAPXgP13KkDfFb6tFKeetdDe+dnzr_m462Zd7HoR9kyHY=GgcpA@mail.gmail.com>
Subject: Re: [PATCH] udevadm-info: Don't access sysfs 'resource<N>' files
To: Myron Stowe <mstowe@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Myron Stowe <myron.stowe@redhat.com>, linux-hotplug@vger.kernel.org,
        linux-pci@vger.kernel.org, yuxiangl@marvell.com, yxlraid@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 3:36 PM, Myron Stowe <mstowe@redhat.com> wrote:
> On Sun, 2013-03-17 at 15:29 +0100, Kay Sievers wrote:
>> On Sun, Mar 17, 2013 at 3:20 PM, Myron Stowe <mstowe@redhat.com> wrote:
>> > On Sun, 2013-03-17 at 15:00 +0100, Kay Sievers wrote:
>> >> On Sun, Mar 17, 2013 at 2:38 PM, Alex Williamson
>> >> <alex.williamson@redhat.com> wrote:
>> >> > I'm assuming that the device only breaks because udevadm is dumping the
>> >> > full I/O port register space of the device and that if an actual driver
>> >> > was interacting with it through this interface that it would work.  Who
>> >> > knows how many devices will have read side-effects by udevadm blindly
>> >> > dumping these files.  Thanks,
>> >>
>> >> Sysfs is a too public interface to export things there which make
>> >> devices/driver choke on a simple read() of an attribute.
>> >>
>> >> This is nothing specific to udevadm, any tool can do that. Udevadm
>> >> will never read any of the files during normal operation. The admin
>> >> explicitly asked udevadm with a specific command to dump all the stuff
>> >> the device offers.
>> >>
>> >> The kernel driver needs to be fixed to allow that, in the worst case,
>> >> the attributes not exported at all. People should take more care what
>> >> they export in /sys, it's not a hidden and private ioctl what's
>> >> exported there, stuff is very visible and will be looked at.
>> >>
>> >> Telling userspace not to use specific stuff in /sys I would not expect
>> >> to work as a strategy; there is too much weird stuff out there that
>> >> will always try to do that ...
>> >
>> > Kay - could you comment on Foot Note 3 in
>> > https://lkml.org/lkml/2013/3/16/168
>> >
>> > With respect to 'udev', you are working on the assumption that all files
>> > in sysfs must be readable with no consequences which may be implied by
>> > the Documentation's sysfs.txt file's mentioning ASCII.  If we are to
>> > interpret that as strictly as you seem to want to then why is there
>> > sysfs support for creating binary files?
>>
>> They cannot be distinguished from outside, so there is nothing I know
>> that could make a difference to userspace tools.
>
> Agreed
>>
>> Tools -- no matter how useful they are not not, it's that they do that
>> for many years already -- need to be able to read() the stuff in
>> there, without causing any damage to the system.
>
> So then, why are certain sysfs files skipped in udevadm-info's parsing
> (./src/udevadm-info.c::skip_attribute())?

Because they are not useful to use in udev rules, or are just not
recommended to use in rules because they break other assumptions and
would encode specific settings, which can rightfully change at
runtime, into rules.

The list is in no way a list to ensure a system/driver/device is not
choking on read().

Kay
