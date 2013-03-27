Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3C0T3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:29:37 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:43046 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab3C0T3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:29:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130325235525.GA3423@srcf.ucam.org>
References: <kg69ef$vdb$1@ger.gmane.org> <CAPM=9ty0Apsk_5v+aguHQMzFhi9A9kMcWb8fXBmWus9Z=tA=JA@mail.gmail.com>
 <5126C3E1.80801@gmail.com> <513BACAC.9050800@gmail.com> <CA+55aFyOypoeXgBWP0d7KmL3YezmjwEgrB=ntZaZdYjdmFkQpA@mail.gmail.com>
 <20130319195950.GA16828@srcf.ucam.org> <CA+55aFy9nbc+9VyCg0BA9E85sRwksQXvu6Wqgurf5omv2mPtZw@mail.gmail.com>
 <5148D5C8.2000701@gmail.com> <CAPM=9tyYMSsK_2eCNRTx5EsgAQtnvmHxhgPHP3GHPxKUn+wo5w@mail.gmail.com>
 <20130325235525.GA3423@srcf.ucam.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 27 Mar 2013 13:29:15 -0600
Message-ID: <CAErSpo7iUsV4ca0vhs085_prsTXBEvuTnuw1O_NUr-CvUytYGQ@mail.gmail.com>
Subject: Re: Regression: Screen turns off when booting in EFI mode
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Dave Airlie <airlied@gmail.com>,
        =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Skeggs <skeggsb@gmail.com>, bugzilla@colorremedies.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Chris, reporter of Fedora issue]

On Mon, Mar 25, 2013 at 5:55 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Mar 26, 2013 at 09:52:14AM +1000, Dave Airlie wrote:
>> >>> Because it's the only way to get the PCI ROM in some cases, like on
>> >>> pretty much all Apples with Radeons. Only using it if we have no other
>> >>> options probably makes sense, though. Something like this (entirely
>> >>> untested)?
>> >>
>> >> This looks reasonable. Mantas?
>> >
>> > It compiles, boots, and even makes the graphics card work again.
>> > So it looks good to me.
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=927451
>>
>> popped up sounds like a regression caused by this.

That RedHat bugzilla is from kernel-3.9.0-0.rc4.git0.1.fc19.x86_64.
Does that kernel include Matthew's patch from Mar 19?  I'm wondering
if that report is for the same problem Mantas saw and possibly would
be *fixed* by the Mar 19 patch, or if it is for a problem with the Mar
19 patch itself.

I would check this myself, but I don't know how to figure out what's
in kernel-3.9.0-0.rc4.git0.1.fc19.x86_64.

Mantas confirmed that the Mar 19 problem fixed *his* issue, but I
haven't seen any reports from either Mantas or Chris (the RedHat
bugzilla reporter) for the new Mar 26 patches.

> Sigh. I guess we need to figure out where it thinks it's getting that
> image from. The alternative is basically to go back to what Linus
> suggested, remove this from pci_map_rom() and add an explicit lookup to
> the video drivers.
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
