Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898Ab3GSOad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:30:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54038 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab3GSOaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:30:30 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-26-51e94d8450fa
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Re: libata / IDE cs5536: 80c cable detect issue (and worse?)
Date: Fri, 19 Jul 2013 16:30:22 +0200
Message-id: <3248604.en1UYLoEHA@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-45-generic; KDE/4.8.5; i686; ; )
In-reply-to: <20130719122653.GA12554@rhlx01.hs-esslingen.de>
References: <20130718181355.GA31889@rhlx01.hs-esslingen.de>
 <21479812.cJNm40xAqz@amdc1032> <20130719122653.GA12554@rhlx01.hs-esslingen.de>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jQd0W35eBBsu/qFlc/veGxeL7lutM
	FpP23GSyOLbjEZPF5V1z2CyWH//H5MDmsXPWXXaPJTfVPD4+vcXi8XmTXABLFJdNSmpOZllq
	kb5dAlfG/cmHGAvWm1VcXHyTtYFxuVYXIyeHhICJxLr5L1ghbDGJC/fWs3UxcnEICUxnlPgz
	eTeU08IkMWM5RBWbgJXExPZVjCC2iICCxL+unawgRcwCVxklOm9sYQNJCAt4SnRve88MYrMI
	qEo0PF0M1MDBwSugKbFkgyJIWFTAVeLcoh8sIDangI3Eoc7p7BDLehglpiy6BLaAV0BQ4sfk
	e2BFzALyEvv2T2WFsLUk1u88zjSBUWAWkrJZSMpmISlbwMi8ilE0tSC5oDgpPddIrzgxt7g0
	L10vOT93EyM4pJ9J72Bc1WBxiFGAg1GJh/fBl+eBQqyJZcWVuYcYJTiYlUR4fyW/CBTiTUms
	rEotyo8vKs1JLT7EKM3BoiTOe7DVOlBIID2xJDU7NbUgtQgmy8TBKdXAmFzz/7LYCpnHqoGM
	d1WdFixU/eXjEfLjvd8y4xtrLe8kqi0J6N2tmLxaZRHf9dYiFucJky6GSTu3pOyLPH1FzUGv
	MEFcgbHs7YL2KzffmCzd3N2/wb7Me6aaVcbmb4IfD6wTnhqgemh+af5FRxWHDeUhti5l1j5b
	Ou7UPTnMs+ozu9Weg/V5SizFGYmGWsxFxYkAiz0nTWUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 19, 2013 02:26:53 PM Andreas Mohr wrote:
> On Fri, Jul 19, 2013 at 12:40:38PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Hi,
> > 
> > On Thursday, July 18, 2013 08:25:41 PM Andreas Mohr wrote:
> > > Hi,
> > > 
> > > forgot to mention that I had already added a libata.force=40c boot
> > > after my 80c config issue discovery
> > > which did successfully cause the "limiting to UDMA/33 due to 40c foo" dmesg
> > > yet where there's now initial but strong confirmation via reports
> > > that the resulting UDMA/33 limit did NOT manage to fix corruption issues,
> > > thus it's more strongly likely that the "bound to ill-suited pata_amd driver"
> > > (due to incorrectly configuring speeds, or due to not configuring speeds
> > > at all due to possibly BIOS not providing emulation of PCI register accesses
> > > to Geode bus, which would be properly supported by pata_cs5536 OTOH)
> > > thing is the actual reason and might fix it (fingers crossed).
> > 
> > UDMA/66 (and higher) requires 80-wire cable to work (if the vendor states
> > that UDMA/66 is supported then UDMA/100 should also work on CS5536). UDMA/33
> > should work just fine with 40-wire cable. Therefore this indeed sounds more
> > like wrong driver being selected issue than a cable problem.
> 
> 
> Hohumm, news flash:
> 
> We just found out that such image corruption
> (not sure yet whether it's an *identical* case of corruption though)
> also can occur when having the CF image written by a premium USB combo writer
> on a *completely different machine* (should have done that counter check
> somewhat earlier, sorry...).
> IOW, this quite likely frees the driver from being the culprit
> for our specific case, i.e. we're likely talking about a stupid software issue.

OK.

> BUT, I'm still suspecting that we have a severe case of having the wrong driver activated:
> 
> . lsmod:
> sd_mod                 25977  2
> snd_cs5535audio         6485  0
> ata_generic             2239  0
> pata_cs5536             2294  0
> pata_amd                6641  1
> libata                117483  3 ata_generic,pata_cs5536,pata_amd
> scsi_mod              106093  2 sd_mod,libata
> cs5535_gpio             1756  0
> 
> Pray tell me, this does look like pata_cs5536 gets loaded
> due to also containing the PCI ID, yet then fails to bind,
> as opposed to pata_amd which does (reference count 1)?

Yes, pata_amd gets probed first and claims the device so pata_cs5536
can't bind to it when it gets loaded later.

> We also tried the pata_cs5536.msr=1 boot parm:
> 
> [    0.000000] Kernel command line: [..........] pata_cs5536.msr=1 libata.force=40c [............]
> 
> , and that did NOT cause the only recognizeable pata_cs5536-triggered
> log message
>                 printk(KERN_ERR DRV_NAME ": Using MSR regs instead of PCI\n");
> to occur in dmesg, IOW this driver *is* inactive.
> 
> We only had a
> 
> [   68.861778] pata_amd 0000:00:0f.2: version 0.4.1
> [   68.864570] scsi0 : pata_amd
> [   68.865240] scsi1 : pata_amd
> 
> 
> 
> So, AFAICS, this leaves us with up to three (perhaps four?) corrections
> that one would want to have:
> 
> - remove the woefully improper (forgotten!?!) CS5536 ID from pata_amd
>   (this correction is what one would want to have, and this would work fine,
>   right? Famous last words...)

Sounds fine to me given the description of the original commit 3957df6
("pata_cs5536: ATA driver for Geode companion chip"):

    This is a driver for the ATA controller on the Geode CS5536 companion
    chip.  The PCI device ID for this device was previously claimed by
    pata_amd.c but the PIO timings were not correct.  This driver also
    works around a bug in some BIOSes that handle unaligned access to the
    PCI config registers poorly.  Finally, the driver allows fallback to
    using MSR registers for configuration on BIOSes that are truly
    broken.

Martin, what is your opinion on this?

> - do a cable correction patch for libata side (I do think that indicating
>   40c if even one device is 40c-only is the way to go [as long as libata
>   cannot handle per-device settings], for safety reasons,

Why would libata need per-device cable setting? There is only one cable
per-port and it is shared between master/slave devices and some fancy
embedded implementations of the cable (CF slot + connector to slave
device) are not changing this fundamental design issue AFAIK.

>   and if so that's probably also preferrable to advertising an UNK value,
>   since UNK would skip towards device-side cable detection
>   which might be unreliable in case ATA ID values (i.e., ATA_ID_HW_CONFIG)
>   happen to be incorrect,
>   e.g. especially in the case of CF cards (OTOH it specifically looks
>   for a 0x2000 bit being *set* for 80c indication,
>   thus it should be reliable after all since you'd expect ignorant/older
>   devices to provide zeroed fields only...)

Most controllers have per-port cable detection and CS5536 is being
an exception here. I don't know how this detection is implemented in
the hardware / BIOS but it could be that it is already taking into
the account the drive side cable detection and that is why we have two
values per-port. Please also note that the cable detection is only one
of components of selecting device transfer speed which also involves
comparing maximum host and device capabilities.

Indicating 40c in case if one device detects the cable to be 40c and
the other one detects 80c would unnecessarily punish the faster device
(which would then need usage of kernel parameter to make it work at
the full speed). Moreover it is unlikely that the hardware / BIOS
incorrectly detects 40c cable as 80c one and if this happens the error
recovery should trigger on CRC transfer errors and downgrade the current
speed. Therefore I would stronly suggest leaving pata_cs5536 cable
detection as it is currently.

> - and what about cable correction patch for IDE side? Since IDE layer
>   cable probing sequence algo appears to be different ("why??"),
>   this might require advertising a different cable flag

I think that IDE CS5536 host driver doesn't need any changes w.r.t.
cable detection currently.

The IDE layer code is different for historical reasons and having
different probe method than libata (ah, the wonders of having two
pieces of code supporing the same hardware).

> - perhaps pata_cs5536 DMI quirk for that board, in case UDMA/100
>   (BIOS reports cable 0x03 value i.e. both 80c) happens to be too fast,
>   but given the advanced state of our discussion (pata_cs5536 driver
>   even completely inactive!!) and the DMI recognition issues that I reported
>   (empty strings) I don't think that's relevant, at least not now

Agreed.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

