Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043Ab3DYSPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 14:15:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757962Ab3DYSPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 14:15:15 -0400
Date: Thu, 25 Apr 2013 13:14:59 -0500
From: Clark Williams <williams@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Suspend on 3.8.x-rtY (was: Re: [ANNOUNCE] 3.8.4-rt2)
Message-ID: <20130425131459.59fc5249@riff.lan>
In-Reply-To: <51794718.5040703@linutronix.de>
References: <20130326201722.GA14220@linutronix.de>
	<CAP=VYLoXfECaSBuvYdZ3qbsnR9QMYpoRnKGZdY=P6zS_TYOcCA@mail.gmail.com>
	<20130408183012.GA5778@linutronix.de>
	<20130408152558.627dc8b1@riff.lan>
	<51794718.5040703@linutronix.de>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GwRHOUjwj9DOiAryQcnwEG3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/GwRHOUjwj9DOiAryQcnwEG3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Apr 2013 17:09:12 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> On 04/08/2013 10:25 PM, Clark Williams wrote:
> > BTW I imported -rt onto v3.8.6 with no hiccups from 'git
> > quiltimport' other than what you just fixed. Not much runtime on it
> > but it booted without complaint and ran just fine until I tried a
> > suspend/resume.
> >=20
> > Resume seems to be borken on all the 3.8-rt kernels so far.
>=20
> I just tested in qemu:
> - suspend to mem
>   the kvm support gives a few warn ons due to sleeping spinlocks in
>   apf_task_wake_all(). Without it, it works just fine.
>=20
> - suspend to disk
>   I see very often "NOHZ: local_softirq_pending" warnings. It looks
>   like the softirq thread is going down and the timer softirq isn't
>   handled for instance. Apart from this warning I see the going into
>   suspend and waking up.

I setup a lab system with serial console to test suspend/resume. Worked
fine with the 3.8.8 F18 kernel (run pm-suspend; walk to the lab, hit
the power button, voila, resumed). Tried it with 3.8.8+rt2 and it hung.
I turned on no_console_suspend and tried again.=20

When I ran pm-suspend, it suspended very quickly but coming back
in resume I got a bunch of serial console bit-rate noise and then
nothing. I could see when hitting the power switch that it was
resuming devices (hitting the CD drive, flashing various LEDs, etc.) so
I figured something else was going on. I got distracted by something
else and when I came back, the console showed resume prints and it had
succesfully resumed. I tried it again, this time with a stopwatch and
it took 9:39 to finish resuming (from the time the power button was
pressed). So something is hung and is timing out after almost 10

Here's the serial console output:

-----------------------------------------------------------------------

Fedora release 18 (Spherical Cow)
Kernel 3.8.8-rt2+ on an x86_64 (ttyS0)

rhelrt-7 login: [  510.876471] pcieport 0000:00:1c.0: System wakeup enabled=
 by ACPI
Apr 25 15:41:47 rhelrt-7 kernel: [  510.876471] pcieport 0000:00:1c.0: Syst=
em wakeup enabled by ACPI
[  511.097283] PM: Syncing filesystems ... done.
[  511.138303] PM: Preparing system for mem sleep
Apr 25 15:41:47 [  511.143388] Freezing user space processes ... rhelrt-7 k=
ernel: [  511.097283] PM: Syncing filesystems ... done.
Apr 25 15:41:47 rhelrt-7 kernel: [  511.138303] PM: Preparing system for me=
m (elapsed 0.01 seconds) sleep
done.
[  511.164153] Freezing remaining freezable tasks ... (elapsed 0.01 seconds=
) done.
[  511.181696] PM: Entering mem sleep
[  511.220935] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  51=EF=BF=BD=EF=BF=BD=EF=BF=BD=1C=EF=BF=BD=1C=EF=BF=BD=EF=BF=BD=1C~~=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=1C=1C=EF=BF=BD=EF=BF=BD=EF=BF=BD=1C=EF=BF=BD=1C=1C=EF=BF=BD=EF=
=BF=BD=1C=1C=1C~?=EF=BF=BD=EF=BF=BD=EF=BF=BD=1C=EF=BF=BD=EF=BF=BD=1C=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=1C=EF=BF=BD=EF=BF=BD=1C=1C=1E=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=1C=1C=1C=1Ep?=EF=BF=BD=EF=BF=BD=EF=BF=BD=1C=EF=BF=BD|?=EF=BF=BD=1C=EF=
=BF=BD=1C=EF=BF=BD=EF=BF=BD=1C=EF=BF=BD~=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=1C=1C=1C=20
=EF=BF=BD=EF=BF=BD=1C=EF=BF=BD~=EF=BF=BD=EF=BF=BD=EF=BF=BD=1C=1E~=EF=BF=BD=
=EF=BF=BD=1C=EF=BF=BD=1C=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=1C=1E~=EF=BF=
=BD=1C=EF=BF=BD=1C~~?

