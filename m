Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab3HFPrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 11:47:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51296 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab3HFPrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 11:47:49 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-34-52011aa370af
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: libata / IDE cs5536: 80c cable detect issue (and worse?)
Date: Tue, 06 Aug 2013 17:47:22 +0200
Message-id: <2719214.jFbbiq6hqY@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-45-generic; KDE/4.8.5; i686; ; )
In-reply-to: <20130719164531.GA14724@rhlx01.hs-esslingen.de>
References: <20130718181355.GA31889@rhlx01.hs-esslingen.de>
 <3248604.en1UYLoEHA@amdc1032> <20130719164531.GA14724@rhlx01.hs-esslingen.de>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t9jAd3FUoxBBr/vqltc/veGxeL7lutM
	FpP23GSyOLbjEZPF5V1z2CyWH//H5MDmsXPWXXaPJTfVPD4+vcXi8XmTXABLFJdNSmpOZllq
	kb5dAlfG2ksNzAVHbCu+LVNpYJxg2MXIySEhYCKxdPkLdghbTOLCvfVsXYxcHEICixglTp09
	xgSSEBJoYZLo+m0EYrMJWElMbF/FCGKLCChI/OvayQrSwCxwlVGi88YWNpCEsICrxM6L05i7
	GDk4WARUJW7s5wIJ8wpoShw/dIwFxBYFKjm36AeYzSlgI7Hi0UJGiMXdjBKHvzQyQTQISvyY
	fA+siFlAXmLf/qmsELaWxPqdx5kmMArMQlI2C0nZLCRlCxiZVzGKphYkFxQnpeca6hUn5haX
	5qXrJefnbmIEh/MzqR2MKxssDjEKcDAq8fBWiDEGCbEmlhVX5h5ilOBgVhLh9ZEACvGmJFZW
	pRblxxeV5qQWH2KU5mBREuc90GodKCSQnliSmp2aWpBaBJNl4uCUamBMzI5Z9q/06v4pkSEq
	Bjd7PHfZpVW4ZMysb5rr90Zv9/WkJzfXvX/WVyF1f+Ojy1pV2q8P+5kfMIzQlr++0YTbLtBw
	+ccMD5ErbZufztVkTtf44pS2YsrMwALFI7qBS/u3XFi1oLtN7Rt/0+njGtv0Zjpx3fX/+Hqv
	s0H2qdrShqKbfv7zri5WYinOSDTUYi4qTgQAqSoDxWMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday, July 19, 2013 06:45:31 PM Andreas Mohr wrote:
