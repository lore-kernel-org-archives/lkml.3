Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077Ab3DBMBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 08:01:42 -0400
Received: from mailout3.uni-hannover.de ([130.75.2.104]:41174 "EHLO
	mailout3.uni-hannover.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760013Ab3DBMBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 08:01:40 -0400
Message-ID: <515AC8A1.1070901@tnt.uni-hannover.de>
Date: Tue, 02 Apr 2013 14:01:37 +0200
From: Marco Munderloh <munderl@tnt.uni-hannover.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ilija Hadzic <ilijahadzic@gmail.com>
CC: Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Michal Hocko <mhocko@suse.cz>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] drm: fix i_mapping and f_mapping initialization in drm_open
 in error path
References: <20130326195601.GA5124@dhcp22.suse.cz> <CA+4h6Hnhm-Ox_5dRdBH3C9Lh_qVNac8_oL=3ruy75jBX7xp9OQ@mail.gmail.com> <20130331103418.GA18476@dhcp22.suse.cz> <Pine.GSO.4.64.1304011249370.27674@umail> <515AB490.8010703@tnt.uni-hannover.de> <CA+4h6HkOSPUpfT-5Hwe+zRkmSdhURM6Tv4RxM+9PMCEvG+tjZw@mail.gmail.com>
In-Reply-To: <CA+4h6HkOSPUpfT-5Hwe+zRkmSdhURM6Tv4RxM+9PMCEvG+tjZw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080501080902080706070802"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms080501080902080706070802
Content-Type: multipart/mixed;
 boundary="------------070700060402010507010305"

This is a multi-part message in MIME format.
--------------070700060402010507010305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Ilija,

> Thanks for testing. Other issues are probably unrelated, so I'll send t=
he last version of the patch to Dave.

I came across another problem which seems related. rmmod radeon works, ho=
wever, modprobe radeon afterwards results in a crash (divide error), see =
attachment.

Best, Marco

On 02.04.2013 13:23, Ilija Hadzic wrote:
>
> -- Ilija
>
> On Tue, Apr 2, 2013 at 6:36 AM, Marco Munderloh <munderl@tnt.uni-hannov=
er.de <mailto:munderl@tnt.uni-hannover.de>> wrote:
>
>         Attached is a v2 of the patch, for reference. I would appreciat=
e if the original reporter or you tested it in lieu of your proposed patc=
h and let me know if it
>         fixes your
>         issue.
>
>
>     The patch works for me. echo 3 > /proc/sys/vm/drop_caches as well a=
s rmmod radeon do not end up in a crash anymore. However, I have still no=
 clue why one of these makes
>     drm_open to fail. On rmmod radeon I get the following log messages.=
 If don't know if the 'unpin not necessary' has anything to do with it.
>
>     [drm] radeon: finishing device.
>     radeon 0000:01:00.0: ffff88024e526c00 unpin not necessary
>     radeon 0000:01:00.0: ffff88024f2f6000 unpin not necessary
>     radeon 0000:01:00.0: ffff88024f2f6000 unpin not necessary
>     [TTM] Finalizing pool allocator
>     [TTM] Finalizing DMA pool allocator
>     [TTM] Zone  kernel: Used memory at exit: 0 kiB
>     [TTM] Zone   dma32: Used memory at exit: 0 kiB
>     [drm] radeon: ttm finalized
>     vga_switcheroo: disabled
>     [drm] Module unloaded
>
>     By the way, sometimes my r8169 ethernet controller does not survive=
 suspend/hibernation (does not detect link). rmmod/modprobe helps. I don'=
t know if this is related.
>
>

--=20
Dipl.-Ing. Marco Munderloh             Mail: munderl@tnt.uni-hannover.de
Institut f=FCr Informationsverarbeitung (TNT)     Phone: +49 511 762-1958=
7
Leibniz Universitaet Hannover, Appelstr. 9a       Fax: +49 511 762- 5333
30167 Hannover, Germany     Web: http://www.tnt.uni-hannover.de/~munderl

--------------070700060402010507010305
Content-Type: text/x-log;
 name="crash_modprobe_radeon.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="crash_modprobe_radeon.log"