<snip 25 lines of noise>=20

 =EF=BF=BD=D1=A5=D9=85=D1=95=EF=BF=BD5)=EF=BF=BD=02=EF=BF=BD=EF=BF=BD=EF=BF=
=BDr=EF=BF=BD=EF=BF=BD=EF=BF=BD=C2=92=EF=BF=BD=EF=BF=BD=EF=BF=BD=CD=95=C9=
=A5=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=D2=82=EF=BF=BD=EF=BF=BD=02
                               =EF=BF=BD=D1=A5=D9=85=D1=95=EF=BF=BD5r=EF=BF=
=BD=02=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BD=EF=BF=BD=CA=9A=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=DF=95=C9=A5=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=D2=82=EF=BF=BD=EF=BF=BD=02
                                                              =EF=BF=BD=D1=
=A5=D9=85=D1=95=EF=BF=BD5{=EF=BF=BD	=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BD=
=D9=95=EF=BF=BD=D5=81=EF=BF=BD=DA=81=EF=BF=BD=02=02=02"I5u=EF=BF=BD=DB=95=
=EF=BF=BD=D5=B5=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=E5=B9=B9rjR=EF=BF=BD[  512.759510] nouveau  =
[     DRM] 0xA76C: Parsing digital output script table
[  512.814213] ata7.00: configured for UDMA/33
[  512.817562] nouveau  [     DRM] 0xA7BC: Parsing digital output script ta=
ble
[  512.926054] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  512.933360] ata4: SATA link down (SStatus 0 SControl 300)
[  512.939874] ata3: SATA link down (SStatus 0 SControl 300)
[  512.946385] ata5: SATA link down (SStatus 4 SControl 300)
[  512.952860] ata2: SATA link down (SStatus 0 SControl 300)
[  513.074111] ata1.00: configured for UDMA/133
[  513.079567] sd 0:0:0:0: [sda] Starting disk
[  513.174089] firewire_core 0000:05:05.0: rediscovered device fw0
[  516.160045]=20
[  516.162631] floppy driver state
[  516.166843] -------------------
[  516.171065] now=3D4295183467 last interrupt=3D4294679658 diff=3D503809 l=
ast called handler=3Dreset_interrupt [floppy]
[  516.182114] timeout_message=3Dlock fdc
[  516.186796] last output bytes:
[  516.190946]  0  0 0
[  516.194113]  0  0 0
[  516.197281]  8 80 4294679641
[  516.201244]  8 80 4294679653
[  516.205211]  8 80 4294679653
[  516.209155]  8 80 4294679653
[  516.213071]  8 80 4294679653
[  516.216960]  e 80 4294679653
[  516.220839] 13 80 4294679653
[  516.224706]  0 90 4294679653
[  516.228571] 1a 90 4294679654
[  516.232431]  0 90 4294679654
[  516.236296] 12 80 4294679654
[  516.240159]  0 90 4294679654
[  516.244036] 14 90 4294679654
[  516.247894] 18 80 4294679654
[  516.251744]  8 80 4294679658
[  516.255581]  8 80 4294679658
[  516.259407]  8 80 4294679658
[  516.263211]  8 80 4294679659
[  516.266977] last result at 4294679659
[  516.271518] last redo_fd_request at 4294679659
[  516.276842] status=3D0
[  516.279886] fdc_busy=3D1
[  516.283094] do_floppy=3Dreset_interrupt [floppy]
[  516.288373] cont=3Dffffffffa01d6e00
[  516.292514] current_req=3D          (null)
[  516.297280] command_status=3D-1
[  516.301105]=20
[  516.303454] floppy0: floppy timeout called
[  516.308461] PM: resume of devices complete after 3687.632 msecs
[  516.315506] PM: resume devices took 3.695 seconds
[  516.321048] PM: Finishing wakeup.
[  516.325174] Restarting tasks ... done.
Apr 25 15:43:01 rhelrt-7 kernel: [  511.143388] Freezing user space process=
es ... (elapsed 0.01 seconds) done.
Apr 25 15:43:01 rhelrt-7 kernel: [  511.164153] Freezing remaining freezabl=
e tasks ... (elapsed 0.01 seconds) done.
Apr 25 15:43:01 rhelrt-7 kernel: [  511.181696] PM: Entering mem sleep
Apr 25 15:43:01 rhelrt-7 kernel: [  511.220935] sd 0:0:0:0: [sda] Synchroni=
zing SCSI cache
Apr 25 15:43:01 rhelrt-7 kernel: [  511.221990] serial 00:08: disabled
Apr 25 15:43:01 rhelrt-7 kernel: [  511.226701] serial 00:07: disabled
Apr 25 15:43:01 rhelrt-7 kernel: [  511.227057] sd 0:0:0:0: [sda] Stopping =
disk
Apr 25 15:43:01 rhelrt-7 kernel: [  511.227368] parport_pc 00:06: disabled
Apr 25 15:43:01 rhelrt-7 kernel: [  511.227586] nouveau  [     DRM] suspend=
ing fbcon...
Apr 25 15:43:01 rhelrt-7 kernel: [  511.227799] nouveau  [     DRM] suspend=
ing display...
Apr 25 15:43:01 rhelrt-7 kernel: [  51[  516.408748] tg3 0000:0b:00.0: irq =
66 for MSI/MSI-X
1.228006] nouveau  [     DRM] unpinning framebuffer(s)...
Apr 25 15:43:01 rhelrt-7 kernel: [  511.228280] nouveau  [     DRM] evictin=
g buffers...
Apr 25 15:43:01 rhelrt-7 kernel: [  511.231897] nouveau  [     DRM] suspend=
ing client object trees...
Apr 25 15:43:01 rhelrt-7 kernel: [  511.541135] PM: suspend of devices comp=
lete after 355.641 msecs
Apr 25 15:43:01 rhelrt-7 kernel: [  511.541372] PM: suspend devices took 0.=
356 seconds
Apr 25 15:43:01 rhelrt-7 kernel: [  511.541845] PM: late suspend of devi[  =
516.457258] IPv6: ADDRCONF(NETDEV_UP): em1: link is not ready
ces complete after 0.292 msecs
Apr 25 15:43:01 rhelrt-7 kernel: [  511.542387]  pci0000:00: System wakeup =
enabled by ACPI
Apr 25 15:43:01 rhelrt-7 kernel: [  511.663104] uhci_hcd 0000:00:1d.3: Syst=
em wakeup enabled by ACPI
Apr 25 15:43:01 rhelrt-7 kernel: [  511.663366] uhci_hcd 0000:00:1d.2: Syst=
em wakeup enabled by ACPI
Apr 25 15:43:01 rhelrt-7 kernel: [  511.663614] uhci_hcd 0000:00:1d.1: Syst=
em wakeup enabled by ACPI
Apr 25 15:43:01 rhelrt-7 kernel: [  511.663860] uhci_hcd 0000:00:1d.0: Syst=
em wakeup enabled by ACPI
Apr 25 15:43:01 rhelrt-7 kernel: [  511.664236] PM: noirq suspend of device=
s complete after 122.136 msecs
Apr 25 15:43:01 rhelrt-7 kernel: [  511.664954] ACPI: Preparing to enter sy=
stem sleep state S3
Apr 25 15:43:01 rhelrt-7 kernel: [  511.666018] PM: Saving platform NVS mem=
ory
Apr 25 15:43:01 rhelrt-7 kernel: [  511.666220] Disabling non-boot CPUs ...
Apr 25 15:43:01 rhelrt-7 kernel: [  511.669163] smpboot: CPU 1 is now offli=
ne
Apr 25 15:43:01 rhelrt-7 kernel: [  511.671566] smpboot: CPU 2 is now offli=
ne
Apr 25 15:43:01 rhelrt-7 kernel: [  511.673056] NOHZ: local_softirq_pending=
 02
