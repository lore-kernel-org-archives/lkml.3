Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbaIDSkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 14:40:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47483 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963AbaIDSkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 14:40:37 -0400
Date: Thu, 4 Sep 2014 13:40:21 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, <paulmck@linux.vnet.ibm.com>,
        <josh@joshtriplett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RCU bug with v3.17-rc3 ?
Message-ID: <20140904184021.GA13421@saruman.home>
Reply-To: <balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I keep triggering the following Oops with -rc3 when writing to the mass
storage gadget driver:

| # modprobe g_mass_storage stall=3D0 removable=3D1 file=3D/dev/sda
| [   44.883554] Number of LUNs=3D8
| [   44.886709] Mass Storage Function, version: 2009/09/11
| [   44.892303] LUN: removable file: (no medium)
| [   44.896916] Number of LUNs=3D1
| [   44.901198] LUN: removable file: /dev/sda
| [   44.905410] Number of LUNs=3D1
| [   44.917706] g_mass_storage gadget: Mass Storage Gadget, version: 2009/=
09/11
| [   44.925018] g_mass_storage gadget: userspace failed to provide iSerial=
Number
| [   44.932489] g_mass_storage gadget: g_mass_storage ready
| [   52.583773] g_mass_storage gadget: high-speed config #1: Linux File-Ba=
cked Storage
| # [   98.270585] Unable to handle kernel paging request at virtual addres=
s ffffffff
| [   98.278198] pgd =3D c0004000
| [   98.281027] [ffffffff] *pgd=3Dae7f6821, *pte=3D00000000, *ppte=3D00000=
000
| [   98.287648] Internal error: Oops: 17 [#1] SMP ARM
| [   98.292559] Modules linked in: g_mass_storage usb_f_mass_storage libco=
mposite configfs usb_storage xhci_hcd dwc3 udc_core matrix_keypad lis3lv02d=
_i2c dwc3_omap lis3lv02d input_polldev
| [   98.309721] CPU: 0 PID: 1820 Comm: file-storage Not tainted 3.17.0-rc3=
-00013-gc6b1a7d #806
| [   98.318346] task: ec356040 ti: ec378000 task.ti: ec378000
| [   98.324000] PC is at find_get_entry+0x7c/0x128
| [   98.328640] LR is at 0xfffffffa
| [   98.331912] pc : [<c011394c>]    lr : [<fffffffa>]    psr: a0000013
| [   98.331912] sp : ec379b50  ip : 00000000  fp : ec379b84
| [   98.343888] r10: c0c81243  r9 : 00000001  r8 : ea123d28
| [   98.349352] r7 : ec378010  r6 : 00000001  r5 : 00000000  r4 : 0000000f
| [   98.356181] r3 : ec379b3c  r2 : 00000000  r1 : 00000001  r0 : ffffffff
| [   98.363006] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segme=
nt kernel
| [   98.370646] Control: 10c5387d  Table: ac2b0059  DAC: 00000015
| [   98.376641] Process file-storage (pid: 1820, stack limit =3D 0xec37824=
8)
| [   98.383454] Stack: (0xec379b50 to 0xec37a000)
| [   98.388003] 9b40:                                     00000000 0000000=
0 c01138d0 c002aa3c
| [   98.396560] 9b60: 0000000f 00000000 ea123d24 000200d0 00000001 000000d=
0 ec379bbc ec379b88
| [   98.405100] 9b80: c0114360 c01138dc c1486a00 60000013 ec379bc4 0000140=
0 00000000 ea123d24
| [   98.413635] 9ba0: 00000c00 00000400 ec378010 c06dea0c ec379bdc ec379bc=
0 c011478c c0114330
| [   98.422183] 9bc0: 000000d0 c00904f8 c1486a00 00001400 ec379c04 ec379be=
0 c019cd68 c0114760
| [   98.430732] 9be0: c0090808 c0090590 ec379c34 00000001 00000c00 ea123d2=
4 ec379c2c ec379c08
| [   98.439300] 9c00: c019ecbc c019cd44 00000c00 00000001 ec379c58 c019eb9=
c 00000c00 ec379d54
| [   98.447860] 9c20: ec379c8c ec379c30 c0113f14 c019ec8c 00000c00 0000000=
1 ec379c58 ec379c5c
| [   98.456414] 9c40: ec378030 00000001 ec250cc0 00000000 00001400 0000000=
0 c018195c c00acd08
| [   98.464974] 9c60: 5408b05a 00001000 ec250cc0 00000000 ec379d68 ea123d2=
4 ec378010 00000000
| [   98.473533] 9c80: ec379cf4 ec379c90 c0115ed4 c0113e6c 00000001 0000000=
0 c019f2b0 c0090590
| [   98.482071] 9ca0: ec379cc4 ec378010 c06c3df4 00001000 ea123c64 c019f2b=
0 ec379d54 ec379cc8
| [   98.490607] 9cc0: 00001400 00000000 00000001 ec379d68 ec379d54 ec379e3=
0 ec250cc0 ec356040
| [   98.499178] 9ce0: ed7ab800 ec30d800 ec379d3c ec379cf8 c019f2b0 c0115c8=
c c06be3b8 c006dcec
| [   98.507741] 9d00: ec1b0010 ec30d800 ec379d08 ec379d08 ec379d10 ec379d1=
0 ec379d18 ec379d18
| [   98.516288] 9d20: 00001400 00000000 ec379e30 ec250cc0 ec379dc4 ec379d4=
0 c016618c c019f284
| [   98.524833] 9d40: 00001000 c0317b78 ec379d7c ec394000 00001000 0000000=
3 00000000 00001000
| [   98.533385] 9d60: ec379d4c 00000001 ec250cc0 00000000 00000000 0000000=
0 ec356040 00000000
| [   98.541946] 9d80: 00000000 00000000 00001400 00000000 00001000 0000000=
0 00000000 00000000
| [   98.550482] 9da0: ec394000 ec250cc0 ec394000 ec379e30 00001000 0000100=
0 ec379df4 ec379dc8
| [   98.559023] 9dc0: c0166a3c c01660f4 00000002 ec0ace20 00001000 0000000=
e ec0ace00 00000000
| [   98.567567] 9de0: 00001000 ed7ab800 ec379e64 ec379df8 bf0bc3b4 c016699=
4 0000006f 00001000
| [   98.576112] 9e00: bf0bc7a4 60000013 e8156000 0000000e 3930343d 0000000=
0 bf0bc7a4 ec0ace00
| [   98.584660] 9e20: 00002400 00000000 00001400 00000000 00001400 0000000=
0 ec379e64 00000000
| [   98.593193] 9e40: ed36ddc0 ec378018 ec30d894 ec0ace00 ec30d800 ec30d84=
0 ec379ed4 ec379e68
| [   98.601754] 9e60: bf0bd1c8 bf0bc08c bf0bf6ec ec378010 c06c3df4 ec35604=
0 00000001 00000000
| [   98.610305] 9e80: ec379eac ec379e90 c00906b0 c00904f8 ec30d894 ed36ddc=
0 ec378018 ec30d894
| [   98.618857] 9ea0: ec379ebc ec379eb0 c0090808 ec30d800 ed36ddc0 ec37801=
8 ec30d894 00000000
| [   98.627405] 9ec0: 00000200 ec0ace00 ec379f14 ec379ed8 bf0bdbe8 bf0bc74=
c c06c3d94 ec0acc80
| [   98.635942] 9ee0: ec394000 ec30d800 bf0bd8cc ec0acc80 00000000 ec30d80=
0 bf0bd8cc 00000000
| [   98.644465] 9f00: 00000000 00000000 ec379fac ec379f18 c0066ac4 bf0bd8d=
8 ed1d1040 00000000
| [   98.652990] 9f20: ec379f3c ec30d800 00000000 00000000 dead4ead fffffff=
f ffffffff c0c86138
| [   98.661526] 9f40: 00000000 00000000 c08998e0 00000000 c006dd7c ec379f5=
4 ec379f54 00000000
| [   98.670077] 9f60: 00000000 dead4ead ffffffff ffffffff c0c86138 0000000=
0 00000000 c08998e0
| [   98.678612] 9f80: 00000000 ec379f90 ec379f88 ec379f88 ec0acc80 c00669e=
0 00000000 00000000
| [   98.687148] 9fa0: 00000000 ec379fb0 c000eea8 c00669ec 00000000 0000000=
0 00000000 00000000
| [   98.695699] 9fc0: 00000000 00000000 00000000 00000000 00000000 0000000=
0 00000000 00000000
| [   98.704249] 9fe0: 00000000 00000000 00000000 00000000 00000013 0000000=
0 00000000 00000000
| [   98.712805] [<c011394c>] (find_get_entry) from [<c0114360>] (pagecache=
_get_page+0x3c/0x1f0)
| [   98.721529] [<c0114360>] (pagecache_get_page) from [<c011478c>] (grab_=
cache_page_write_begin+0x38/0x50)
| [   98.731345] [<c011478c>] (grab_cache_page_write_begin) from [<c019cd68=
>] (block_write_begin+0x30/0x90)
| [   98.741067] [<c019cd68>] (block_write_begin) from [<c019ecbc>] (blkdev=
_write_begin+0x3c/0x48)
| [   98.749974] [<c019ecbc>] (blkdev_write_begin) from [<c0113f14>] (gener=
ic_perform_write+0xb4/0x1e4)
| [   98.759335] [<c0113f14>] (generic_perform_write) from [<c0115ed4>] (__=
generic_file_write_iter+0x254/0x51c)
| [   98.769424] [<c0115ed4>] (__generic_file_write_iter) from [<c019f2b0>]=
 (blkdev_write_iter+0x38/0xc0)
| [   98.778978] [<c019f2b0>] (blkdev_write_iter) from [<c016618c>] (new_sy=
nc_write+0xa4/0xcc)
| [   98.787526] [<c016618c>] (new_sync_write) from [<c0166a3c>] (vfs_write=
+0xb4/0x1c0)
| [   98.795462] [<c0166a3c>] (vfs_write) from [<bf0bc3b4>] (do_write+0x334=
/0x53c [usb_f_mass_storage])
| [   98.804858] [<bf0bc3b4>] (do_write [usb_f_mass_storage]) from [<bf0bd1=
c8>] (do_scsi_command+0xa88/0x118c [usb_f_mass_storage])
| [   98.816782] [<bf0bd1c8>] (do_scsi_command [usb_f_mass_storage]) from [=
<bf0bdbe8>] (fsg_main_thread+0x31c/0x72c [usb_f_mass_storage])
| [   98.829249] [<bf0bdbe8>] (fsg_main_thread [usb_f_mass_storage]) from [=
<c0066ac4>] (kthread+0xe4/0x100)
| [   98.838993] [<c0066ac4>] (kthread) from [<c000eea8>] (ret_from_fork+0x=
14/0x20)
| [   98.846554] Code: e1a01009 eb0905d4 e3500000 0a00001f (e5904000)=20
| [   98.853110] ---[ end trace 8bdf31522b942652 ]---


The setup is a bit "odd", I have a USB stick attached to the host port
on my platform and the peripheral port uses that stick as backing file.
that is connected to a laptop which I'm using to read/write to that
backing file. The problem doesn't seem to trigger if I run the exact
same test straight to the USB stick which is attached to the host port.

My test application is rather basic [1] which I run with a script [2] to
pass sensible arguments. I haven't found another way to reproducing this
yet, so it could very well be that g_mass_storage is at fault here, as I
also managed to trigger this when using a tmpfs as backing file.

Anyway, looking at PC:

| (gdb) list *(find_get_entry+0x7c)
| 0xc011394c is in find_get_entry (include/linux/radix-tree.h:196).
| 191      * radix_tree_deref_retry must be used to confirm validity of the=
 pointer if
| 192      * only the read lock is held.
| 193      */
| 194     static inline void *radix_tree_deref_slot(void **pslot)
| 195     {
| 196             return rcu_dereference(*pslot);
| 197     }
| 198
| 199     /**
| 200      * radix_tree_deref_slot_protected      - dereference a slot with=
out RCU lock but with tree lock held
| (gdb)=20

And looking at the arguments for that function, we're passing r0 as
0xffffffff and r1 as 1, which clearly is bogus, but I don't know, at
least not yet, where did those come from. I'll see if I can reproduce
the same problem with dummy_hcd to rule out a bug in my dwc3 driver :-)

cheers

--=20
balbi

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUCLIVAAoJEIaOsuA1yqREho8P/2Ep4oNXDLkSAbuKmDthckrz
LvThJH1r6a8wG6mNaD1tyPJp6NSU2dyBAYDmJIvBtqRBCWJDM0jKaRY7x5HkpkZJ
F7G3yVvqYDhSwC1yrhKIHK1uK0YvA/cistxMmfQNhFwdnGLgO+e28wkUE3HQalIr
icXk9BgqfqdcJJahOQHFkTuif/fHhVQ0iOaSlIS2L7CaP0IbWB9B5q2omgKwNm9X
Nbt5XR3teXTESFiPzm27XzgzIQsIAJAFqxFTdpqmoIAm7CyuytJlKyHT/Z/chpLS
HHXuLemaAl5aOxH45Ut8BaVVNB2AzsnpIHpslXEsSP3nrPYJfbdqvM1ekQdLOn4d
4+1Ziev8/33iF9gG77S9hw2+K3pL+cgsZkGEeBBWwURxJiRnXctwIzygz+y01lk5
XLizYzYCkSLycqW3bCeNMAw/CEIENXRIzR1CZvtH5GVmEGmNDtHy/CfbYkX+fQTp
Uqb4Wke8jHWFLfL1wZLL+Iap3cwXQj0w2WDKvVGFhLur/XA7lELF6InjMEBxKkCb
Z40VhU7f5q06a+H0TwfE/cKdoVdoFbwPaRZWFWxFpcueIZsprwOIjwBTxqcE/7hS
XH8DnugeUYmB07SQcfNLmsqXhZNSvjVzzx/+D8yX6VGBT8/7XY3RFIM7OLXFW6dp
OtgILIR96I57rt50kG7L
=8DfA
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