> Hi,
> 
> On Fri, Jul 19, 2013 at 04:30:22PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Friday, July 19, 2013 02:26:53 PM Andreas Mohr wrote:
> > > - do a cable correction patch for libata side (I do think that indicating
> > >   40c if even one device is 40c-only is the way to go [as long as libata
> > >   cannot handle per-device settings], for safety reasons,
> > 
> > Why would libata need per-device cable setting? There is only one cable
> > per-port and it is shared between master/slave devices and some fancy
> > embedded implementations of the cable (CF slot + connector to slave
> > device) are not changing this fundamental design issue AFAIK.
> 
> I think it's simply because while the CF slot more or less obviously
> seems to be rated "80c capable"-equivalent (due to its short connection?
> c.f. various notebook situations),
> *extension cable*(!) connections being connected to 44pin connectors
> ("ATA-44" ? conflicts with ATA/44 speed naming though)
> seem to be rated as ATA/33 (https://de.wikipedia.org/wiki/ATA/ATAPI)
> or IOW UDMA 2 (see various pages of 44pin CF adapter vendors).
> So that means that you'd end up with a "mixed" capability primary port
> (however my BIOS advertises 80c for both connectors,
> which I suspect may not really be appropriate).
> 
> If you are able to argue hard evidence that this primary port Master/Slave
> apparatus metallic layer connection is "one big shared resource"
> (i.e. from a HF / EMI POV)
> where behaviour ends up identical both for command and address timings
> for all devices for all things practical that matter, then yeah.
> But I have my doubts... (i.e., that it [address or command timings]
> actually is to be seen in a device-connection-specific light,
> to be reasonably safe).
> 
> But
> https://en.wikipedia.org/wiki/Parallel_ATA
> 
> "For all modern ATA host adapters this is not true, as modern ATA host
> adapters support independent device timing. This allows each device on
> the cable to transfer data at its own best speed. Even with older
> adapters without independent timing, this effect applies only to the
> data transfer phase of a read or write operation. This is usually the
> shortest part of a complete read or write operation."
> seems to tend towards indicating that libata *should* have a per-device
> form of .cable_detect(), unless "timing" != "cable type".

and indeed "timing" != "cable type"..

> And, OTOH, you simply could pose the argument
> that all that pseudo-intellectual reasoning does not matter,
> since CS5536 actively *chose* to offer *per-device-specific* cable type bits
> thus since it *does* offer such config possibility, libata *should*
> support such (unless CS5536 somehow happened to be wrong in offering such
> [useless?] liberty).
> 
> 
> One way to extend libata to support such functionality might be
> to have the driver set a flag to indicate that it has per-device cable type,
> and then let libata serve a .cable_detect_per_device() or some such
> instead.
> 
> Or choose to rework all drivers to have a per-device-extended
> .cable_detect() instead (where most drivers would not [need to] make the
> per-device distinction i.e. simply return the same setting for both).

I still don't see much need for this rework currently given that:
* such hardware setups are very rare (only CS5336 PATA controller gives
  you per-device cable type info, no other PATA controller does it AFAIK)
* we have fallback to lower speeds on errors
* even CS5536 BIOS describes the 44pin connector as 80c one and returns
  identical cable types for both master and slave devices (as reported by
  you in previous mail)

IOW until there is a practical need to enhance cable detection to work
per device it should not be done.

> > >   and if so that's probably also preferrable to advertising an UNK value,
> > >   since UNK would skip towards device-side cable detection
> > >   which might be unreliable in case ATA ID values (i.e., ATA_ID_HW_CONFIG)
> > >   happen to be incorrect,
> > >   e.g. especially in the case of CF cards (OTOH it specifically looks
> > >   for a 0x2000 bit being *set* for 80c indication,
> > >   thus it should be reliable after all since you'd expect ignorant/older
> > >   devices to provide zeroed fields only...)
> > 
> > Most controllers have per-port cable detection and CS5536 is being
> > an exception here. I don't know how this detection is implemented in
> > the hardware / BIOS but it could be that it is already taking into
> > the account the drive side cable detection and that is why we have two
> > values per-port. Please also note that the cable detection is only one
> > of components of selecting device transfer speed which also involves
> > comparing maximum host and device capabilities.
> 
> Yes, possibly because most controllers *do* have one single shared-medium
> cable connection location per port only, whereas CS5536 (it only offers
> one port in the first place, not two unlike many others!)
> seems to treat the two connectors
> (soldered-socket CF, and ATA-44 44pin, in the case of my system)
> differently, *for that single port*.
> 
> 
> CS5536 actually implicitly doing drive-side cable detection might be
> a reason for the separate bits as you say, but I doubt it
> (the controller would have to read out the device's ATA ID words, right??).
> 
> 
> > Indicating 40c in case if one device detects the cable to be 40c and
> > the other one detects 80c would unnecessarily punish the faster device
> > (which would then need usage of kernel parameter to make it work at
> > the full speed). Moreover it is unlikely that the hardware / BIOS
> > incorrectly detects 40c cable as 80c one and if this happens the error
> > recovery should trigger on CRC transfer errors and downgrade the current
> > speed. Therefore I would stronly suggest leaving pata_cs5536 cable
> > detection as it is currently.
> 
> OK, those are somewhat good {counter arguments | safety mechanisms}
> (but see my point above about my ATA-44 connector getting advertised as 80c),
> so perhaps...
> 
> BTW, does error recovery actively downgrade DMA mode on errors?
> (kernel-side? or hardware even?)

Kernel downgrades UDMA modes on CRC (checked by hardware) transfer errors.

> Didn't know that, but if so then a more aggressive default configuration
> probably is acceptable.
> 
> 
> > > - and what about cable correction patch for IDE side? Since IDE layer
> > >   cable probing sequence algo appears to be different ("why??"),
> > >   this might require advertising a different cable flag
> > 
> > I think that IDE CS5536 host driver doesn't need any changes w.r.t.
> > cable detection currently.
> > 
> > The IDE layer code is different for historical reasons and having
> > different probe method than libata (ah, the wonders of having two
> > pieces of code supporing the same hardware).
> 
> OK, so that leaves us with a possibly remaining debate on libata side only,
> and I'd argue for extending libata for per-device cable detect support,
> since that's arguably more precise and doesn't really cost anything
> (that callback likely is utter slowpath, init-only)...
> well, except for a sizeable amount of driver rework patches.

Until there is a demonstreable need for it (real hardware configuration
requiring such changes to work) there is no need to do it IMHO.

Instead I would like to come back to the wrong driver being selected
issue and fix it (cause this is a real problem with the pata_amd driver
taking control over CS5536 PATA controller and pata_cs5536 never being
used).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

