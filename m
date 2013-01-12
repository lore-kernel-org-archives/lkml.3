Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab3ALWAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 17:00:22 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:52289 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab3ALWAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 17:00:20 -0500
Date: Sat, 12 Jan 2013 22:00:15 +0000
From: James Hogan <james@albanarts.com>
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [BUG] NULL pointer dereference in udf_sb_free_partitions
Message-ID: <20130112220015.GA2387@balrog>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I've encountered a reproducable kernel bug which makes the screen switch
to a console and display the kernel log below. This is what I did:

* Insert a particular DVD-R I have which appears to be corrupt. It then
  makes the DVD drive make some unpleasant noises (my TV also makes
  unpleasant noises when it's inserted).

* I go to mount it in KDE, it continues making noises and outputs some
  of the errors in the kernel log below (things like Mechanical
  positioning error, which makes sense since it's making unusual
  noises)..

* After a while it says the mount failed.

* After a while I typed the eject command, and pressed eject button

* After a while longer the DVD is eventually ejected and at that point
  the kernel log is displayed on screen.

* I can use VT switch to get back to desktop. i tried running sync as I
  wanted the log to be saved, but it never returned, although most other
  things seemed to continue working. Rebooted fine.

First observed on v3.7 vanilla kernel (tried twice, happened both
times), now running v3.8-rc3 and it happened when I tried it again.

I haven't tried debugging it any further, but am happy to provide more
info as required or test patches.

Cheers
James


(told it to mount)

[ 1300.219641] sr 8:0:0:0: [sr0] Unhandled sense code
[ 1300.219652] sr 8:0:0:0: [sr0] =20
[ 1300.219658] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1300.219664] sr 8:0:0:0: [sr0] =20
[ 1300.219668] Sense Key : Hardware Error [current]=20
[ 1300.219675] Info fld=3D0x119368
[ 1300.219680] sr 8:0:0:0: [sr0] =20
[ 1300.219686] Add. Sense: Mechanical positioning error
[ 1300.219692] sr 8:0:0:0: [sr0] CDB:=20
[ 1300.219695] Read(10): 28 00 00 11 93 68 00 00 01 00
[ 1300.219711] end_request: I/O error, dev sr0, sector 4607392
[ 1300.219766] UDF-fs: error (device sr0): udf_read_tagged: read failed, bl=
ock=3D1151848, location=3D1151576
[ 1300.219780] UDF-fs: error (device sr0): __udf_read_inode: (ino 1151848) =
failed !bh
[ 1310.294257] sr 8:0:0:0: [sr0] Unhandled sense code
[ 1310.294268] sr 8:0:0:0: [sr0] =20
[ 1310.294274] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1310.294279] sr 8:0:0:0: [sr0] =20
[ 1310.294283] Sense Key : Hardware Error [current]=20
[ 1310.294289] Info fld=3D0x119367
[ 1310.294294] sr 8:0:0:0: [sr0] =20
[ 1310.294300] Add. Sense: Mechanical positioning error
[ 1310.294305] sr 8:0:0:0: [sr0] CDB:=20
[ 1310.294308] Read(10): 28 00 00 11 93 67 00 00 01 00
[ 1310.294324] end_request: I/O error, dev sr0, sector 4607388
[ 1310.294388] UDF-fs: error (device sr0): udf_read_tagged: read failed, bl=
ock=3D1151847, location=3D1151575
[ 1310.294400] UDF-fs: error (device sr0): __udf_read_inode: (ino 1151847) =
failed !bh
[ 1320.324070] sr 8:0:0:0: [sr0] Unhandled sense code
[ 1320.324081] sr 8:0:0:0: [sr0] =20
[ 1320.324087] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1320.324093] sr 8:0:0:0: [sr0] =20
[ 1320.324097] Sense Key : Hardware Error [current]=20
[ 1320.324104] Info fld=3D0x119366
[ 1320.324109] sr 8:0:0:0: [sr0] =20
[ 1320.324115] Add. Sense: Mechanical positioning error
[ 1320.324121] sr 8:0:0:0: [sr0] CDB:=20
[ 1320.324124] Read(10): 28 00 00 11 93 66 00 00 01 00
[ 1320.324140] end_request: I/O error, dev sr0, sector 4607384
[ 1320.324195] UDF-fs: error (device sr0): udf_read_tagged: read failed, bl=
ock=3D1151846, location=3D1151574
[ 1320.324208] UDF-fs: error (device sr0): __udf_read_inode: (ino 1151846) =
failed !bh
[ 1330.432689] sr 8:0:0:0: [sr0] Unhandled sense code
[ 1330.432701] sr 8:0:0:0: [sr0] =20
[ 1330.432706] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1330.432712] sr 8:0:0:0: [sr0] =20
[ 1330.432716] Sense Key : Hardware Error [current]=20
[ 1330.432722] Info fld=3D0x119365
[ 1330.432728] sr 8:0:0:0: [sr0] =20
[ 1330.432733] Add. Sense: Mechanical positioning error
[ 1330.432739] sr 8:0:0:0: [sr0] CDB:=20
[ 1330.432742] Read(10): 28 00 00 11 93 65 00 00 01 00
[ 1330.432758] end_request: I/O error, dev sr0, sector 4607380
[ 1330.432814] UDF-fs: error (device sr0): udf_read_tagged: read failed, bl=
ock=3D1151845, location=3D1151573
[ 1330.432827] UDF-fs: error (device sr0): __udf_read_inode: (ino 1151845) =
failed !bh
[ 1330.432842] UDF-fs: Failed to read VAT inode from the last recorded bloc=
k (1151848), retrying with the last block of the device (2295103).
[ 1340.483225] sr 8:0:0:0: [sr0] Unhandled sense code
[ 1340.483237] sr 8:0:0:0: [sr0] =20
[ 1340.483242] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1340.483247] sr 8:0:0:0: [sr0] =20
[ 1340.483251] Sense Key : Hardware Error [current]=20
[ 1340.483257] Info fld=3D0x23053f
[ 1340.483263] sr 8:0:0:0: [sr0] =20
[ 1340.483268] Add. Sense: Mechanical positioning error
[ 1340.483273] sr 8:0:0:0: [sr0] CDB:=20
[ 1340.483276] Read(10): 28 00 00 23 05 3f 00 00 01 00
[ 1340.483292] end_request: I/O error, dev sr0, sector 9180412
[ 1340.483373] UDF-fs: error (device sr0): udf_read_tagged: read failed, bl=
ock=3D2295103, location=3D2294831
[ 1340.483385] UDF-fs: error (device sr0): __udf_read_inode: (ino 2295103) =
failed !bh