Apr 25 15:43:01 rhelrt-7 kernel: [  511.673096] NOHZ: local_softirq_pending=
 02
Apr 25 15:43:01 rhelrt-7 kernel: [  511.673114] NOHZ: local_softirq_pending=
 02
Apr 25 15:43:01 rhelrt-7 kernel: [  511.673134] NOHZ: local_softirq_pending=
 02
Apr 25 15:43:01 rhelrt-7 kernel: [  511.674370] smpboot: CPU 3 is now offli=
ne
Apr 25 15:43:01 rhelrt-7 kernel: [  511.675663] ACPI: Low-level resume comp=
lete
Apr 25 15:43:01 rhelrt-7 kernel: [  511.675663] PM: Restoring platform NVS =
memory
Apr 25 15:43:01 rhelrt-7 kernel: [  511.675663] Enabling non-boot CPUs ...
Apr 25 15:43:01 rhelrt-7 kernel: [  511.677781] smpboot: Booting Node 0 Pro=
cessor 1 APIC 0x6
Apr 25 15:43:01 rhelrt-7 kernel: [  511.720442] CPU1 is up
Apr 25 15:43:01 rhelrt-7 kernel: [  511.725453] smpboot: Booting Node 0 Pro=
cessor 2 APIC 0x1
Apr 25 15:43:01 rhelrt-7 kernel: [  511.750189] CPU2 is up
Apr 25 15:43:01 rhelrt-7 kernel: [  511.755250] smpboot: Booting Node 0 Pro=
cessor 3 APIC 0x7
Apr 25 15:43:01 rhelrt-7 kernel: [  511.779877] CPU3 is up
Apr 25 15:43:01 rhelrt-7 kernel: [  511.789495] ACPI: Waking up from system=
 sleep state S3
