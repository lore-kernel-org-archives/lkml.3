Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbbALUdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:33:11 -0500
Received: from mail-yk0-f171.google.com ([209.85.160.171]:42626 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbbALUdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:33:09 -0500
MIME-Version: 1.0
In-Reply-To: <20150112203003.GB23277@node.dhcp.inet.fi>
References: <20141218175126.GA78864@vmdeb7> <20150111225802.GA12944@node.dhcp.inet.fi>
 <20150112183831.GA99900@vmdeb7> <CAObL_7FCiZJuTQNUfqjoxaRscB+_2fvwpnXDt3d8E+0dFm=i6A@mail.gmail.com>
 <20150112200331.GA23277@node.dhcp.inet.fi> <CAObL_7FwxW=oq9L+POVx_4S9HSZW2QM3bnTNW37rDsUA=-U3FA@mail.gmail.com>
 <20150112203003.GB23277@node.dhcp.inet.fi>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 12 Jan 2015 12:32:49 -0800
X-Google-Sender-Auth: eInVlIDO0Yk1JIROSZa0vcZUN70
Message-ID: <CAObL_7F1_wmqCVf3dQyKFs1vP6DSJnmky_pGDM3cRcZOZtni1w@mail.gmail.com>
Subject: Re: [GIT PULL] platform-drivers-x86 for 3.19
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Darren Hart <dvhart@infradead.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 12:30 PM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> On Mon, Jan 12, 2015 at 12:05:45PM -0800, Andrew Lutomirski wrote:
>> On Mon, Jan 12, 2015 at 12:03 PM, Kirill A. Shutemov
>> <kirill@shutemov.name> wrote:
>> > On Mon, Jan 12, 2015 at 10:42:11AM -0800, Andrew Lutomirski wrote:
>> >> On Mon, Jan 12, 2015 at 10:38 AM, Darren Hart <dvhart@infradead.org> wrote:
>> >> > On Mon, Jan 12, 2015 at 12:58:02AM +0200, Kirill A. Shutemov wrote:
>> >> >> On Thu, Dec 18, 2014 at 09:51:27AM -0800, Darren Hart wrote:
>> >> >> > thinkpad-acpi using software mute simplifies the driver and the user experience
>> >> >> > significantly.
>> >> >>
>> >> >> Except when it doesn't.
>> >> >>
>> >> >> I'm probably in minority, but I don't use fancy userspace to mess with my
>> >> >> mixer and the mute button worked just fine for me before the change.
>> >> >> Wasted half an hour to find out what happened is not a pure win from user
>> >> >> experience point of view.
>> >> >>
>> >> >> Is it really necessary to have software_mute_requested == true by default?
>> >> >> Can fancy userspace ask for desired behaviour instead and change kernel to
>> >> >> not send hotkeys change notification until software_mute is enabled?
>> >> >>
>> >> >> --
>> >> >>  Kirill A. Shutemov
>> >> >>
>> >> >
>> >> > Thanks for the report Kirill,
>> >> >
>> >> > Andy, we're at RC4, so if we need to fix (or revert) this fix, we only have a
>> >> > couple weeks to do so.
>> >> >
>> >> > Kirill, to define the scope of the problem, if you specify
>> >> > software_mute_requested as false on the kernel command line, does your system
>> >> > function as expected?
>> >>
>> >> If I understood Kirill's email correctly, the only issue is that he
>> >> liked the old behavior.  Kirill, is that correct?
>> >
>> > Yes. For now I use thinkpad_acpi.software_mute=0 to get old behaviour.
>> >
>>
>> What aspect of the old behavior is better than the new default behavior?
>
> It's not necessary better. The new behavior just broke my use-case.
>
> I don't have anything in my system what would react on KEY_MUTE and I used
> the functionality platform provides until it suddenly stopped working.
>
> I personally can live with new thinkpad_acpi. I'll probably update my
> configuration to react on the software button.

You'd have to do that anyway if you switched to a non-ThinkPad, for
better or for worse.

>
> But who else will get frustrated after update to v3.19?

Hopefully fewer people than got frustrated by the old, broken
behavior.  (It probably wasn't obviously broken for you, because you
didn't have software that reacted to KEY_MUTE.  But, if you did, you
might have noticed all kinds of strange behavior.)

--Andy

>
> --
>  Kirill A. Shutemov
