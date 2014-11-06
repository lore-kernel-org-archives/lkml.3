Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaKFRjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:39:40 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:56772 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaKFRjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:39:36 -0500
MIME-Version: 1.0
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01EB7CC3@SHSMSX101.ccr.corp.intel.com>
References: <1415151063-2530-1-git-send-email-chuansheng.liu@intel.com>
 <CAErSpo6cWP2ngErLVzqASkeQOLsB7JjgCC8UuA-S=Lz=AJyf6Q@mail.gmail.com>
 <545A7087.3050802@laposte.net> <CAErSpo4fvoeP9Gab1ZDg=ofjH+aqxGD09nLDTF1ZERnH=yEPxw@mail.gmail.com>
 <27240C0AC20F114CBF8149A2696CBE4A01EB7713@SHSMSX101.ccr.corp.intel.com>
 <CAErSpo4py1GdxczyzgLxjbgmfGEQ6o+He=7wxuVS0BM-Oyd6_w@mail.gmail.com>
 <27240C0AC20F114CBF8149A2696CBE4A01EB7B96@SHSMSX101.ccr.corp.intel.com>
 <545B08DF.2090608@intel.com> <27240C0AC20F114CBF8149A2696CBE4A01EB7CC3@SHSMSX101.ccr.corp.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 6 Nov 2014 10:39:15 -0700
Message-ID: <CAErSpo6ugBFdempQGqXUfO4Pt=SVHyDSH3t=awngDdjXhcrk+w@mail.gmail.com>
Subject: Re: [PATCH] PCI: Do not enable async suspend for JMicron chips
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "Lu, Aaron" <aaron.lu@intel.com>, Barto <mister.freeman@laposte.net>,
        "Tejun Heo (tj@kernel.org)" <tj@kernel.org>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 11:39 PM, Liu, Chuansheng
<chuansheng.liu@intel.com> wrote:
>
>
>> -----Original Message-----
>> From: Lu, Aaron
>> Sent: Thursday, November 06, 2014 1:37 PM
>> To: Liu, Chuansheng; Bjorn Helgaas
>> Cc: Barto; Tejun Heo (tj@kernel.org); Rafael Wysocki;
>> linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] PCI: Do not enable async suspend for JMicron chips
>>
>> On 11/06/2014 01:29 PM, Liu, Chuansheng wrote:
>> > Hello Bjorn,
>> >
>> >> -----Original Message-----
>> >> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
>> >> Sent: Thursday, November 06, 2014 12:09 PM
>> >> To: Liu, Chuansheng
>> >> Cc: Barto; Tejun Heo (tj@kernel.org); Lu, Aaron; Rafael Wysocki;
>> >> linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org
>> >> Subject: Re: [PATCH] PCI: Do not enable async suspend for JMicron chips
>> >>
>> >> On Wed, Nov 5, 2014 at 6:48 PM, Liu, Chuansheng
>> >> <chuansheng.liu@intel.com> wrote:
>> >>> Hello Bjorn,
>> >>>
>> >>>> -----Original Message-----
>> >>>> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
>> >>>> Sent: Thursday, November 06, 2014 3:04 AM
>> >>>> To: Barto
>> >>>> Cc: Liu, Chuansheng; Lu, Aaron; Tejun Heo; Rafael Wysocki;
>> >>>> linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org
>> >>>> Subject: Re: [PATCH] PCI: Do not enable async suspend for JMicron chips
>> >>>>
>> >>>> On Wed, Nov 5, 2014 at 11:46 AM, Barto <mister.freeman@laposte.net>
>> >>>> wrote:
>> >>>>> this patch solves these 2 bug reports :
>> >>>>>
>> >>>>> https://bugzilla.kernel.org/show_bug.cgi?id=84861
>> >>>>>
>> >>>>> https://bugzilla.kernel.org/show_bug.cgi?id=81551
>> >>>>
>> >>>> Those bugs were already mentioned.  But e6b7e41cdd8c claims to solve
>> >>>> https://bugzilla.kernel.org/show_bug.cgi?id=81551, and 84861 is a
>> >>>> duplicate of 81551, so it should also be fixed by e6b7e41cdd8c.
>> >>>>
>> >>>> So the question is, why was e6b7e41cdd8c insufficient?  Presumably it
>> >>>> was tested and somebody thought it did fix the problem.
>> >>>
>> >>> The first patch e6b7e41cdd8c which is just exclude some of JMicron
>> >> chips(363/361) out of async_suspend,
>> >>> then Barto found the same issue on JMicron 368, so we need one more
>> >> general patch to let JMicron chips
>> >>> out of async_suspend, so we make this patch.
>> >>>
>> >>> Bjorn, tj,
>> >>> Could you kindly take this patch? As Barto said, it effected the user
>> >> experience indeed, thanks.
>> >>
>> >> Thanks for clarifying the changelog as far as the different chips and
>> >> the different bugzillas.
>> >>
>> >> But you haven't addressed my concerns about (1) putting a PCI vendor
>> >> ID check in the generic PCI core code, and (2) applying this to *all*
>> >> JMicron devices.  You might want to explore a quirk-type solution or
>> >> maybe just add the JMicron 368 to the checks added by e6b7e41cdd8c.
>> > Understand your point, in fact, before this patch submitted, I had written
>> another patch https://lkml.org/lkml/2014/9/24/68
>> > which addressed to add the quirk-type solution in ATA code, and Aaron given
>> better suggestion that implemented at pci_pm_init().
>> > How do you think of it? Thanks.
>>
>> I think Bjorn means that we should place the code as a fixup somewhere
>> in the quirks.c. I didn't take a closer look but DECLARE_PCI_FIXUP_FINAL
>> for those JMicron PCI devices seems to be a proper phase.
>
> Thanks Aaron, then how about below patch?
>
> diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
> index 47e418b..9e85f86 100644
> --- a/drivers/ata/pata_jmicron.c
> +++ b/drivers/ata/pata_jmicron.c
> @@ -158,6 +158,21 @@ static int jmicron_init_one (struct pci_dev *pdev, const struct pci_device_id *i
>         return ata_pci_bmdma_init_one(pdev, ppi, &jmicron_sht, NULL, 0);
>  }
>
> +/*
> + * For JMicron chips, we need to disable the async_suspend method, otherwise
> + * they will hit the power-on issue when doing device resume, add one quick
> + * solution to disable the async_suspend method.

A "quick solution" is a red flag for me, because it's a hint that you
just want the problem to go away without fully understanding it.
That's probably not the case; it's probably just that *I* don't
understand it all yet.

> +static void pci_async_suspend_fixup(struct pci_dev *pdev)
> +{
> +       /*
> +        * disabling the async_suspend method for JMicron chips to
> +        * avoid device resuming issue.
> +        */
> +       device_disable_async_suspend(&pdev->dev);
> +}
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, pci_async_suspend_fixup);