Apr 25 15:43:01 rhelrt-7 kernel: [  511.927190] uhci_hcd 0000:00:1d.0: Syst=
em wakeup disabled by ACPI
Apr 25 15:43:01 rhelrt-7 kernel: [  511.939975] uhci_hcd 0000:00:1d.1: Syst=
em wakeup disabled by ACPI
Apr 25 15:43:01 rhelrt-7 kernel: [  511.952760] uhci_hcd 0000:00:1d.2: Syst=
em wakeup disabled by ACPI
Apr 25 15:43:01 rhelrt-7 kernel: [  511.965545] uhci_hcd 0000:00:1d.3: Syst=
em wakeup disabled by ACPI
Apr 25 15:43:01 rhelrt-7 kernel: [  512.099089]  pci0000:00: System wakeup =
disabled by ACPI
Apr 25 15:43:01 rhelrt-7 kernel: [  512.594325] PM: noirq resume of devices=
 complete after 788.571 msecs
Apr 25 15:43:01 rhelrt-7 kernel: [  512.607886] PM: early resume of devices=
 complete after 0.205 msecs
Apr 25 15:43:01 rhelrt-7 kernel: [  512.620988] snd_hda_intel 0000:00:1b.0:=
 irq 65 for MSI/MSI-X
Apr 25 15:43:01 rhelrt-7 kernel: [  512.621094] uhci_hcd 0000:00:1d.3: sett=
ing latency timer to 64
Apr 25 15:43:01 rhelrt-7 kernel: [  512.621125] ehci-pci 0000:00:1d.7: sett=
ing latency timer to 64
Apr 25 15:43:01 rhelrt-7 kernel: [  512.621128] pci 0000:00:1e.0: setting l=
atency timer to 64
Apr 25 15:43:01 rhelrt-7 kernel: [  512.621132] usb usb5: root hub lost pow=
er or was reset
Apr 25 15:43:01 rhelrt-7 kernel: [  512.621142] lpc_ich 0000:00:1f.0: rerou=
ting interrupts for [8086:2670]
Apr 25 15:43:01 rhelrt-7 kernel: [  512.621166] ata_piix 0000:00:1f.1: sett=
ing latency timer to 64
Apr 25 15:43:01 rhelrt-7 kernel: [  512.621175] ahci 0000:00:1f.2: setting =
latency timer to 64
Apr 25 15:43:01 rhelrt-7 kernel: [  512.621221] uhci_hcd 0000:00:1d.0: sett=
ing latency timer to 64
Apr 25 15:43:01 rhelrt-7 kernel: [  512.621239] nouveau  [     DRM] re-enab=
ling device...
Apr 25 15:43:01 rhelrt-7 kernel: [  512.621253] usb usb2: root hub lost pow=
er or was reset
Apr 25 15:43:01 rhelrt-7 kernel: [  512.621256] nouveau  [     DRM] resumin=
g client object trees...
Apr 25 15:43:01 rhelrt-7 kernel: [  512.621260] pcieport 0000:00:1c.0: Syst=
em wakeup disabled by ACPI
Apr 25 15:43:01 rhelrt-7 kernel: [  512.621271] nouveau  [   VBIOS][0000:07=
:00.0] running init tables
Apr 25 15:43:01 rhelrt-7 kernel: [  512.621793] ata8: port disabled--ignori=
ng
Apr 25 15:43:01 rhelrt-7 kernel: [  512.622044] uhci_hcd 0000:00:1d.1: sett=
ing latency timer to 64
Apr 25 15:43:01 rhelrt-7 kernel: [  512.622059] uhci_hcd 0000:00:1d.2: sett=
ing latency timer to 64
Apr 25 15:43:01 rhelrt-7 kernel: [  512.622097] usb usb3: root hub lost pow=
er or was reset
Apr 25 15:43:01 rhelrt-7 kernel: [  512.622107] usb usb4: root hub lost pow=
er or was reset
Apr 25 15:43:01 rhelrt-7 kernel: [  512.630090] parport_pc 00:06: activated
Apr 25 15:43:01 rhelrt-7 kernel: [  512.634823] serial 00:07: activated
Apr 25 15:43:01 rhelrt-7 kernel: [  512.649938] serial 00:08: activated
Apr 25 15:43:01 rhelrt-7 kernel: [  512.654304] nouveau  [     DRM] resumin=
g display...
Apr 25 15:43:01 rhelrt-7 kernel: [  512.759510] nouveau  [     DRM] 0xA76C:=
 Parsing digital output script table