some point around here I tried to eject

[ 1350.533357] sr 8:0:0:0: [sr0] Unhandled sense code
[ 1350.533368] sr 8:0:0:0: [sr0] =20
[ 1350.533374] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1350.533380] sr 8:0:0:0: [sr0] =20
[ 1350.533384] Sense Key : Hardware Error [current]=20
[ 1350.533390] Info fld=3D0x23053e
[ 1350.533395] sr 8:0:0:0: [sr0] =20
[ 1350.533400] Add. Sense: Mechanical positioning error
[ 1350.533406] sr 8:0:0:0: [sr0] CDB:=20
[ 1350.533409] Read(10): 28 00 00 23 05 3e 00 00 01 00
[ 1350.533425] end_request: I/O error, dev sr0, sector 9180408
[ 1350.533488] UDF-fs: error (device sr0): udf_read_tagged: read failed, bl=
ock=3D2295102, location=3D2294830
[ 1350.533501] UDF-fs: error (device sr0): __udf_read_inode: (ino 2295102) =
failed !bh
[ 1360.581244] sr 8:0:0:0: [sr0] Unhandled sense code
[ 1360.581255] sr 8:0:0:0: [sr0] =20
[ 1360.581260] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1360.581266] sr 8:0:0:0: [sr0] =20
[ 1360.581270] Sense Key : Hardware Error [current]=20
[ 1360.581277] Info fld=3D0x23053d
[ 1360.581282] sr 8:0:0:0: [sr0] =20
[ 1360.581287] Add. Sense: Mechanical positioning error
[ 1360.581293] sr 8:0:0:0: [sr0] CDB:=20
[ 1360.581296] Read(10): 28 00 00 23 05 3d 00 00 01 00
[ 1360.581312] end_request: I/O error, dev sr0, sector 9180404
[ 1360.581365] UDF-fs: error (device sr0): udf_read_tagged: read failed, bl=
ock=3D2295101, location=3D2294829
[ 1360.581377] UDF-fs: error (device sr0): __udf_read_inode: (ino 2295101) =
failed !bh
[ 1377.505817] sr 8:0:0:0: [sr0] Unhandled sense code
[ 1377.505828] sr 8:0:0:0: [sr0] =20
[ 1377.505834] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1377.505840] sr 8:0:0:0: [sr0] =20
[ 1377.505844] Sense Key : Hardware Error [current]=20
[ 1377.505850] Info fld=3D0x23053c
[ 1377.505856] sr 8:0:0:0: [sr0] =20
[ 1377.505862] Add. Sense: Mechanical positioning error
[ 1377.505867] sr 8:0:0:0: [sr0] CDB:=20
[ 1377.505870] Read(10): 28 00 00 23 05 3c 00 00 01 00
[ 1377.505886] end_request: I/O error, dev sr0, sector 9180400
[ 1377.505953] UDF-fs: error (device sr0): udf_read_tagged: read failed, bl=
ock=3D2295100, location=3D2294828
[ 1377.505966] UDF-fs: error (device sr0): __udf_read_inode: (ino 2295100) =
failed !bh

