Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab3FNV1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:27:18 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:49846 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab3FNV1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:27:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWevd6ZNDdqGkqbLrGujKYuTiwibPAT+30VPpC_H-rLJA@mail.gmail.com>
References: <CAE9FiQVu5QyxaKsYzzQoroQD=TvsziHzDOtoeg=FvhZ8HyN5yw@mail.gmail.com>
 <CAErSpo7ChfRiEn0eR1rf-mVheUS9Yf8f+j4n78PJcGYh+yMVgA@mail.gmail.com>
 <CAE9FiQXkDg7Y336S=DXoms44=5HLaiUx=sWviupz1fJmaDUEzQ@mail.gmail.com>
 <CAE9FiQU5c=ztzbskNnYFFKF9V5zO+jnRcMBCivLxA1F3fSfX5w@mail.gmail.com>
 <20130401235256.GA31966@google.com> <CAE9FiQV8cPh-s6=EQu_cZTtn86+NwZE5KuGMhf43aOhzkL=hwA@mail.gmail.com>
 <CAErSpo7Jni1ZSf_W=vB3kqsucPpoepa2Q5g=77a6D3FaPwe9LA@mail.gmail.com>
 <CAE9FiQWjQXwiTWju6cBc_o25jy_wmZ1u+Pifh1wdnxtV=i5ENw@mail.gmail.com>
 <CAErSpo7=a-wX6BLbm_O1nUMMrQHOgtSm3xZHKuRqaz8rnKSbRA@mail.gmail.com>
 <CAE9FiQUbw7OUhRB+gKMxkuE9+nm9097+mwZ2z4adO8Hv_NjF1Q@mail.gmail.com>
 <20130614141101.GA29452@google.com> <CAE9FiQVr-OWeqEHFXn0MjNiSD0WM=FNO_DFo6m9UbbG60uonpw@mail.gmail.com>
 <CAErSpo7grN-93zZfBJOHZH-pR1wDYrojTwt=B=++QqA0rPb3Rg@mail.gmail.com>
 <CAE9FiQUO350kqrXB5=yQ-OxOeSJj4+P6WPg4gGgXxFEvfoLyng@mail.gmail.com>
 <CAErSpo6vEOw10YV=Sou6wjjSc2GWr-oX=Dvbt7Xt=RJKi4RELw@mail.gmail.com> <CAE9FiQWevd6ZNDdqGkqbLrGujKYuTiwibPAT+30VPpC_H-rLJA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 14 Jun 2013 15:26:52 -0600
Message-ID: <CAErSpo66qtgg8=BqX+4sm4h1vXD5gR6aiH7hHK7gvz1x3rEQZA@mail.gmail.com>
Subject: Re: [PATCH] PCI: Remove not needed check in disable aspm link
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Roman Yepishev <roman.yepishev@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Maxim, Jussi]