2013-04-02T12:46:25.434028+02:00 apophis kernel: [ 1826.998301] [drm] rad=
eon defaulting to kernel modesetting.
2013-04-02T12:46:25.434042+02:00 apophis kernel: [ 1826.998303] [drm] rad=
eon kernel modesetting enabled.
2013-04-02T12:46:25.434044+02:00 apophis kernel: [ 1826.998316] VGA switc=
heroo: detected switching method \_SB_.PCI0.GFX0.ATPX handle
2013-04-02T12:46:25.434045+02:00 apophis kernel: [ 1826.998452] [drm] ini=
tializing kernel modesetting (TURKS 0x1002:0x6741 0x104D:0x907B).
2013-04-02T12:46:25.434046+02:00 apophis kernel: [ 1826.998476] [drm] reg=
ister mmio base: 0xC8400000
2013-04-02T12:46:25.434047+02:00 apophis kernel: [ 1826.998477] [drm] reg=
ister mmio size: 131072
2013-04-02T12:46:25.434047+02:00 apophis kernel: [ 1826.998478] vga_switc=
heroo: enabled
2013-04-02T12:46:25.434048+02:00 apophis kernel: [ 1826.998548] ATPX vers=
ion 1
2013-04-02T12:46:26.290054+02:00 apophis kernel: [ 1827.852872] ATOM BIOS=
: Sony
2013-04-02T12:46:26.290096+02:00 apophis kernel: [ 1827.852895] radeon 00=
00:01:00.0: GPU softreset=20
2013-04-02T12:46:26.290102+02:00 apophis kernel: [ 1827.852900] radeon 00=
00:01:00.0:   GRBM_STATUS=3D0xFFFFFFFF
2013-04-02T12:46:26.290106+02:00 apophis kernel: [ 1827.852905] radeon 00=
00:01:00.0:   GRBM_STATUS_SE0=3D0xFFFFFFFF
2013-04-02T12:46:26.290109+02:00 apophis kernel: [ 1827.852909] radeon 00=
00:01:00.0:   GRBM_STATUS_SE1=3D0xFFFFFFFF
2013-04-02T12:46:26.290112+02:00 apophis kernel: [ 1827.852914] radeon 00=
00:01:00.0:   SRBM_STATUS=3D0xFFFFFFFF
2013-04-02T12:46:26.290115+02:00 apophis kernel: [ 1827.852918] radeon 00=
00:01:00.0:   R_008674_CP_STALLED_STAT1 =3D 0xFFFFFFFF
2013-04-02T12:46:26.290118+02:00 apophis kernel: [ 1827.852923] radeon 00=
00:01:00.0:   R_008678_CP_STALLED_STAT2 =3D 0xFFFFFFFF
2013-04-02T12:46:26.290121+02:00 apophis kernel: [ 1827.852928] radeon 00=
00:01:00.0:   R_00867C_CP_BUSY_STAT     =3D 0xFFFFFFFF
2013-04-02T12:46:26.290124+02:00 apophis kernel: [ 1827.852932] radeon 00=
00:01:00.0:   R_008680_CP_STAT          =3D 0xFFFFFFFF
2013-04-02T12:46:27.262050+02:00 apophis kernel: [ 1828.824062] radeon 00=
00:01:00.0: Wait for MC idle timedout !
2013-04-02T12:46:27.262086+02:00 apophis kernel: [ 1828.824073] radeon 00=
00:01:00.0:   GRBM_SOFT_RESET=3D0x00007F6B
2013-04-02T12:46:27.262091+02:00 apophis kernel: [ 1828.824178] radeon 00=
00:01:00.0:   GRBM_STATUS=3D0xFFFFFFFF
2013-04-02T12:46:27.262095+02:00 apophis kernel: [ 1828.824182] radeon 00=
00:01:00.0:   GRBM_STATUS_SE0=3D0xFFFFFFFF
2013-04-02T12:46:27.262099+02:00 apophis kernel: [ 1828.824186] radeon 00=
00:01:00.0:   GRBM_STATUS_SE1=3D0xFFFFFFFF
2013-04-02T12:46:27.262103+02:00 apophis kernel: [ 1828.824191] radeon 00=
00:01:00.0:   SRBM_STATUS=3D0xFFFFFFFF
2013-04-02T12:46:27.262106+02:00 apophis kernel: [ 1828.824195] radeon 00=
00:01:00.0:   R_008674_CP_STALLED_STAT1 =3D 0xFFFFFFFF
2013-04-02T12:46:27.262109+02:00 apophis kernel: [ 1828.824200] radeon 00=
00:01:00.0:   R_008678_CP_STALLED_STAT2 =3D 0xFFFFFFFF
2013-04-02T12:46:27.262112+02:00 apophis kernel: [ 1828.824204] radeon 00=
00:01:00.0:   R_00867C_CP_BUSY_STAT     =3D 0xFFFFFFFF
2013-04-02T12:46:27.262115+02:00 apophis kernel: [ 1828.824209] radeon 00=
00:01:00.0:   R_008680_CP_STAT          =3D 0xFFFFFFFF
2013-04-02T12:46:27.994081+02:00 apophis kernel: [ 1829.553641] radeon 00=
00:01:00.0: limiting VRAM
2013-04-02T12:46:27.994095+02:00 apophis kernel: [ 1829.553653] radeon 00=
00:01:00.0: VRAM: 3584M 0x0000000000000000 - 0x00000000DFFFFFFF (3584M us=
ed)
2013-04-02T12:46:27.994096+02:00 apophis kernel: [ 1829.553659] radeon 00=
00:01:00.0: GTT: 512M 0x00000000E0000000 - 0x00000000FFFFFFFF
2013-04-02T12:46:27.994097+02:00 apophis kernel: [ 1829.553675] mtrr: no =
more MTRRs available
2013-04-02T12:46:27.994098+02:00 apophis kernel: [ 1829.553679] [drm] Det=
ected VRAM RAM=3D3584M, BAR=3D256M
2013-04-02T12:46:27.994099+02:00 apophis kernel: [ 1829.553682] [drm] RAM=
 width 128bits DDR
