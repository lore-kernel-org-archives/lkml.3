Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaDUUiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 16:38:04 -0400
Received: from know-smtprelay-omc-8.server.virginmedia.net ([80.0.253.72]:39150
	"EHLO know-smtprelay-omc-8.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbaDUUh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 16:37:59 -0400
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Apr 2014 16:37:58 EDT
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=TM7LSjVa c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=J0QyKEt1u0cA:10 a=Yn-dKibU-kAA:10
 a=uObrxnre4hsA:10 a=NLZqzBF-AAAA:8 a=jh36NzyKYd1uI0VlFxEA:9 a=QEXdDO2ut3YA:10
 a=K8SepNMI1zTernY16KgA:9 a=j3EwMCcemMy67BjY:21 a=5oI2TD4UmBTYYoxD:21
 a=CjuIK1q_8ugA:10 a=iA_knvcy-yWr0UIWfcsA:9 a=C8NwO-8kTnitODnU:21
 a=9mZseF_5Kyyj76nf:21
Date: Mon, 21 Apr 2014 21:32:08 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: linux-kernel@vger.kernel.org
Cc: Alex Deucher <alexdeucher@gmail.com>
Subject: 3.15.0-rc2 radeon HD 7480D [Aruba] blank display
Message-ID: <20140421203207.GA27025@milliways>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZwgA9U+XZDXt4+m+"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZwgA9U+XZDXt4+m+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

 I've just built 3.15.0-rc2 on this box, and discovered that I get a
blank screen.  The boot appears to complete (it sends me information
from SMART which is from my last bootscript), and it responds to
MagicSysRQ to reboot.  I tried to login and run startx, but that
didn't seem to make any difference - possibly something went wrong,
it wasn't in my history when I booted a good kernel.

 This machine uses a regular old VGA cable to connect it, the
following lines in dmesg make me think it has chosen the wrong
connector:

Apr 21 19:32:45 bluesbreaker kernel: [    1.273246]
[drm:radeon_dp_link_train_cr] *ERROR* displayport link status failed
Apr 21 19:32:45 bluesbreaker kernel: [    1.273247]
[drm:radeon_dp_link_train_cr] *ERROR* clock recovery failed
Apr 21 19:32:45 bluesbreaker kernel: [    1.295116] Console:
switching to colour frame buffer device 85x34

 On a boot with 3.14.0 and earlier I get a different console size -
Apr 21 20:42:44 bluesbreaker kernel: [    1.445992] Console:
switching to colour frame buffer device 133x54

 My console font is 12x22, and my screen is 1600x1200 but it looks
as if 3.15-rc2 has fallen back to trying to use 1024x768.

 I'm attaching what look like the relevant parts of the messages
from the system logs for 3.15-rc2 and 3.14.0.

 Any ideas, please ?  This is an AMD A4-5300 APU and not the world's
fastest machine for bisecting :-(

ĸen
-- 
das eine Mal als Tragödie, dieses Mal als Farce

--ZwgA9U+XZDXt4+m+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="drm-aruba-3.15-rc2"

Apr 21 20:56:19 bluesbreaker kernel: [    0.766847] [drm] Initialized drm 1.1.0 20060810
Apr 21 20:56:19 bluesbreaker kernel: [    0.766901] [drm] radeon kernel modesetting enabled.
Apr 21 20:56:19 bluesbreaker kernel: [    0.767261] [drm] initializing kernel modesetting (ARUBA 0x1002:0x9993 0x1002:0x9993).
Apr 21 20:56:19 bluesbreaker kernel: [    0.767324] [drm] register mmio base: 0xFEF00000
Apr 21 20:56:19 bluesbreaker kernel: [    0.767357] [drm] register mmio size: 262144
Apr 21 20:56:19 bluesbreaker kernel: [    0.767441] ATOM BIOS: 113
Apr 21 20:56:19 bluesbreaker kernel: [    0.767558] radeon 0000:00:01.0: VRAM: 512M 0x0000000000000000 - 0x000000001FFFFFFF (512M used)
Apr 21 20:56:19 bluesbreaker kernel: [    0.767596] radeon 0000:00:01.0: GTT: 1024M 0x0000000020000000 - 0x000000005FFFFFFF
Apr 21 20:56:19 bluesbreaker kernel: [    0.767633] [drm] Detected VRAM RAM=512M, BAR=256M
Apr 21 20:56:19 bluesbreaker kernel: [    0.768866] [drm] RAM width 64bits DDR
Apr 21 20:56:19 bluesbreaker kernel: [    0.768943] [TTM] Zone  kernel: Available graphics memory: 1708830 kiB
Apr 21 20:56:19 bluesbreaker kernel: [    0.768976] [TTM] Initializing pool allocator
Apr 21 20:56:19 bluesbreaker kernel: [    0.769013] [TTM] Initializing DMA pool allocator
Apr 21 20:56:19 bluesbreaker kernel: [    0.769061] [drm] radeon: 512M of VRAM memory ready
Apr 21 20:56:19 bluesbreaker kernel: [    0.769094] [drm] radeon: 1024M of GTT memory ready.
Apr 21 20:56:19 bluesbreaker kernel: [    0.769140] [drm] Loading ARUBA Microcode
Apr 21 20:56:19 bluesbreaker kernel: [    0.769173] [drm] Internal thermal controller without fan control
Apr 21 20:56:19 bluesbreaker kernel: [    0.769407] [drm] radeon: dpm initialized
Apr 21 20:56:19 bluesbreaker kernel: [    0.769611] [drm] GART: num cpu pages 262144, num gpu pages 262144
Apr 21 20:56:19 bluesbreaker kernel: [    0.779832] [drm] PCIE GART of 1024M enabled (table at 0x0000000000276000).
Apr 21 20:56:19 bluesbreaker kernel: [    0.779985] radeon 0000:00:01.0: WB enabled
Apr 21 20:56:19 bluesbreaker kernel: [    0.780020] radeon 0000:00:01.0: fence driver on ring 0 use gpu addr 0x0000000020000c00 and cpu addr 0xffff8800994f7c00
Apr 21 20:56:19 bluesbreaker kernel: [    0.780787] radeon 0000:00:01.0: fence driver on ring 5 use gpu addr 0x0000000000075a18 and cpu addr 0xffffc90010235a18
Apr 21 20:56:19 bluesbreaker kernel: [    0.780826] radeon 0000:00:01.0: fence driver on ring 1 use gpu addr 0x0000000020000c04 and cpu addr 0xffff8800994f7c04
Apr 21 20:56:19 bluesbreaker kernel: [    0.780864] radeon 0000:00:01.0: fence driver on ring 2 use gpu addr 0x0000000020000c08 and cpu addr 0xffff8800994f7c08
Apr 21 20:56:19 bluesbreaker kernel: [    0.780902] radeon 0000:00:01.0: fence driver on ring 3 use gpu addr 0x0000000020000c0c and cpu addr 0xffff8800994f7c0c
Apr 21 20:56:19 bluesbreaker kernel: [    0.780941] radeon 0000:00:01.0: fence driver on ring 4 use gpu addr 0x0000000020000c10 and cpu addr 0xffff8800994f7c10
Apr 21 20:56:19 bluesbreaker kernel: [    0.780980] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
Apr 21 20:56:19 bluesbreaker kernel: [    0.781013] [drm] Driver supports precise vblank timestamp query.
Apr 21 20:56:19 bluesbreaker kernel: [    0.781061] radeon 0000:00:01.0: irq 41 for MSI/MSI-X
Apr 21 20:56:19 bluesbreaker kernel: [    0.781072] radeon 0000:00:01.0: radeon: using MSI.
Apr 21 20:56:19 bluesbreaker kernel: [    0.781374] [drm] radeon: irq initialized.
Apr 21 20:56:19 bluesbreaker kernel: [    0.800502] [drm] ring test on 0 succeeded in 2 usecs
Apr 21 20:56:19 bluesbreaker kernel: [    0.800596] [drm] ring test on 3 succeeded in 2 usecs
Apr 21 20:56:19 bluesbreaker kernel: [    0.800634] [drm] ring test on 4 succeeded in 1 usecs
Apr 21 20:56:19 bluesbreaker kernel: [    0.856329] [drm] ring test on 5 succeeded in 1 usecs
Apr 21 20:56:19 bluesbreaker kernel: [    0.876237] [drm] UVD initialized successfully.
Apr 21 20:56:19 bluesbreaker kernel: [    0.877136] [drm] ib test on ring 0 succeeded in 0 usecs
Apr 21 20:56:19 bluesbreaker kernel: [    0.877702] [drm] ib test on ring 3 succeeded in 0 usecs
Apr 21 20:56:19 bluesbreaker kernel: [    0.878266] [drm] ib test on ring 4 succeeded in 1 usecs
Apr 21 20:56:19 bluesbreaker kernel: [    0.899250] [drm] ib test on ring 5 succeeded
Apr 21 20:56:19 bluesbreaker kernel: [    0.920172] [drm] Radeon Display Connectors
Apr 21 20:56:19 bluesbreaker kernel: [    0.920209] [drm] Connector 0:
Apr 21 20:56:19 bluesbreaker kernel: [    0.920243] [drm]   HDMI-A-1
Apr 21 20:56:19 bluesbreaker kernel: [    0.920277] [drm]   HPD1
Apr 21 20:56:19 bluesbreaker kernel: [    0.920310] [drm]   DDC: 0x6530 0x6530 0x6534 0x6534 0x6538 0x6538 0x653c 0x653c
Apr 21 20:56:19 bluesbreaker kernel: [    0.920347] [drm]   Encoders:
Apr 21 20:56:19 bluesbreaker kernel: [    0.920379] [drm]     DFP1: INTERNAL_UNIPHY2
Apr 21 20:56:19 bluesbreaker kernel: [    0.920412] [drm] Connector 1:
Apr 21 20:56:19 bluesbreaker kernel: [    0.920444] [drm]   VGA-1
Apr 21 20:56:19 bluesbreaker kernel: [    0.920476] [drm]   HPD2
Apr 21 20:56:19 bluesbreaker kernel: [    0.920508] [drm]   DDC: 0x6540 0x6540 0x6544 0x6544 0x6548 0x6548 0x654c 0x654c
Apr 21 20:56:19 bluesbreaker kernel: [    0.920545] [drm]   Encoders:
Apr 21 20:56:19 bluesbreaker kernel: [    0.920576] [drm]     CRT1: INTERNAL_UNIPHY2
Apr 21 20:56:19 bluesbreaker kernel: [    0.920609] [drm]     CRT1: NUTMEG
Apr 21 20:56:19 bluesbreaker kernel: [    0.920641] [drm] Connector 2:
Apr 21 20:56:19 bluesbreaker kernel: [    0.920674] [drm]   DVI-D-1
Apr 21 20:56:19 bluesbreaker kernel: [    0.920705] [drm]   HPD3
Apr 21 20:56:19 bluesbreaker kernel: [    0.920736] [drm]   DDC: 0x6550 0x6550 0x6554 0x6554 0x6558 0x6558 0x655c 0x655c
Apr 21 20:56:19 bluesbreaker kernel: [    0.920773] [drm]   Encoders:
Apr 21 20:56:19 bluesbreaker kernel: [    0.920804] [drm]     DFP2: INTERNAL_UNIPHY
Apr 21 20:56:19 bluesbreaker kernel: [    1.173963] [drm] fb mappable at 0xC047A000
Apr 21 20:56:19 bluesbreaker kernel: [    1.173997] [drm] vram apper at 0xC0000000
Apr 21 20:56:19 bluesbreaker kernel: [    1.174027] [drm] size 3145728
Apr 21 20:56:19 bluesbreaker kernel: [    1.174056] [drm] fb depth is 24
Apr 21 20:56:19 bluesbreaker kernel: [    1.174085] [drm]    pitch is 4096
Apr 21 20:56:19 bluesbreaker kernel: [    1.174206] fbcon: radeondrmfb (fb0) is primary device
Apr 21 20:56:19 bluesbreaker kernel: [    1.273253] [drm:radeon_dp_link_train_cr] *ERROR* displayport link status failed
Apr 21 20:56:19 bluesbreaker kernel: [    1.273254] [drm:radeon_dp_link_train_cr] *ERROR* clock recovery failed
Apr 21 20:56:19 bluesbreaker kernel: [    1.295093] Console: switching to colour frame buffer device 85x34
Apr 21 20:56:19 bluesbreaker kernel: [    1.296949] radeon 0000:00:01.0: fb0: radeondrmfb frame buffer device
Apr 21 20:56:19 bluesbreaker kernel: [    1.296999] radeon 0000:00:01.0: registered panic notifier
Apr 21 20:56:19 bluesbreaker kernel: [    1.297824] [drm] Initialized radeon 2.38.0 20080528 for 0000:00:01.0 on minor 0


--ZwgA9U+XZDXt4+m+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="drm-aruba-3.14"

Apr 21 20:57:26 bluesbreaker kernel: [    0.887023] [drm] Initialized drm 1.1.0 20060810
Apr 21 20:57:26 bluesbreaker kernel: [    0.887106] [drm] radeon kernel modesetting enabled.
Apr 21 20:57:26 bluesbreaker kernel: [    0.887495] [drm] initializing kernel modesetting (ARUBA 0x1002:0x9993 0x1002:0x9993).
Apr 21 20:57:26 bluesbreaker kernel: [    0.887559] [drm] register mmio base: 0xFEF00000
Apr 21 20:57:26 bluesbreaker kernel: [    0.887590] [drm] register mmio size: 262144
Apr 21 20:57:26 bluesbreaker kernel: [    0.887678] ATOM BIOS: 113
Apr 21 20:57:26 bluesbreaker kernel: [    0.887793] radeon 0000:00:01.0: VRAM: 512M 0x0000000000000000 - 0x000000001FFFFFFF (512M used)
Apr 21 20:57:26 bluesbreaker kernel: [    0.887831] radeon 0000:00:01.0: GTT: 1024M 0x0000000020000000 - 0x000000005FFFFFFF
Apr 21 20:57:26 bluesbreaker kernel: [    0.887868] [drm] Detected VRAM RAM=512M, BAR=256M
Apr 21 20:57:26 bluesbreaker kernel: [    0.887901] [drm] RAM width 64bits DDR
Apr 21 20:57:26 bluesbreaker kernel: [    0.888041] [TTM] Zone  kernel: Available graphics memory: 1708866 kiB
Apr 21 20:57:26 bluesbreaker kernel: [    0.889278] [TTM] Initializing pool allocator
Apr 21 20:57:26 bluesbreaker kernel: [    0.889315] [TTM] Initializing DMA pool allocator
Apr 21 20:57:26 bluesbreaker kernel: [    0.889363] [drm] radeon: 512M of VRAM memory ready
Apr 21 20:57:26 bluesbreaker kernel: [    0.889395] [drm] radeon: 1024M of GTT memory ready.
Apr 21 20:57:26 bluesbreaker kernel: [    0.889438] [drm] Loading ARUBA Microcode
Apr 21 20:57:26 bluesbreaker kernel: [    0.889472] [drm] Internal thermal controller without fan control
Apr 21 20:57:26 bluesbreaker kernel: [    0.889706] [drm] radeon: dpm initialized
Apr 21 20:57:26 bluesbreaker kernel: [    0.889897] [drm] GART: num cpu pages 262144, num gpu pages 262144
Apr 21 20:57:26 bluesbreaker kernel: [    0.903297] [drm] PCIE GART of 1024M enabled (table at 0x0000000000276000).
Apr 21 20:57:26 bluesbreaker kernel: [    0.903450] radeon 0000:00:01.0: WB enabled
Apr 21 20:57:26 bluesbreaker kernel: [    0.903485] radeon 0000:00:01.0: fence driver on ring 0 use gpu addr 0x0000000020000c00 and cpu addr 0xffff880099ae3c00
Apr 21 20:57:26 bluesbreaker kernel: [    0.904254] radeon 0000:00:01.0: fence driver on ring 5 use gpu addr 0x0000000000075a18 and cpu addr 0xffffc90010235a18
Apr 21 20:57:26 bluesbreaker kernel: [    0.904294] radeon 0000:00:01.0: fence driver on ring 1 use gpu addr 0x0000000020000c04 and cpu addr 0xffff880099ae3c04
Apr 21 20:57:26 bluesbreaker kernel: [    0.904333] radeon 0000:00:01.0: fence driver on ring 2 use gpu addr 0x0000000020000c08 and cpu addr 0xffff880099ae3c08
Apr 21 20:57:26 bluesbreaker kernel: [    0.904372] radeon 0000:00:01.0: fence driver on ring 3 use gpu addr 0x0000000020000c0c and cpu addr 0xffff880099ae3c0c
Apr 21 20:57:26 bluesbreaker kernel: [    0.904410] radeon 0000:00:01.0: fence driver on ring 4 use gpu addr 0x0000000020000c10 and cpu addr 0xffff880099ae3c10
Apr 21 20:57:26 bluesbreaker kernel: [    0.904449] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
Apr 21 20:57:26 bluesbreaker kernel: [    0.904482] [drm] Driver supports precise vblank timestamp query.
Apr 21 20:57:26 bluesbreaker kernel: [    0.904532] radeon 0000:00:01.0: irq 41 for MSI/MSI-X
Apr 21 20:57:26 bluesbreaker kernel: [    0.904541] radeon 0000:00:01.0: radeon: using MSI.
Apr 21 20:57:26 bluesbreaker kernel: [    0.904842] [drm] radeon: irq initialized.
Apr 21 20:57:26 bluesbreaker kernel: [    0.923942] [drm] ring test on 0 succeeded in 2 usecs
Apr 21 20:57:26 bluesbreaker kernel: [    0.924035] [drm] ring test on 3 succeeded in 2 usecs
Apr 21 20:57:26 bluesbreaker kernel: [    0.924075] [drm] ring test on 4 succeeded in 1 usecs
Apr 21 20:57:26 bluesbreaker kernel: [    0.979756] [drm] ring test on 5 succeeded in 1 usecs
Apr 21 20:57:26 bluesbreaker kernel: [    0.999659] [drm] UVD initialized successfully.
Apr 21 20:57:26 bluesbreaker kernel: [    1.001669] [drm] ib test on ring 0 succeeded in 0 usecs
Apr 21 20:57:26 bluesbreaker kernel: [    1.002225] [drm] ib test on ring 3 succeeded in 0 usecs
Apr 21 20:57:26 bluesbreaker kernel: [    1.002779] [drm] ib test on ring 4 succeeded in 1 usecs
Apr 21 20:57:26 bluesbreaker kernel: [    1.023780] [drm] ib test on ring 5 succeeded
Apr 21 20:57:26 bluesbreaker kernel: [    1.045574] [drm] Radeon Display Connectors
Apr 21 20:57:26 bluesbreaker kernel: [    1.045609] [drm] Connector 0:
Apr 21 20:57:26 bluesbreaker kernel: [    1.045641] [drm]   HDMI-A-1
Apr 21 20:57:26 bluesbreaker kernel: [    1.045672] [drm]   HPD1
Apr 21 20:57:26 bluesbreaker kernel: [    1.045704] [drm]   DDC: 0x6530 0x6530 0x6534 0x6534 0x6538 0x6538 0x653c 0x653c
Apr 21 20:57:26 bluesbreaker kernel: [    1.045740] [drm]   Encoders:
Apr 21 20:57:26 bluesbreaker kernel: [    1.045772] [drm]     DFP1: INTERNAL_UNIPHY2
Apr 21 20:57:26 bluesbreaker kernel: [    1.045804] [drm] Connector 1:
Apr 21 20:57:26 bluesbreaker kernel: [    1.045836] [drm]   VGA-1
Apr 21 20:57:26 bluesbreaker kernel: [    1.045867] [drm]   HPD2
Apr 21 20:57:26 bluesbreaker kernel: [    1.045898] [drm]   DDC: 0x6540 0x6540 0x6544 0x6544 0x6548 0x6548 0x654c 0x654c
Apr 21 20:57:26 bluesbreaker kernel: [    1.045934] [drm]   Encoders:
Apr 21 20:57:26 bluesbreaker kernel: [    1.045966] [drm]     CRT1: INTERNAL_UNIPHY2
Apr 21 20:57:26 bluesbreaker kernel: [    1.045998] [drm]     CRT1: NUTMEG
Apr 21 20:57:26 bluesbreaker kernel: [    1.046030] [drm] Connector 2:
Apr 21 20:57:26 bluesbreaker kernel: [    1.046061] [drm]   DVI-D-1
Apr 21 20:57:26 bluesbreaker kernel: [    1.046093] [drm]   HPD3
Apr 21 20:57:26 bluesbreaker kernel: [    1.046125] [drm]   DDC: 0x6550 0x6550 0x6554 0x6554 0x6558 0x6558 0x655c 0x655c
Apr 21 20:57:26 bluesbreaker kernel: [    1.046161] [drm]   Encoders:
Apr 21 20:57:26 bluesbreaker kernel: [    1.046192] [drm]     DFP2: INTERNAL_UNIPHY
Apr 21 20:57:26 bluesbreaker kernel: [    1.307550] [drm] fb mappable at 0xC1488000
Apr 21 20:57:26 bluesbreaker kernel: [    1.307584] [drm] vram apper at 0xC0000000
Apr 21 20:57:26 bluesbreaker kernel: [    1.307614] [drm] size 7680000
Apr 21 20:57:26 bluesbreaker kernel: [    1.307643] [drm] fb depth is 24
Apr 21 20:57:26 bluesbreaker kernel: [    1.307672] [drm]    pitch is 6400
Apr 21 20:57:26 bluesbreaker kernel: [    1.307837] fbcon: radeondrmfb (fb0) is primary device
Apr 21 20:57:26 bluesbreaker kernel: [    1.441761] Console: switching to colour frame buffer device 133x54
Apr 21 20:57:26 bluesbreaker kernel: [    1.445997] radeon 0000:00:01.0: fb0: radeondrmfb frame buffer device
Apr 21 20:57:26 bluesbreaker kernel: [    1.446047] radeon 0000:00:01.0: registered panic notifier
Apr 21 20:57:26 bluesbreaker kernel: [    1.446191] [drm] Initialized radeon 2.37.0 20080528 for 0000:00:01.0 on minor 0


--ZwgA9U+XZDXt4+m+--
