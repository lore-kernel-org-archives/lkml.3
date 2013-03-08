Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab3CHAjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 19:39:52 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:35386 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759944Ab3CHAju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 19:39:50 -0500
MIME-Version: 1.0
In-Reply-To: <5138F6B6.8050208@googlemail.com>
References: <51016937.1020202@googlemail.com> <510189B1.606@fold.natur.cuni.cz>
 <5104427D.2050002@googlemail.com> <510494D6.1010000@gmail.com>
 <51050D43.2050703@googlemail.com> <51051B1B.3080105@gmail.com>
 <51052DB2.4090702@googlemail.com> <51053917.6060400@fold.natur.cuni.cz>
 <5105491E.9050907@googlemail.com> <510558CE.9000600@fold.natur.cuni.cz>
 <5105AFDB.9000200@googlemail.com> <5105E51D.2020606@huawei.com>
 <51064F1A.1020909@googlemail.com> <51065FA6.4070208@googlemail.com>
 <51066B46.10409@fold.natur.cuni.cz> <5106CD6C.4070009@googlemail.com>
 <5106E770.9070602@fold.natur.cuni.cz> <510A5F0E.6010100@googlemail.com>
 <CAErSpo4x8pb7J8MnokXiFTE=01-TffCk6CKC0VS7CEf3X1bSBw@mail.gmail.com>
 <5138C03C.8080600@googlemail.com> <CAErSpo4nyRgUf8hsbNKBTzW+eqzyNTrLFYFaJ6v=sSVQg7CBPw@mail.gmail.com>
 <5138F6B6.8050208@googlemail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 7 Mar 2013 17:39:29 -0700
Message-ID: <CAErSpo6=Fkfi2TTyoDCXpvnmvyYgio1PQjscwn66vHN4FF2X2g@mail.gmail.com>
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
To: Chris Clayton <chris2553@googlemail.com>
Cc: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Yijing Wang <wangyijing@huawei.com>,
        Yijing Wang <wangyijing0307@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 1:21 PM, Chris Clayton <chris2553@googlemail.com> wrote:
>
>
> On 03/07/13 17:30, Bjorn Helgaas wrote:
>>
>> On Thu, Mar 7, 2013 at 9:28 AM, Chris Clayton <chris2553@googlemail.com>
>> wrote:
>>>
>>>
>>>
>>> On 03/06/13 23:45, Bjorn Helgaas wrote:
>>>>
>>>>
>>>> On Thu, Jan 31, 2013 at 5:09 AM, Chris Clayton
>>>> <chris2553@googlemail.com>
>>>> wrote:
>>>>
>>>>> My usb3 expresscard device has arrived and I get an oops with that too,
>>>>> if I
>>>>> remove it without unloading the driver first. I guess it shouldn't be a
>>>>> surprise that the driver isn't expecting the device to disappear.
>>>>>
>>>>> As I mentioned, I have some trouble with the WinTV-HVR-1400 card, which
>>>>> sometimes pops out again, if I push it into the slot too hard (but I'm
>>>>> geeting better at that with practice). So what I've done (with the usb3
>>>>> card
>>>>> too) to avoid the oopsen is blacklist the driver in
>>>>> /etc/modprobe.d/blacklist.conf and then load them when I'm sure the
>>>>> card
>>>>> is
>>>>> properly inserted. Not exactly hotplug, but at least I don't have to
>>>>> reboot
>>>>> because of an oops- and it's not something I'm doing several times an
>>>>> hour.
>>>>
>>>>
>>>>
>>>> Hi Chris,
>>>>
>>>> What's the current state of this?  It sounds to me like it still
>>>> doesn't work out of the box.  Having to blacklist the driver and load
>>>> it manually is a completely unacceptable user experience.  If you have
>>>> to manually choose acpiphp over pciehp, that is also unacceptable.
>>>>
>>>> So if you're still limping along with hacky workarounds like this, I'd
>>>> like to pursue this more and see if we can't figure out a better
>>>> solution.
>>>>
>>>> Bjorn
>>>>
>>> Hi Bjorn,
>>>
>>> If I unblacklist the driver, insert the HVR-1400 card and then remove it,
>>> I
>>> still get the oops. This is with kernel 3.8.2. I no longer get the oops
>>> with
>>> the USB3 card, but I don't know how or when that was fixed.
>>>
>>> I stopped working on it when, after finding the workaround to the oops
>>> and
>>> then spending many many hours figuring out a fix so that scandvb would
>>> find
>>> some channels, no one on the linux-media list seemed interested in the
>>> fix.
>>> On top of that, even though scanning now finds all the available
>>> channels,
>>> the quality of the TV picture and sound is very poor indeed. I didn't
>>> want
>>> to bang my head against the linux-media wall again, so I abandoned the
>>> card
>>> and now use a USB TV stick, which gives is much better results than the
>>> card. It's a pity because the card also supports an analog signal which
>>> means I can watch the RF output from my satellite box, which I have piped
>>> around the house. Anyway, the linux-media folks are not your problem and
>>> if
>>> I want to watch satellite TV on my laptop, I can make one of my rare
>>> visits
>>> to Windows (where the picture and sound are good).
>>>
>>> Having said (ranted?) all that, I would be more than happy to help fix
>>> the
>>> oops. After I first reported it, I realised that I didn't have a hotplug
>>> driver loaded. With help from Yijing Wang, we eventually managed to get
>>> the
>>> card recognised and drivers loaded when it is inserted. That doesn't help
>>> with the oops, though. I now have the pciehp driver compiled statically
>>> onto
>>> the kernel (and pass pcie_ports=native to the kernel), but removing the
>>> card
>>> with the cx23885 driver loaded always results in an oops. I originally
>>> reported this to the linux-media list because functions from the cx23885
>>> driver are at the top of the call trace, but only Martin responded with
>>> some
>>> hotplug-related suggestions, which is what swung discussion the way of
>>> the
>>> linux-pci list.
>>
>>
>> OK.  There are several potential problems here.
>>
>> 1) The change to make scandvb find some channels.  This is probably a
>> cx23885 or linux-media issue, and I can't help with that.
>>
>> 2) TV picture/sound quality problem.  Again, probably a cx23885 driver
>> issue, and I can't help with that.
>>
>
> I'm not going to use the card and I don't have the time (or patience) to
> submit the change again.
>
>
>> 3) HVR-1400 not being recognized when inserted.  This is a PCI hotplug
>> issue, and I *can* help with this.  I don't know what your hardware
>> is, but in general, pciehp should take care of this.  If it doesn't,
>> or if you have to use an argument like "pcie_ports=native", we should
>> fix this.
>>
>> 4) Oops when removing HVR-1400 ExpressCard.  From the backtrace, I
>> assume the cx23885 driver is still bound to the device when you remove
>> the card.  It'd be nice if the driver could handle the device going
>> away, but I'm not surprised that it doesn't.
>
> Nor am I, but it's hardly plug and play, is it. With Windows I can plug and
> unplug the card at will without crashing the system.

I agree 100%, that sucks, and we should be able to do better.  I
opened https://bugzilla.kernel.org/show_bug.cgi?id=54961 for this
issue.  Hopefully a cx88 driver person will take a look.

>> So 3) is the thing I might be able to help with.  If there's still a
>> problem here (and even having to boot with an argument is a problem),
>> let's start by collecting complete dmesg logs, with and without your
>> "pcie_ports" option.  Boot without the card installed, then insert it
>> and remove it.  If you can use something like v3.9-rc1 with
>> CONFIG_HOTPLUG_PCI_PCIE=y, that would be ideal.
>
> OK, I've gathered these logs using a kernel built from a pull of Linus' tree
> this afternoon (v3.9-rc1-108-g9f22578). Also, the cx23885 driver is still
> blacklisted to avoid unnecessary noise and the chance of an oops if the card
> springs out again when I insert it. The driver does load if it's not
> blacklisted (and the pcie_ports=native option is present).
>
> The two logs are attached. As you will see, nothing at all happens when the
> pcie_ports=native option is absent. The nf_conntrack message is normally the
> last one from a normal boot.

Perfect, thanks!

It looks like something's going wrong when we evaluate _OSC.  Can you
collect an acpidump from your machine?

It's possible your machine just doesn't want us to use pciehp.  Can
you set CONFIG_HOTPLUG_PCI_ACPI=y and try again (without
pcie_ports=native this time)?  You can test with a different
ExpressCard if you want; this part of the problem isn't related to the
HVR-1400.

Bjorn