On Fri, Jun 14, 2013 at 12:26 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Jun 14, 2013 at 10:44 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Fri, Jun 14, 2013 at 10:57 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> On Fri, Jun 14, 2013 at 9:33 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>>> On Fri, Jun 14, 2013 at 10:17 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>>>
>>>> Can you please refer to specific function names?  I can't read your mind.
>>>>
>>>> You might be referring to quirk_disable_aspm_l0s().  This is a
>>>> pci_fixup_final quirk that calls pci_disable_link_state().  In the
>>>> current tree, we enumerate devices before requesting _OSC control.
>>>> However, pci_fixup_final quirks are not run until the
>>>> pci_apply_final_quirks() fs_initcall, which is after we request _OSC
>>>> control.
>>>>
>>>> As far as I can tell, we never call pci_disable_link_state() before
>>>> calling pcie_no_aspm().
>>>
>>> ok, you are right, that is not pci_disable_link_state.
>>>
>>> It is pcie_aspm_init_link_state ==> pcie_aspm_sanity_check in booting path
>>> that disable aspm.  It has  "if (aspm_disabled)" in it, and it cause
>>> the difference.
>>
>> Yes, I agree, the pcie_aspm_init_link_state() path uses aspm_disabled
>> before we set it:
>>
>>     acpi_pci_root_add
>>       pci_acpi_scan_root
>>         pci_scan_child_bus
>>           pci_scan_slot
>>             pcie_aspm_init_link_state
>>               pcie_aspm_sanity_check
>>                 if (aspm_disabled)              # used before set
>>                   ...
>>       acpi_pci_osc_control_set
>>       pcie_no_aspm
>>         aspm_disabled = 1                       # set
>>
>> That might mean we do some ASPM configuration during enumeration (in
>> pci_scan_slot()) even though the BIOS hasn't given us permission.  It
>> looks like we did that even in v3.7, since we did the enumeration
>> before the _OSC there as well.  That looks like a bug to me.
>
> agreed. that means commits from Matthew Garrett
>
> commit 4949be16822e92a18ea0cc1616319926628092ee
> Author: Matthew Garrett <mjg@redhat.com>
> Date:   Tue Mar 6 13:41:49 2012 -0500
>
>     PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled
>
> commit c9651e70ad0aa499814817cbf3cc1d0b806ed3a1
> Author: Matthew Garrett <mjg@redhat.com>
> Date:   Tue Mar 27 10:17:41 2012 -0400
>
>     ASPM: Fix pcie devices with non-pcie children
>
> will only works when the user specify "aspm=off" in boot command line.
>
> (Roman's should have problem when he boot current linus tree with
> "aspm=off", as no one will disable aspm for the offending pci devices)
>
> To close the hole that Matthew' commits miss, that we should move _OSC
> support/control set ahead.
>
> For Roman's system it will have to fail, as BIOS enable prep-1.1 pcie devices
> aspm, and do not handle over control to OS, so os can not disable aspm link
> state for it.
>
> To workaround the problem in Roman's system, we can add pcie_aspm=force_off
>
> so we will have
> pcie_aspm=off
> pcie_aspm=force
> pcie_aspm=force_off
>
> What a mess!

Yeah, this is a huge mess.  It makes my head hurt.  I don't think it's
reasonable to add more flags because that will make my head hurt even
more.

If I understand correctly, on Roman's system (the Acer Aspire One
AOA150 netbook mentioned in
https://bugzilla.kernel.org/show_bug.cgi?id=55211):

  - The BIOS leaves ASPM enabled for the ath5k device (03:00.0)
  - The BIOS does not allow the OS to manage ASPM (via _OSC)
  - The ath5k device does not work correctly with ASPM enabled
  - The ath5k driver calls pci_disable_link_state(), but we do not
disable ASPM because we don't have permission from the BIOS

This is basically the case I investigated in bz 57331 [1], and my
conclusion was that Windows behaves the same way, i.e., Windows also
leaves ASPM enabled in this situation.

It would be interesting to know whether that device on Roman's machine
works under Windows and what the ASPM configuration there is.  When
Maxim added the pci_disable_link_state() to ath5k with 6ccf15a1, he
did say that the Windows driver disabled L0s [2], but I don't know
what machine that was or what its _OSC method said.

At the time of 6ccf15a1, Linux evaluated _OSC but did not call
pcie_no_aspm() when it failed, so the pci_disable_link_state() in
ath5k actually *did* disable ASPM.

I did find the Atheros Windows driver for the AOA150 on the Acer
website [3], and the .INF file has several interesting mentions of
ASPM, but I don't know what they mean.

Bjorn

[1] https://bugzilla.kernel.org/show_bug.cgi?id=57331#c5

[2] https://lists.ath5k.org/pipermail/ath5k-devel/2010-June/003842.html

[3] http://global-download.acer.com/GDFiles/Driver/Wireless%20LAN/WLAN_Atheros_7.6.0.224_XPx86_A.zip?acerid=633639843308102758&Step1=NETBOOK,%20CHROMEBOOK&Step2=ASPIRE%20ONE&Step3=AOA150&OS=ALL&LC=en&BC=ACER&SC=PA_6
