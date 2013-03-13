Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab3CMCb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 22:31:29 -0400
Received: from che.mayfirst.org ([209.234.253.108]:37907 "EHLO
	che.mayfirst.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550Ab3CMCb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 22:31:27 -0400
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Mar 2013 22:31:27 EDT
From: Daniel Kahn Gillmor <dkg@fifthhorseman.net>
To: Corey Minyard <minyard@mvista.com>, Corey Minyard <minyard@acm.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Linux IPMI subsystem hang
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Tue, 12 Mar 2013 22:23:37 -0400
Message-ID: <87ip4w2g2e.fsf@alice.fifthhorseman.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Linux kernel folks (Corey is explicitly listed here because of being
the only contact i could find in IPMI.txt)--

I am working with a Lenovo ThinkCentre M78, model 4865-A14, and it seems
to have trouble with the IPMI subsystem.

udev seems to hang for about 3 minutes at startup, ultimately failing
with the following messages:

udevd[416]: worker [495] unexpectedly returned with status 0x0100
udevd[416]: worker [495] failed while handling '/devices/pci0000:00/0000:00:15.2/0000:03:00.3'

This hang happens whether i'm running linux kernel 3.2 or 3.8, using
either x86 or x86_64 kernels.

If i blacklist the following modules via /etc/modprobe.d/blacklist.conf,
then there is no hang on startup:

 blacklist ipmi_si
 blacklist ipmi_msghandler

The device in question appears this way to lspci:

03:00.3 IPMI SMIC interface [0c07]: Realtek Semiconductor Co., Ltd. Device [10ec:816c] (rev 01) (prog-if 01)
	Subsystem: Lenovo Device [17aa:3089]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin D routed to IRQ 17
	Region 0: I/O ports at e000 [size=256]
	Region 2: Memory at fea10000 (64-bit, non-prefetchable) [size=256]
	Region 4: Memory at fea00000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: ipmi_si

This machine is a workstation, and i would be surprised if it actually
has a full-blown IPMI subsystem.  I can find no mention of IPMI in the
BIOS, or in lenovo's hardware maintenance manual [0] or user guide [1]
for this model.

So i suspect that this device is being mistaken for an IPMI device, or
that it is actually a broken/malformed IPMI device that shouldn't be
initialized.  Either that, or the IPMI module itself is doing something
wrong.

Can i do anything to help resolve this problem so that the machine boots
without delay and the ipmi subsystem doesn't get hung on this device?
Is there debugging output i can provide that would be useful, or any
other test you'd like me to run?

I'd be happy to report any requested details.  Also, if you want to
redirect me to a better forum for resolving this problem that would be
appreciated.

I am not subscribed to LKML, so please CC me on any replies.

Regards,

        --dkg

[0] http://download.lenovo.com/ibmdl/pub/pc/pccbbs/thinkcentre_pdf/m78_hmm.pdf
[1] http://download.lenovo.com/ibmdl/pub/pc/pccbbs/thinkcentre_pdf/m78_sff_ug_en.pdf

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQJ8BAEBCgBmBQJRP+MpXxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25zLm9w
ZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXRFQjk2OTEyODdBN0FEREUzNzU3RDkxMUVB
NTI0MDFCMTFCRkRGQTVDAAoJEKUkAbEb/fpc8bAQAJ9inAmmuUHZ/cQxAidkRZZM
NFTI9RKd6mYS1eaku+22qtiO0alKJ6NQuLomqpsC8sFBRw+I6eWa5lsRJi1gpKHK
uqEepJAfZfJURuFtGl073aQmnVZqia7jAmzcRHhQH5DJxLcbqpVtrs7UlqM2fmQS
7DNZXICL1oiclAosASaaWoI88eCfTb1yxzwjdmVmz7YP5N4r8x/qry/5exkd25qE
t2p7DJSwFN4UFEGSn9Dtsa8zzemX8Ym4MLqOShCORqZ7I5CAstydcNSKbimtBQBt
/FmGSg2kvHbihT7NRBPuj1b9stqIabrCPpE89sjImcYBhWVnEMgT6k3mqJpaHzRO
seHsLn8kTSUq30ZYlCCDqWu+9dZDrXg8Y1R1GbsaMm8mnkxwzeVLkASDlX48tB0r
I1+wp5vey8JysDImaM0tdziw9PZyDClvD8Lr2Al9DCKFsuo7JI0+5Qzj3Ckvh14g
zUfYAH56EcMJBqPNeySmFKVFGlnI/7bjIQfzo0JUdkBkI9q0H6I0Hvr18Xtpj0hV
8Na8TK2rtgBhOGyrZdCwhpCKajK46qXUADw6Ssme0xcmlRE8YzbUE//psD2lWBB4
0N8qLRLXSO0pIvmyUi2VuwlOt2QgwQKc8TIj/1EvH/1Z+ClYQGUPaWFZUrupk9lz
iE/eXYt1jhhuRgNnSCAx
=iHax
-----END PGP SIGNATURE-----
--=-=-=--