Apr 25 15:43:01 rhelrt-7 kernel: [  512.814213] ata7.00: configured for UDM=
A/33
Apr 25 15:43:01 rhelrt-7 kernel: [  512.817562] nouveau  [     DRM] 0xA7BC:=
 Parsing digital output script table
Apr 25 15:43:01 rhelrt-7 kernel: [  512.926054] ata1: SATA link up 3.0 Gbps=
 (SStatus 123 SControl 300)
Apr 25 15:43:01 rhelrt-7 kernel: [  512.933360] ata4: SATA link down (SStat=
us 0 SControl 300)
Apr 25 15:43:01 rhelrt-7 kernel: [  512.939874] ata3: SATA link down (SStat=
us 0 SControl 300)
Apr 25 15:43:01 rhelrt-7 kernel: [  512.946385] ata5: SATA link down (SStat=
us 4 SControl 300)
Apr 25 15:43:01 rhelrt-7 kernel: [  512.952860] ata2: SATA link down (SStat=
us 0 SControl 300)
Apr 25 15:43:01 rhelrt-7 kernel: [  513.074111] ata1.00: configured for UDM=
A/133
Apr 25 15:43:01 rhelrt-7 kernel: [  513.079567] sd 0:0:0:0: [sda] Starting =
disk
Apr 25 15:43:01 rhelrt-7 kernel: [  513.174089] firewire_core 0000:05:05.0:=
 rediscovered device fw0
Apr 25 15:43:01 rhelrt-7 kernel: [  516.160045]=20
Apr 25 15:43:01 rhelrt-7 kernel: [  516.162631] floppy driver state
Apr 25 15:43:01 rhelrt-7 kernel: [  516.166843] -------------------
Apr 25 15:43:01 rhelrt-7 kernel: [  516.171065] now=3D4295183467 last inter=
rupt=3D4294679658 diff=3D503809 last called handler=3Dreset_interrupt [flop=
py]
Apr 25 15:43:01 rhelrt-7 kernel: [  516.182114] timeout_message=3Dlock fdc
Apr 25 15:43:01 rhelrt-7 kernel: [  516.186796] last output bytes:
Apr 25 15:43:01 rhelrt-7 kernel: [  516.190946]  0  0 0
Apr 25 15:43:01 rhelrt-7 kernel: [  516.194113]  0  0 0
Apr 25 15:43:01 rhelrt-7 kernel: [  516.197281]  8 80 4294679641
Apr 25 15:43:01 rhelrt-7 kernel: [  516.201244]  8 80 4294679653
Apr 25 15:43:01 rhelrt-7 kernel: [  516.205211]  8 80 4294679653
Apr 25 15:43:01 rhelrt-7 kernel: [  516.209155]  8 80 4294679653
Apr 25 15:43:01 rhelrt-7 kernel: [  516.213071]  8 80 4294679653
Apr 25 15:43:01 rhelrt-7 kernel: [  516.216960]  e 80 4294679653
Apr 25 15:43:01 rhelrt-7 kernel: [  516.220839] 13 80 4294679653
Apr 25 15:43:01 rhelrt-7 kernel: [  516.224706]  0 90 4294679653
Apr 25 15:43:01 rhelrt-7 kernel: [  516.228571] 1a 90 4294679654
Apr 25 15:43:01 rhelrt-7 kernel: [  516.232431]  0 90 4294679654
Apr 25 15:43:01 rhelrt-7 kernel: [  516.236296] 12 80 4294679654
Apr 25 15:43:01 rhelrt-7 kernel: [  516.240159]  0 90 4294679654
Apr 25 15:43:01 rhelrt-7 kernel: [  516.244036] 14 90 4294679654
Apr 25 15:43:01 rhelrt-7 kernel: [  516.247894] 18 80 4294679654
Apr 25 15:43:01 rhelrt-7 kernel: [  516.251744]  8 80 4294679658
Apr 25 15:43:01 rhelrt-7 kernel: [  516.255581]  8 80 4294679658
Apr 25 15:43:01 rhelrt-7 kernel: [  516.259407]  8 80 4294679658
Apr 25 15:43:01 rhelrt-7 kernel: [  516.263211]  8 80 4294679659
Apr 25 15:43:01 rhelrt-7 kernel: [  516.266977] last result at 4294679659
Apr 25 15:43:01 rhelrt-7 kernel: [  516.271518] last redo_fd_request at 429=
4679659
Apr 25 15:43:01 rhelrt-7 kernel: [  516.276842] status=3D0
Apr 25 15:43:01 rhelrt-7 kernel: [  516.279886] fdc_busy=3D1
Apr 25 15:43:01 rhelrt-7 kernel: [  516.283094] do_floppy=3Dreset_interrupt=
 [floppy]