I know Barto tested this and it didn't work, but this *strategy* is
far better than adding the JMicron test in pci_pm_init().  It's ideal
if a quirk like this could be in the pata_jmicron.c file, so it's only
included when that driver is loaded.  But it would still be OK if it
had to be in drivers/pci/quirks.c, e.g., if something has to be done
even before the driver is loaded.

The idea of a quirk is to work around a defect in a device.  What is
the defect in this case?  It seems there are two devices involved,
e.g. (from https://bugzilla.kernel.org/show_bug.cgi?id=81551):

  02:00.0 JMicron Technology Corp. JMB363 SATA/IDE Controller
  02:00.1 JMicron Technology Corp. JMB363 SATA/IDE Controller

The PCI power management code is designed to work correctly with all
devices that conform to the spec.  So either one of these devices
doesn't conform to the spec, or the PM code is assuming some behavior
that the spec doesn't actually require.  If the latter, we need to fix
the PM code, because it won't work with other non-JMicron devices
either.

I haven't seen reports of other devices, so my guess is that it really
*is* a defect in these JMicron devices, but I still need a better
understanding of exactly what's broken.  Maybe it's something like:

  - 02:00.0 and 02:00.1 are both in D3
  - if we try to put 02:00.1 in D0 first, it fails ("Refused to change
power state, currently in D3")

and the resolution is to change 02:00.0 from D3 to D0 first, then
change 02:00.1 from D3 to D0.  Or maybe it's just that there needs to
be a delay between changing 02:00.0 and changing 02:00.1 (since I
suspect we *start* those changes in that order anyway)?

In either case it sounds like a device defect, because I don't see
anything in the PCI Power Management spec about ordering requirements
for multifunction devices.

Speaking of ordering, what is it that guarantees 02:00.0 will be
powered up before 02:00.1 when async suspend is disabled?  Is it the
dpm_noirq_list order in dpm_resume_noirq()?

I don't know how much we gain by allowing async resume of
multifunction devices.  Is it possible that Windows always powers up
multifunction devices in order?  I doubt that Windows would have a
quirk similar to what you're proposing here, so I wonder how they deal
with this issue.

It sounds like this issue only affects multifunction JMicron devices,
so possibly the quirk could be made smarter by only disabling async
suspend when it finds those.

Per https://bugzilla.kernel.org/show_bug.cgi?id=81551#c8, this is a
regression introduced by 76569faa62c4 ("PM / sleep: Asynchronous
threads for resume_noirq"), which appeared in v3.15.  That information
needs to be in the changelog.

Rafael, do you want to jump in here?  I know almost nothing about the
PCI power management code, so if you want to take over this whole
thing, that would be fine by me.

Bjorn
