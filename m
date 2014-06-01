Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaFAUqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 16:46:16 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:36696 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbaFAUqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 16:46:15 -0400
MIME-Version: 1.0
In-Reply-To: <1401638869.7663.21.camel@x230>
References: <1401546480-2071-1-git-send-email-andreas.noever@gmail.com>
 <1401580281.7663.14.camel@x230> <CAMxnaaURVhZ_SiJW7Qy1bsye1bcPE=J=vjL5MgTN5znP15WnXw@mail.gmail.com>
 <1401638869.7663.21.camel@x230>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Sun, 1 Jun 2014 22:45:53 +0200
Message-ID: <CAMxnaaUJKmRrP6f2U+0-BVY_Pgz+qOn1BekGUyOqUPvp33so0w@mail.gmail.com>
Subject: Re: [PATCH v4 00/15] Thunderbolt driver for Apple MacBooks
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "greg@kroah.com" <greg@kroah.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 1, 2014 at 6:07 PM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> On Sun, 2014-06-01 at 12:11 +0200, Andreas Noever wrote:
>> On Sun, Jun 1, 2014 at 1:51 AM, Matthew Garrett
>> <matthew.garrett@nebula.com> wrote:
>> > This seems to be working well on my MBP. It appears to broadly work on
>> > my Mac Pro, which has Thunderbolt 2 hardware - I added the PCI ID, and
>> > loading the thunderbolt driver after the device is plugged in works, but
>> > it won't recognise hotplug events. I don't appear to get any interrupts
>> > from the Thunderbolt controller. Any idea what might be happening there?
>> So the communication with the controller works (dmesg dumps a list of
>> ports etc.)? Do you get plug events ("resetting error on port ...")?
>> You could try to play around with tb_plug_events_active, if you want
>> to experiment. I can also take another look at what OS X does once I
>> get back to my workstation (when I worked on this part falcon ridge
>> was not jet released, so maybe they do things differently now).
>
> Yeah, that was it. I'll mail the patch separately.
Great
>
>> > As far as the quirks go - perhaps something like this would be
>> > reasonable, rather than maintaining a list of machines?
>> I have obtained ACPI dumps from a late 2013 MBP and from a MacPro
>> (both are falcon ridge devices) and these contain a few firmware
>> changes. For example SXIO, SXIL and SXLV are gone so the shutdown
>> quirk will fail. With some luck that means that the shutdown quirk is
>> no longer required for falcon ridge hardware.
>
> Yeah, it seems I don't need the suspend quirk - the NHI is still there
> without it. I still think we should make the quirk general rather than
> tying it to the machines, the worst case is that it'll just do nothing.
Ok, agreed. The "wait" quirk has to run on all machines and the other
one will fail if the ACPI methods are not there. Should I resend the
series or just the patch or should I (or do you want to) make a
separate patch?

Andreas