finally it ejected

[ 1384.719455] sr 8:0:0:0: [sr0] Device not ready
[ 1384.719467] sr 8:0:0:0: [sr0] =20
[ 1384.719473] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1384.719479] sr 8:0:0:0: [sr0] =20
[ 1384.719482] Sense Key : Not Ready [current]=20
[ 1384.719490] sr 8:0:0:0: [sr0] =20
[ 1384.719496] Add. Sense: Medium not present
[ 1384.719501] sr 8:0:0:0: [sr0] CDB:=20
[ 1384.719506] Read(10): 28 00 00 00 00 28 00 00 01 00
[ 1384.719522] end_request: I/O error, dev sr0, sector 160
[ 1384.719572] UDF-fs: error (device sr0): udf_read_tagged: read failed, bl=
ock=3D40, location=3D40
[ 1384.719585] UDF-fs: error (device sr0): udf_process_sequence: Block 40 o=
f volume descriptor sequence is corrupted or we could not read it
[ 1384.719624] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000054
[ 1384.719789] IP: [<ffffffffa06b80d1>] udf_sb_free_partitions+0x71/0x140 [=
udf]
[ 1384.719937] PGD 0=20
[ 1384.719982] Oops: 0000 [#1] SMP=20
[ 1384.720057] Modules linked in: nls_utf8 udf crc_itu_t tcp_lp be2iscsi is=
csi_boot_sysfs bnx2i cnic uio cxgb4i ip6t_REJECT cxgb4 cxgb3i nf_conntrack_=
ipv6 cxgb3 bnep nf_defrag_ipv6 mdio libcxgbi nf_conntrack_ipv4 nf_defrag_ip=
v4 xt_state ib_iser nf_conntrack bluetooth rdma_cm ib_addr iw_cm ib_cm ib_s=
a ib_mad rfkill ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscs=
i it87 ip6table_filter ip6_tables hwmon_vid xfs libcrc32c snd_hda_codec_hdm=
i snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq kvm s=
nd_seq_device snd_pcm joydev snd_page_alloc snd_timer sp5100_tco snd edac_c=
ore r8169 soundcore shpchp pcspkr i2c_piix4 k10temp mii serio_raw edac_mce_=
amd microcode wmi nfsd auth_rpcgss nfs_acl lockd sunrpc binfmt_misc uinput =
ata_generic pata_acpi dm_crypt pata_jmicron pata_atiixp radeon i2c_algo_bit=
 drm_kms_helper ttm drm i2c_core
[ 1384.721771] CPU 3=20
[ 1384.721818] Pid: 3684, comm: mount Not tainted 3.8.0-rc3 #107 Gigabyte T=
echnology Co., Ltd. GA-890GPA-UD3H/GA-890GPA-UD3H
[ 1384.722023] RIP: 0010:[<ffffffffa06b80d1>]  [<ffffffffa06b80d1>] udf_sb_=
free_partitions+0x71/0x140 [udf]
[ 1384.722210] RSP: 0018:ffff8801b7afbb38  EFLAGS: 00010246
[ 1384.722310] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 00000000000=
00056
[ 1384.722441] RDX: 00000000000000bc RSI: 0000000000000046 RDI: ffff8801b09=
6ec00
[ 1384.722572] RBP: ffff8801b7afbb58 R08: 000000000000000a R09: 00000000000=
005a5
[ 1384.722704] R10: 0000000000000000 R11: 00000000000005a4 R12: ffff8801b7a=
fbcd4
[ 1384.722834] R13: 0000000000000000 R14: ffff880165d073c0 R15: 00000000000=
00024
[ 1384.722967] FS:  00007f46f5224840(0000) GS:ffff88020fcc0000(0000) knlGS:=
0000000000000000
[ 1384.723116] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1384.723223] CR2: 0000000000000054 CR3: 00000001a2ff0000 CR4: 00000000000=
007e0
[ 1384.723354] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 1384.723485] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[ 1384.723617] Process mount (pid: 3684, threadinfo ffff8801b7afa000, task =
ffff880166280000)
[ 1384.723765] Stack:
[ 1384.723805]  ffff8801b096ec00 ffff8801b7afbcd4 ffff8801d1fabc98 00000000=
00000010
[ 1384.723958]  ffff8801b7afbbb8 ffffffffa06b96b5 ffff880165d07540 0000000b=
00005395
[ 1384.724110]  00007ffffffff000 00028802036a8340 ffff8801b7afbc30 ffff8801=
65d073c0
[ 1384.724260] Call Trace:
[ 1384.724319]  [<ffffffffa06b96b5>] udf_check_anchor_block+0x125/0x130 [ud=
f]
[ 1384.724455]  [<ffffffffa06b9721>] udf_scan_anchors+0x61/0x1c0 [udf]
[ 1384.724578]  [<ffffffff811ce79c>] ? ioctl_by_bdev+0x3c/0x50
[ 1384.724689]  [<ffffffffa06b9a1e>] udf_load_vrs+0x19e/0x2e0 [udf]
[ 1384.724808]  [<ffffffffa06b9d00>] udf_fill_super+0x1a0/0x610 [udf]
[ 1384.724936]  [<ffffffff8119af55>] mount_bdev+0x1c5/0x210
[ 1384.725041]  [<ffffffffa06b9b60>] ? udf_load_vrs+0x2e0/0x2e0 [udf]
[ 1384.725164]  [<ffffffffa06b7075>] udf_mount+0x15/0x20 [udf]
[ 1384.725271]  [<ffffffff8119bc43>] mount_fs+0x43/0x1b0
[ 1384.725371]  [<ffffffff811b531f>] vfs_kern_mount+0x6f/0x100
[ 1384.725479]  [<ffffffff811b7706>] do_mount+0x216/0xa70
[ 1384.725580]  [<ffffffff81135764>] ? __get_free_pages+0x14/0x50
[ 1384.730093]  [<ffffffff811b735a>] ? copy_mount_options+0x3a/0x180
[ 1384.734657]  [<ffffffff811b7fee>] sys_mount+0x8e/0xe0
[ 1384.739261]  [<ffffffff8164bf19>] system_call_fastpath+0x16/0x1b
[ 1384.743932] Code: 66 3d 11 25 0f 84 b8 00 00 00 41 0f b7 46 28 41 83 c5 =
01 44 39 e8 0f 8e 89 00 00 00 49 63 dd b9 56 00 00 00 48 0f af d9 49 03 1e =
<0f> b7 43 54 a8 02 74 b7 48 8b 3b e8 7f 9b af e0 0f b7 43 54 a8=20
[ 1384.754014] RIP  [<ffffffffa06b80d1>] udf_sb_free_partitions+0x71/0x140 =
[udf]
[ 1384.758925]  RSP <ffff8801b7afbb38>
[ 1384.763755] CR2: 0000000000000054
[ 1384.787502] ---[ end trace 95272ca777accb4e ]---

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ8dzvAAoJEHdM6cCYHcpSHzgP/0sfOcb2E3xNKhZzV2DbTbfi
rehAQSeuu9ChmaP9BwkZe9riNqxu/miyqJ0F1+uf4o4xVbeoa7N19vZoz2axCYMR
UjgDzW/HNionEE1CytmcqQUMbfmAj8Gbpc+9AH1GdxI4LyNxx2vIfxMxljFdb2X4
ffeNLfT7V9C9hjrENoboypwh0Xma6/LSLF8xnpkp4FzfTL9NUdUc+lHo1cqZRPXB
IRf1ddmp7yNdNcW6rDne8O5zt0Oipc1QSUqJJGFew291Jov9lW0/jmG3WL/Ta7Sh
4vruuHePDleHCmBEHZn7QRkJ2+rh33SY5wpZyvDhIUF4ldQB5Ps++pKPOPBfsAMj
oWnb4IAnXNYemUNzD4xCSBUfyTbJJPpmt60mgvvHUWM1antnOhND/IyjAcxiM1/z
gzAKRB5DlfuSSxvdeRSI5iUv4a7WfBIG21O0aAmr/x4Ex9/3J5eWiRancsVfDYsX
r2dBnC8s/LWiKZfNwQpZIpNcM6dNK1phRrNhGmp3pshJKvDq6/1ppbDyaTKWBQnq
LN8Lt+D/ESvDEndtfrH+hmtEW3eez//tjWSijIFtC5AAuDNqaXMVHDP2F/m1ldcL
QMJBMwrl5/Nh8Vp/yEHJrsTx2OfpNipiCkFWg8/dw2JqBJwRmvOjq/R/3UQ87beL
l2obkhXLj4GbGlcxKT3+
=esL+
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
