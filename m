Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaBOMRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 07:17:49 -0500
Received: from nm48-vm4.bullet.mail.bf1.yahoo.com ([216.109.115.159]:27873
	"EHLO nm48-vm4.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752783AbaBOMRr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 07:17:47 -0500
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Feb 2014 07:17:47 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 742158.62765.bm@omp1032.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=VU1y0/y4pF2P85Ui9AFlS+UV3j/XGkMT+z+vvVejtzLxGQ+HhCR9U1xzBE1pwVrKv8kLOA3wop9wEt+mg1+c6XgBd2qrf8igeDx+S0oEOh/D2uao5ec2HX3wMykNRGrD4UHCtw6/Hxq5xygRnwJrJm7HkNK1PeSI0Vp5dZY5WCI=;
X-YMail-OSG: nLOpp6oVM1mwyMRAbz5gZOZ700SuZERhp.2W8ufHQxNKQm1
 Dxkk629ouGDLL6.cL65o0sICi2b1O8.qeBdW3snkZIaEloU5xOAAGmnSzjA3
 WFIgDEmCWezYQNjroGbR9VVJTGgkAVO_9w.gdQkBZNljroiVHXcdXZ3g0ovX
 mt9lij.ojO5iI.lku9GbYHqSMgxlmck2aZRS2FFtk.SPSjSCL.1cpbE3KKNB
 ZBdrPW57qyN87MJImFtF4ZkkRasz.1BAl014uxaoMP3Y7Bk_qVTJVRBUG1gS
 0kf4fZ7.k_C.PSPlbUCcp52DR1TXk3dpLXX2ixwfztFM4IFecW8oq2Om6777
 PsUTPsdAVDmo8XrmcEEwVX6nDz9dMU4329AkufFhZAGVpi612ws58SmsmgNf
 jRGuopcsFMe.pa3NOcRoMdlSRG57J6gQ7meI5yE32sYOxiiEr71Uk_bCNPXy
 5YMCXmUFKgmaZrNnA54Wu5qfYTFAZp3EjhKTtrMI0yTKMVLqloZSoKG9.PcS
 p3Szpz2UUisvXCd7ZdpzjzLY62i5kn8nfdFzTJlyuVEO9b.X2uGRmNUEhq67
 7U7YjF45erXWR90sHVqI-
X-Rocket-MIMEInfo: 002.001,V2hlbiBib290aW5nIGludG8gbGludXggdjMuMTMuMywgSSBhbSB1bmFibGUgdG8gbW91bnQgYW4gbmZzIHNoYXJlIG9uIHRoaXMgcGFydGljdWxhciBoYXJkd2FyZS4gwqBJIGdldCB0aGUgc2FtZSBwcm9ibGVtIHVzaW5nIHYzLjEyLjExLiDCoE9ubHkgdGhlIDMuMTAueCBzZXJpZXMgYWxsb3dzIG5vcm1hbCBvcGVyYXRpb24uIMKgUGFydGlhbCBkbWVzZyBvdXRwdXQgc2hvd24gaW5saW5lLCBhZGRpdGlvbmFsIGxvZ3MgYXZhaWxhYmxlIHVwb24gcmVxdWVzdC4KClBMRUFTRSBjYyBtZSBvbiBteSByZXBsaWUBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
Message-ID: <1392466251.41282.YahooMailNeo@web140003.mail.bf1.yahoo.com>
Date: Sat, 15 Feb 2014 04:10:51 -0800 (PST)
From: John <da_audiophile@yahoo.com>
Reply-To: John <da_audiophile@yahoo.com>
Subject: [BUG] unable to handle kernel NULL pointer dereference
To: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting into linux v3.13.3, I am unable to mount an nfs share on this particular hardware.  I get the same problem using v3.12.11.  Only the 3.10.x series allows normal operation.  Partial dmesg output shown inline, additional logs available upon request.

PLEASE cc me on my replies as I am not subscribed to lkml.

Hardware: Athlon XP 3200+ on an NVIDIA nForce2 Ultra 400 motherboard.
Distro: Arch Linux i686.

% dmesg
...
[ 137.616014] NFS: Registering the id_resolver key type
[ 137.616036] Key type id_resolver registered
[ 137.616038] Key type id_legacy registered
[ 137.686758] BUG: unable to handle kernel NULL pointer dereference at 00000858
[ 137.689996] IP: [<f8aa2d99>] put_pipe_version+0x19/0x60 [auth_rpcgss]
[ 137.689996] *pde = 00000000 
[ 137.689996] Oops: 0000 [#1] PREEMPT SMP 
[ 137.689996] Modules linked in: rpcsec_gss_krb5 auth_rpcgss oid_registry nfsv4 asb100 hwmon_vid snd_wavefront ir_mce_kbd_decoder ir_lirc_codec ir_rc5_sz_decoder ir_sony_decoder lirc_dev ir_rc5_decoder ir_jvc_decoder ir_sanyo_decoder ir_rc6_decoder ir_nec_decoder rc_streamzap streamzap mousedev snd_cs4236 rc_core snd_intel8x0 snd_wss_lib snd_opl3_lib snd_hwdep snd_ac97_codec evdev snd_mpu401 ac97_bus snd_mpu401_uart snd_pcm snd_rawmidi snd_page_alloc snd_seq_device snd_timer snd pcspkr skge shpchp i2c_nforce2 i2c_core soundcore ns558 gameport processor button nvidia_agp agpgart nfs lockd sunrpc fscache ext4 crc16 mbcache jbd2 hid_generic usbhid hid sr_mod cdrom sd_mod ata_generic pata_acpi sata_sil pata_amd libata ehci_pci ohci_pci ohci_hcd ehci_hcd scsi_mod usbcore usb_common
[ 137.689996] CPU: 0 PID: 534 Comm: rpc.gssd Not tainted 3.13.3-1-ARCH #1
[ 137.689996] Hardware name: ASUSTeK Computer INC. A7N8X-E/A7N8X-E, BIOS ASUS A7N8X-E Deluxe ACPI BIOS Rev 1013 11/12/2004
[ 137.689996] task: f4633210 ti: f568e000 task.ti: f568e000
[ 137.689996] EIP: 0060:[<f8aa2d99>] EFLAGS: 00010202 CPU: 0
[ 137.689996] EIP is at put_pipe_version+0x19/0x60 [auth_rpcgss]
[ 137.689996] EAX: f4633210 EBX: 00000001 ECX: f56efca8 EDX: 00000296
[ 137.689996] ESI: 00000000 EDI: f56efc00 EBP: f568fee8 ESP: f568fee0
[ 137.689996] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 137.689996] CR0: 8005003b CR2: 00000858 CR3: 34523000 CR4: 000007d0
[ 137.689996] Stack:
[ 137.689996] f56efc00 f6c64f78 f568fef4 f8aa2e05 00000010 f568ff40 f8aa3b38 00000374
[ 137.689996] 00000080 b74dde40 f4644a80 f568ff30 00000246 f8ac1080 ffff41c9 f6c64f78
[ 137.689996] fffffff3 00000010 f4460140 f44d5820 f44d5810 f53df7ec f57595a0 f8aa93e8
[ 137.689996] Call Trace:
[ 137.689996] [<f8aa2e05>] gss_release_msg+0x25/0x70 [auth_rpcgss]
[ 137.689996] [<f8aa3b38>] gss_pipe_downcall+0x208/0x4b0 [auth_rpcgss]
[ 137.689996] [<f8a2f9ab>] rpc_pipe_write+0x3b/0x60 [sunrpc]
[ 137.689996] [<f8a2f970>] ? rpc_pipe_poll+0x90/0x90 [sunrpc]
[ 137.689996] [<c1156bd5>] vfs_write+0x95/0x1c0
[ 137.689996] [<c11572a1>] SyS_write+0x51/0x90
[ 137.689996] [<c145cc0d>] sysenter_do_call+0x12/0x28
[ 137.689996] Code: f8 e8 4f b8 9a c8 31 c0 eb c6 90 8d b4 26 00 00 00 00 55 89 e5 56 53 3e 8d 74 26 00 8b 1d 28 e9 a3 f8 89 c6 e8 59 64 5f c8 85 db <8b> 86 58 08 00 00 74 3a 3b 18 77 36 8b 5c 98 08 e8 32 66 5f c8
[ 137.689996] EIP: [<f8aa2d99>] put_pipe_version+0x19/0x60 [auth_rpcgss] SS:ESP 0068:f568fee0
[ 137.689996] CR2: 0000000000000858
[ 138.578433] ---[ end trace 3dcb8d5c35b64fbd ]---
[ 142.979263] type=1006 audit(1392415950.632:4): pid=540 uid=0 old auid=4294967295 new auid=1000 old ses=4294967295 new ses=3 res=1