Apr 25 15:43:01 rhelrt-7 kernel: [  516.288373] cont=3Dffffffffa01d6e00
Apr 25 15:43:01 rhelrt-7 kernel: [  516.292514] current_req=3D          (nu=
ll)
Apr 25 15:43:01 rhelrt-7 kernel: [  516.297280] command_status=3D-1
Apr 25 15:43:01 rhelrt-7 kernel: [  516.301105]=20
Apr 25 15:43:01 rhelrt-7 kernel: [  516.303454] floppy0: floppy timeout cal=
led
Apr 25 15:43:01 rhelrt-7 kernel: [  516.308461] PM: resume of devices compl=
ete after 3687.632 msecs
Apr 25 15:43:01 rhelrt-7 kernel: [  516.315506] PM: resume devices took 3.6=
95 seconds
Apr 25 15:43:01 rhelrt-7 kernel: [  516.321048] PM: Finishing wakeup.
Apr 25 15:43:01 rhelrt-7 kernel: [  516.325174] Restarting tasks ... done.
Apr 25 15:43:01 rhelrt-7 kernel: [  516.408748] tg3 0000:0b:00.0: irq 66 fo=
r MSI/MSI-X
Apr 25 15:43:01 rhelrt-7 kernel: [  516.457258] IPv6: ADDRCONF(NETDEV_UP): =
em1: link is not ready
[  519.568257] tg3 0000:0b:00.0 em1: Link is up at 1000 Mbps, full duplex
[  519.574819] tg3 0000:0b:00.0 em1: Flow control is off for TX and off for=
 RX
[  519.581843] IPv6: ADDRCONF(NETDEV_CHANGE): em1: link becomes ready
Apr 25 15:43:04 rhelrt-7 kernel: [  519.568257] tg3 0000:0b:00.0 em1: Link =
is up at 1000 Mbps, full duplex
Apr 25 15:43:04 rhelrt-7 kernel: [  519.574819] tg3 0000:0b:00.0 em1: Flow =
control is off for TX and off for RX
Apr 25 15:43:04 rhelrt-7 kernel: [  519.581843] IPv6: ADDRCONF(NETDEV_CHANG=
E): em1: link becomes ready



-----------------------------------------------------------------------

I notice that nouveau is in there and yes, my laptop uses nouveau as
well. First thing I'll try is some of the pm-suspend quirks regarding graph=
ics devices.

If that doesn't change anything I'll try swapping  out the graphics card in=
 that test box and see
if that makes a difference.=20

Clark

--Sig_/GwRHOUjwj9DOiAryQcnwEG3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlF5cqcACgkQHyuj/+TTEp3IXgCeJLbBzTsXyUD1Yp0m29H0Q1Q7
jD8AoICQhFQ+dSFo6K8p1fmFgx2UZF8l
=L3+g
-----END PGP SIGNATURE-----

--Sig_/GwRHOUjwj9DOiAryQcnwEG3--
