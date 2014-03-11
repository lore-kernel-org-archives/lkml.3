Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaCKCHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 22:07:45 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:52191 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbaCKCHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 22:07:43 -0400
MIME-Version: 1.0
In-Reply-To: <1394496924.16134.40.camel@x220>
References: <CAKMK7uFx2kksGgnuy9e0xiQRKpt=_+44O1V4wbX5yNBocvjBkg@mail.gmail.com>
 <1391951759.6036.7.camel@artifact> <1391952344.25424.4.camel@x220>
 <CAErSpo6uj_Kuk0_F97nRsnM1Pss4C7=HeEaVu6D-NwFFK=1cvA@mail.gmail.com>
 <1394185698.5608.5.camel@x41> <CAErSpo4jiq38P3TNuGLGS--nbV9NtUAmiuK=cwWyFAneY-=eOA@mail.gmail.com>
 <1394212609.1987.6.camel@x41> <20140307204021.GA9822@google.com>
 <CAErSpo7Np8oju1ENQA5EgEpN4=Vv7f3s4E823ecbyp6FCWPL_Q@mail.gmail.com>
 <1394289877.31006.2.camel@x41> <20140310182431.GA11424@google.com>
 <1394495121.1975.6.camel@x41> <CAErSpo6Q0w0OAenw7Uh0bjiZucpxatkUuWzREHmEvsNKJYf-qw@mail.gmail.com>
 <1394496924.16134.40.camel@x220>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 10 Mar 2014 20:07:22 -0600
Message-ID: <CAErSpo52b6BdGXVS36hxB4o_doqVONK3HkJu3U6OFVHj-YreWQ@mail.gmail.com>
Subject: Re: [Intel-gfx] agp/intel: can't ioremap flush page - no chipset flushing
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Steven Newbury <steve@snewbury.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 6:15 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Mon, 2014-03-10 at 18:07 -0600, Bjorn Helgaas wrote:
>> On Mon, Mar 10, 2014 at 5:45 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
>> > A bit of doubt is caused by two new boot time messages:
>> >     pnp 00:00: unknown resource type 10 in _CRS
>> >     pnp 00:00: can't evaluate _CRS: 1
>> >
>> > But I haven't yet tried v3.14-rc6 without your patch, so these might be
>> > unrelated. They're unclear to me, anyway.
>>
>> Hmm, this is definitely concerning.  Resource type 10 is
>> ACPI_RESOURCE_TYPE_FIXED_MEMORY32, which we do handle (unless it's
>> length 0).  And your previous dmesg logs (at
>> https://bugzilla.kernel.org/show_bug.cgi?id=71611) don't show anything
>> like that.
>>
>> Can you attach an acpidump and the dmesg log with my patch to the bugzilla?
>
> It's getting rather late over here. So I'll try (quite) a few hours
> later. But acpidump doesn't ring any bells right now. Any hints?

There's acpidump info here: https://01.org/linux-acpi/utilities .  You
don't need to extract the binary tables or anything; just attach the
text dump to the bugzilla.

It would be very interesting to try v3.14-rc6 without my patch.  I
hope it has the same "unknown resource type" messages, because I don't
see how my patch could be related to them.  There were no recent
PNP-related changes, so then I start to worry about some sort of
memory corruption from an unrelated patch.  But I hope that's not the
case.

Bjorn