2013-04-02T12:46:27.994100+02:00 apophis kernel: [ 1829.553859] [TTM] Zon=
e  kernel: Available graphics memory: 4053020 kiB
2013-04-02T12:46:27.994100+02:00 apophis kernel: [ 1829.553866] [TTM] Zon=
e   dma32: Available graphics memory: 2097152 kiB
2013-04-02T12:46:27.994101+02:00 apophis kernel: [ 1829.553870] [TTM] Ini=
tializing pool allocator
2013-04-02T12:46:27.994102+02:00 apophis kernel: [ 1829.553880] [TTM] Ini=
tializing DMA pool allocator
2013-04-02T12:46:27.994103+02:00 apophis kernel: [ 1829.553929] [drm] rad=
eon: 3584M of VRAM memory ready
2013-04-02T12:46:27.994103+02:00 apophis kernel: [ 1829.553933] [drm] rad=
eon: 512M of GTT memory ready.
2013-04-02T12:46:27.994104+02:00 apophis kernel: [ 1829.553967] [drm] Sup=
ports vblank timestamp caching Rev 1 (10.10.2010).
2013-04-02T12:46:27.994105+02:00 apophis kernel: [ 1829.553970] [drm] Dri=
ver supports precise vblank timestamp query.
2013-04-02T12:46:27.994106+02:00 apophis kernel: [ 1829.554021] [drm] rad=
eon: irq initialized.
2013-04-02T12:46:27.994106+02:00 apophis kernel: [ 1829.554030] [drm] GAR=
T: num cpu pages 131072, num gpu pages 131072
2013-04-02T12:46:27.994107+02:00 apophis kernel: [ 1829.555334] [drm] pro=
bing gen 2 caps for device 8086:101 =3D 2/0
2013-04-02T12:46:27.994108+02:00 apophis kernel: [ 1829.555339] [drm] PCI=
E gen 2 link speeds already enabled
2013-04-02T12:46:27.994108+02:00 apophis kernel: [ 1829.555439] [drm] Loa=
ding TURKS Microcode
2013-04-02T12:46:28.966010+02:00 apophis kernel: [ 1830.524411] radeon 00=
00:01:00.0: Wait for MC idle timedout !
2013-04-02T12:46:29.090044+02:00 apophis kernel: [ 1830.646315] radeon 00=
00:01:00.0: Wait for MC idle timedout !
2013-04-02T12:46:29.914583+02:00 apophis kernel: [ 1831.376370] [drm] PCI=
E GART of 512M enabled (table at 0x0000000000040000).
2013-04-02T12:46:29.914616+02:00 apophis kernel: [ 1831.376440] divide er=
ror: 0000 [#1] SMP=20
2013-04-02T12:46:29.914617+02:00 apophis kernel: [ 1831.376510] Modules l=
inked in: radeon(+) cpufreq_stats fuse af_packet xt_tcpudp xt_pkttype xt_=
LOG xt_limit bnep bluetooth ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 =
ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter ip6table_mangle =
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defra=
g_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter ip6_tables x_t=
ables cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufr=
eq mperf coretemp kvm_intel kvm snd_hda_codec_hdmi crc32c_intel ghash_clm=
ulni_intel aesni_intel snd_hda_codec_realtek arc4 iwldvm mac80211 snd_hda=
_intel snd_hda_codec ablk_helper cryptd tpm_infineon lrw aes_x86_64 xts u=
vcvideo snd_hwdep gf128mul snd_pcm videobuf2_core videodev videobuf2_vmal=
loc iwlwifi videobuf2_memops tpm_tis i2c_i801 sony_laptop iTCO_wdt r8169 =
tpm iTCO_vendor_support mei lpc_ich mfd_core sr_mod snd_seq sg pcspkr snd=
_timer snd_seq_device battery microcode snd cfg80211 soundcore rfkill snd=
_page_alloc ac cdrom tpm_bios autofs4 xhci_hcd i915 ehci_hcd ttm usbcore =
drm_kms_helper usb_common drm i2c_algo_bit thermal video button processor=
 thermal_sys scsi_dh_emc scsi_dh_rdac scsi_dh_hp_sw scsi_dh_alua scsi_dh =
[last unloaded: radeon]
2013-04-02T12:46:29.914619+02:00 apophis kernel: [ 1831.378143] CPU 3=20
2013-04-02T12:46:29.914620+02:00 apophis kernel: [ 1831.378174] Pid: 3034=
, comm: modprobe Not tainted 3.7.10-1-default-patched #5 Sony Corporation=
 VPCSA4W9E/VAIO
2013-04-02T12:46:29.914621+02:00 apophis kernel: [ 1831.378281] RIP: 0010=
:[<ffffffffa07f4f60>]  [<ffffffffa07f4f60>] r6xx_remap_render_backend+0x7=
0/0xe0 [radeon]
2013-04-02T12:46:29.914622+02:00 apophis kernel: [ 1831.378449] RSP: 0018=
:ffff880254d89c40  EFLAGS: 00010246
2013-04-02T12:46:29.914622+02:00 apophis kernel: [ 1831.378509] RAX: 0000=
000000000004 RBX: 0000000000000000 RCX: 0000000000000000
2013-04-02T12:46:29.914623+02:00 apophis kernel: [ 1831.378585] RDX: 0000=
000000000000 RSI: 0000000000000000 RDI: ffff8802512b0000
2013-04-02T12:46:29.914624+02:00 apophis kernel: [ 1831.378661] RBP: 0000=
000000000002 R08: 00000000000000ff R09: 0000000000000000
2013-04-02T12:46:29.914634+02:00 apophis kernel: [ 1831.378737] R10: 0000=
000000000001 R11: 0000000000000008 R12: 0000000000000002
2013-04-02T12:46:29.914636+02:00 apophis kernel: [ 1831.378813] R13: 0000=
000000000004 R14: 00000000ffffffff R15: ffff8802506e6380
2013-04-02T12:46:29.914639+02:00 apophis kernel: [ 1831.378891] FS:  0000=
7f2f1310f700(0000) GS:ffff88025fac0000(0000) knlGS:0000000000000000
2013-04-02T12:46:29.914642+02:00 apophis kernel: [ 1831.378978] CS:  0010=
 DS: 0000 ES: 0000 CR0: 0000000080050033
2013-04-02T12:46:29.914644+02:00 apophis kernel: [ 1831.379041] CR2: 0000=
7f5ebd0ea000 CR3: 00000002513c8000 CR4: 00000000000407e0
2013-04-02T12:46:29.914647+02:00 apophis kernel: [ 1831.379117] DR0: 0000=
000000000000 DR1: 0000000000000000 DR2: 0000000000000000
2013-04-02T12:46:29.914649+02:00 apophis kernel: [ 1831.379193] DR3: 0000=
000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
2013-04-02T12:46:29.914652+02:00 apophis kernel: [ 1831.379271] Process m=
odprobe (pid: 3034, threadinfo ffff880254d88000, task ffff88024c31e580)
2013-04-02T12:46:29.914654+02:00 apophis kernel: [ 1831.379359] Stack:
2013-04-02T12:46:29.914657+02:00 apophis kernel: [ 1831.379384]  ffff8802=
512b0000 00000000000000ff 0000000002010002 0000000040000000
2013-04-02T12:46:29.914659+02:00 apophis kernel: [ 1831.379479]  ffffffff=
a080aaf9 0000000000000282 ffffffff00000018 ffff880254d89cc8
2013-04-02T12:46:29.914662+02:00 apophis kernel: [ 1831.379573]  ffff8802=
54d89c88 ffff8802512b0000 ffff8802512b0000 0000000000000000
2013-04-02T12:46:29.914664+02:00 apophis kernel: [ 1831.379668] Call Trac=
e:
2013-04-02T12:46:29.914667+02:00 apophis kernel: [ 1831.379928]  [<ffffff=
ffa080aaf9>] evergreen_gpu_init+0x269/0xc20 [radeon]
2013-04-02T12:46:29.914669+02:00 apophis kernel: [ 1831.380226]  [<ffffff=
ffa080eff4>] evergreen_startup+0x1d4/0xa60 [radeon]
2013-04-02T12:46:29.914672+02:00 apophis kernel: [ 1831.380517]  [<ffffff=
ffa080f9f6>] evergreen_init+0x176/0x290 [radeon]
2013-04-02T12:46:29.914674+02:00 apophis kernel: [ 1831.380815]  [<ffffff=
ffa07b15a2>] radeon_device_init+0x532/0x620 [radeon]
2013-04-02T12:46:29.914677+02:00 apophis kernel: [ 1831.384920]  [<ffffff=
ffa07b2f54>] radeon_driver_load_kms+0x84/0x170 [radeon]
2013-04-02T12:46:29.914680+02:00 apophis kernel: [ 1831.389039]  [<ffffff=
ffa00a77e5>] drm_get_pci_dev+0x185/0x2a0 [drm]
2013-04-02T12:46:29.914682+02:00 apophis kernel: [ 1831.393077]  [<ffffff=
ff812d96c6>] local_pci_probe+0x46/0x80
2013-04-02T12:46:29.914685+02:00 apophis kernel: [ 1831.397045]  [<ffffff=
ff812d9912>] pci_device_probe+0x122/0x130
2013-04-02T12:46:29.914688+02:00 apophis kernel: [ 1831.401000]  [<ffffff=
ff813826bd>] driver_probe_device+0x7d/0x380
2013-04-02T12:46:29.914691+02:00 apophis kernel: [ 1831.404944]  [<ffffff=
ff81382a53>] __driver_attach+0x93/0xa0
2013-04-02T12:46:29.914693+02:00 apophis kernel: [ 1831.408876]  [<ffffff=
ff813808fd>] bus_for_each_dev+0x4d/0x80
2013-04-02T12:46:29.914696+02:00 apophis kernel: [ 1831.412796]  [<ffffff=
ff81381ce0>] bus_add_driver+0x180/0x280
2013-04-02T12:46:29.914698+02:00 apophis kernel: [ 1831.416727]  [<ffffff=
ff81383094>] driver_register+0x84/0x180
2013-04-02T12:46:29.914701+02:00 apophis kernel: [ 1831.420605]  [<ffffff=
ff810002ea>] do_one_initcall+0x12a/0x180
2013-04-02T12:46:29.914704+02:00 apophis kernel: [ 1831.424449]  [<ffffff=
ff810a4b02>] sys_init_module+0xb2/0x220
2013-04-02T12:46:29.914706+02:00 apophis kernel: [ 1831.428314]  [<ffffff=
ff81549bed>] system_call_fastpath+0x1a/0x1f
2013-04-02T12:46:29.914709+02:00 apophis kernel: [ 1831.432140]  [<00007f=
2f12a2fe2a>] 0x7f2f12a2fe29
2013-04-02T12:46:29.914713+02:00 apophis kernel: [ 1831.435902] Code: 31 =
db 45 89 c1 66 0f 1f 44 00 00 44 89 cb 41 d1 e9 83 e3 01 41 01 db 83 ee 0=
1 75 ef 89 c1 44 29 d9 41 39 cd 72 6b 31 d2 44 89 e8 <f7> f1 0f af c8 41 =
89 c1 44 89 e8 29 c8 83 bf c0 00 00 00 27 19=20
2013-04-02T12:46:29.914717+02:00 apophis kernel: [ 1831.444363] RIP  [<ff=
ffffffa07f4f60>] r6xx_remap_render_backend+0x70/0xe0 [radeon]
2013-04-02T12:46:29.914720+02:00 apophis kernel: [ 1831.448575]  RSP <fff=
f880254d89c40>
2013-04-02T12:46:29.914722+02:00 apophis kernel: [ 1831.473249] ---[ end =
trace 8f29e167bc8c5823 ]---

--------------070700060402010507010305--

--------------ms080501080902080706070802
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIOBTCC
BCEwggMJoAMCAQICAgDHMA0GCSqGSIb3DQEBBQUAMHExCzAJBgNVBAYTAkRFMRwwGgYDVQQK
ExNEZXV0c2NoZSBUZWxla29tIEFHMR8wHQYDVQQLExZULVRlbGVTZWMgVHJ1c3QgQ2VudGVy
MSMwIQYDVQQDExpEZXV0c2NoZSBUZWxla29tIFJvb3QgQ0EgMjAeFw0wNjEyMTkxMDI5MDBa
Fw0xOTA2MzAyMzU5MDBaMFoxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAw
DgYDVQQLEwdERk4tUEtJMSQwIgYDVQQDExtERk4tVmVyZWluIFBDQSBHbG9iYWwgLSBHMDEw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDpm8NnhfkNrvWNVMOWUDU9YuluTO2U
1wBblSJ01CDrNI/W7MAxBAuZgeKmFNJSoCgjhIt0iQReW+DieMF4yxbLKDU5ey2QRdDtoAB6
fL9KDhsAw4bpXCsxEXsM84IkQ4wcOItqaACa7txPeKvSxhObdq3u3ibo7wGvdA/BCaL2a869
080UME/15eOkyGKbghoDJzANAmVgTe3RCSMqljVYJ9N2xnG2kB3E7f81hn1vM7PbD8URwoqD
oZRdQWvY0hD1TP3KUazZve+Sg7va64sWVlZDz+HVEz2mHycwzUlU28kTNJpxdcVs6qcLmPkh
nSevPqM5OUhqjK3JmfvDEvK9AgMBAAGjgdkwgdYwcAYDVR0fBGkwZzBloGOgYYZfaHR0cDov
L3BraS50ZWxlc2VjLmRlL2NnaS1iaW4vc2VydmljZS9hZl9Eb3dubG9hZEFSTC5jcmw/LWNy
bF9mb3JtYXQ9WF81MDkmLWlzc3Vlcj1EVF9ST09UX0NBXzIwHQYDVR0OBBYEFEm3xs/oPR9/
6kR7Eyn38QpwPt5kMB8GA1UdIwQYMBaAFDHDeRu69VPXF+CJei0XbAqzK50zMA4GA1UdDwEB
/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgECMA0GCSqGSIb3DQEBBQUAA4IBAQA74Vp3wEgX
3KkY7IGvWonwvSiSpspZGBJw7Cjy565/lizn8l0ZMfYTK3S9vYCyufdnyTmieTvhERHua3iR
M347XyYndVNljjNj7s9zw7CSI0khUHUjoR8Y4pSFPT8z6XcgjaK95qGFKUD2P3MyWA0Ja6ba
hWzAP7uNZmRWJE6uDT8yNQFb6YyC2XJZT7GGhfF0hVblw/hc843uR7NTBXDn5U2KaYMo4RMJ
hp5eyOpYHgwf+aTUWgRo/Sg+iwK2WLX2oSw3VwBnqyNojWOl75lrXP1LVvarQIc01BGSbOyH
xQoLBzNytG8MHVQs2FHHzL8w00Ny8TK/jM5JY6gA9/IcMIIE0zCCA7ugAwIBAgIECihcPjAN
BgkqhkiG9w0BAQUFADBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZOLVZlcmVpbjEQMA4G
A1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFsIC0gRzAxMB4X
DTA3MDMyNzA5MDY1NVoXDTE5MDMyNjAwMDAwMFowZzELMAkGA1UEBhMCREUxJjAkBgNVBAoT
HUxlaWJuaXogVW5pdmVyc2l0YWV0IEhhbm5vdmVyMQ0wCwYDVQQLEwRSUlpOMSEwHwYDVQQD
ExhDQSBkZXIgTFVIIChVSC1DQSkgLSBHMDMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
AoIBAQDQqNv2Q98KioaZviQqCRxVSqqwRZkROa6VEJOtMGEzTgS9wBgfZjdFWtqbZjZ1PQ6f
fvMeXfGbycU09eJSz0FY3mra/pw04e32ibas34L/zfjhBoZVnRy7Q5joZoWtdh6eRBLDM0g1
tCFsuwHS8u9+4ERY3+dxqqjJqS+RigelBH6qi3q/+2mN9b6pFcrgEalRIj//GOHQYxAwsCsj
KpyDTl5S7B/MUb3i3tNTuLbgpJkshk+NHyGdienaTDO6zVfR1S6eL9NHQqyNhnZsDutPDZ17
hgJ3Obt3b610grSGNTmzqdc5aI5SoE5xURNrfmtAoXM3xDr9SAPNcvnnpE1nAgMBAAGjggGS
MIIBjjAPBgNVHRMBAf8EBTADAQH/MAsGA1UdDwQEAwIBBjAdBgNVHQ4EFgQU0/vgTeRNiIX0
UalveXXpwCkhLhMwHwYDVR0jBBgwFoAUSbfGz+g9H3/qRHsTKffxCnA+3mQwgYgGA1UdHwSB
gDB+MD2gO6A5hjdodHRwOi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9j
cmwvY2FjcmwuY3JsMD2gO6A5hjdodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dsb2JhbC1yb290
LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMIGiBggrBgEFBQcBAQSBlTCBkjBHBggrBgEFBQcwAoY7
aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1jYS9wdWIvY2FjZXJ0L2NhY2Vy
dC5jcnQwRwYIKwYBBQUHMAKGO2h0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ2xvYmFsLXJvb3Qt
Y2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MA0GCSqGSIb3DQEBBQUAA4IBAQDNgDr2fBimkpg/
1AOyq9lN8fmHjns5kPSioM83th54EwVB7ALIyNbneGQQddseA1211ug/vCp1rDEvdHDif2Pi
Or51ezw8pWHsoUmxJlijB8eN3mRe/1RX2nyJwFrWbE9syZ+jnFqsx558tBT8JpCayTHdyyV5
K0QrNwUuhkndHTxvTb5H9o17ljk4jlAFKdbdSwwMISOM0OiDR6NIiQV/PiiZ+JgqMuvh3uNn
so/qNwBQea6W+VYJc7IIh1bxFQSiVcpfbn+yMx/j+Ei4gwkJkGde5WHPJEF0CpOly4kJLJNE
w2GVKhw4Xd3ysAbn7aKpMgMQZYQE11qUR++QlxnRMIIFBTCCA+2gAwIBAgIEEL/H/jANBgkq
hkiG9w0BAQUFADBnMQswCQYDVQQGEwJERTEmMCQGA1UEChMdTGVpYm5peiBVbml2ZXJzaXRh
ZXQgSGFubm92ZXIxDTALBgNVBAsTBFJSWk4xITAfBgNVBAMTGENBIGRlciBMVUggKFVILUNB
KSAtIEcwMzAeFw0xMDA5MjcwNzQwMzFaFw0xMzA5MjYwNzQwMzFaMF0xCzAJBgNVBAYTAkRF
MSYwJAYDVQQKEx1MZWlibml6IFVuaXZlcnNpdGFldCBIYW5ub3ZlcjEMMAoGA1UECxMDdG50
MRgwFgYDVQQDEw9NYXJjbyBNdW5kZXJsb2gwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
AoIBAQChhydrsnNsSylhRz/AKYCgRHVwYhNJmEthqm1bWlGaVoEg5FcBaNCLKTpn6O1kMRme
+Ifh56Lp2Yb+0jNz4Pm74Nen3aVAkzgV07OO+n43xP6n7mxDg1Fd/4iKOdUbhSN1/StE7rxu
fUEM4oT5cLOuUJsJIDp4uul5qi5dKMk2bVgxA8hBHDwgaRUT96ymFZBNRLN/MPTK7xq4xCuh
9iNp3FMxuMfnCLRvShql3/40Z+MEniVgN8hjt9JnBfC/QCeQTT4f2rL17N6znAHE6VFwES+i
cEjtlls/McdhH+suXplACXgzPZGcY1DRJj3A6+yWVLLJ0NClvMiL81fX1+9DAgMBAAGjggHB
MIIBvTAJBgNVHRMEAjAAMAsGA1UdDwQEAwIF4DApBgNVHSUEIjAgBggrBgEFBQcDAgYIKwYB
BQUHAwQGCisGAQQBgjcUAgIwHQYDVR0OBBYEFNbN/f5g73ju85hEKNhyrSnUFuj1MB8GA1Ud
IwQYMBaAFNP74E3kTYiF9FGpb3l16cApIS4TMCYGA1UdEQQfMB2BG211bmRlcmxAdG50LnVu
aS1oYW5ub3Zlci5kZTB5BgNVHR8EcjBwMDagNKAyhjBodHRwOi8vY2RwMS5wY2EuZGZuLmRl
L3VoLWNhL3B1Yi9jcmwvZ19jYWNybC5jcmwwNqA0oDKGMGh0dHA6Ly9jZHAyLnBjYS5kZm4u
ZGUvdWgtY2EvcHViL2NybC9nX2NhY3JsLmNybDCBlAYIKwYBBQUHAQEEgYcwgYQwQAYIKwYB
BQUHMAKGNGh0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvdWgtY2EvcHViL2NhY2VydC9nX2NhY2Vy
dC5jcnQwQAYIKwYBBQUHMAKGNGh0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvdWgtY2EvcHViL2Nh
Y2VydC9nX2NhY2VydC5jcnQwDQYJKoZIhvcNAQEFBQADggEBABGj4fM8+KQFHi1zsbYO+1xd
miP90lcjMM7Dmw1NrxKfJqggLOhPvLlpgqUS0IXvwdMVLJ1JdhbwBDcOxU7/5Za3MbUCBnDA
KpbddjNq7hWkDtp/eZ+0OugrqWAJkEpfyx5/pkFgci84JJG/lVvFKAhhwcUmpcukkM4GQrZC
UvC+PonYkeXrR8TOB6+zdVXArbApyHTQAvofGZiTkvEJ+/8snMS/qGHtlaj4KaeHLfT/Kqj8
6FoZYXUwbrQTmUHfR0X634PijYg4s0GvDF3CzeNdbmFZll7ODzSKG3Acwl/GkgHc1uAYdn4U
l1aHdZAHGLz4uyM/ep+QstVI/xsFHvoxggNoMIIDZAIBATBvMGcxCzAJBgNVBAYTAkRFMSYw
JAYDVQQKEx1MZWlibml6IFVuaXZlcnNpdGFldCBIYW5ub3ZlcjENMAsGA1UECxMEUlJaTjEh
MB8GA1UEAxMYQ0EgZGVyIExVSCAoVUgtQ0EpIC0gRzAzAgQQv8f+MAkGBSsOAwIaBQCgggHO
MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTEzMDQwMjEyMDEz
N1owIwYJKoZIhvcNAQkEMRYEFL6AeuQHuCJ0+JDrBvO0SQJuZ0ClMGwGCSqGSIb3DQEJDzFf
MF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgIC
AIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwfgYJKwYBBAGCNxAE
MXEwbzBnMQswCQYDVQQGEwJERTEmMCQGA1UEChMdTGVpYm5peiBVbml2ZXJzaXRhZXQgSGFu
bm92ZXIxDTALBgNVBAsTBFJSWk4xITAfBgNVBAMTGENBIGRlciBMVUggKFVILUNBKSAtIEcw
MwIEEL/H/jCBgAYLKoZIhvcNAQkQAgsxcaBvMGcxCzAJBgNVBAYTAkRFMSYwJAYDVQQKEx1M
ZWlibml6IFVuaXZlcnNpdGFldCBIYW5ub3ZlcjENMAsGA1UECxMEUlJaTjEhMB8GA1UEAxMY
Q0EgZGVyIExVSCAoVUgtQ0EpIC0gRzAzAgQQv8f+MA0GCSqGSIb3DQEBAQUABIIBAECPtq4H
zrMSIwBcluZHhjr+IuR892W2m6o3cOr/N0keD67bzTYwNvRwBBkzUk609bdJk89wPbVWLFNM
oaC2EXbsVO+AVivKdvJIRMR1yrXyrXzvsdEOdDMQWVeJMMUKqevTiH//xValRzdxT4dRGBLn
uDtfB17Q4mQVGoFGc0jijDxEzNffw2sfVzTpQlOkWQ1SGsqXdhRYQ8krLj8TSLt18QtZDejb
2oN5ma98lbuN0Dk4fnoeQOb25ckmUzTVltTBCp7g1Ncn00BnbIbTn+KwfRTFNCefg2c+k+ul
6y52J430LtaeUSaZLr7zlqt6MTOTVzv4EVbfSqkwCvbOG2oAAAAAAAA=
--------------ms080501080902080706070802--
