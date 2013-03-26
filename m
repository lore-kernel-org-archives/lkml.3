Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890Ab3CZQoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:44:18 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:58166 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab3CZQoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:44:16 -0400
MIME-Version: 1.0
Date: Wed, 27 Mar 2013 00:44:14 +0800
Message-ID: <CAEwRVpO1o0wMxtq5Atuy0isqEu=2767v3BwHxbwRq1NBXbekCg@mail.gmail.com>
Subject: linux-3.8.4: mmc0: error -110 whilst initialising SD card for Realtek
 Semiconductor Co., Ltd. RTS5209 PCI Express Card Reader
From: Teck Choon Giam <giamteckchoon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Wei WANG <wei_wang@realsil.com.cn>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a HP laptop which has a built-in Realtek Semiconductor Co.,
Ltd. RTS5209 PCI Express Card Reader.  Running linux-3.7.9 or
linux-3.7.10 with staging driver aka CONFIG_RTS_PSTOR=m works fine.
However when boot Linux-3.8.4, it is no longer working since the
rts_pstor removed from the staging drivers and replaced by rtsx_pci
with rtsx_pci_ms and rtsx_pci_sdmmc aka CONFIG_MFD_RTSX_PCI=m,
CONFIG_MMC_REALTEK_PCI=m related options if I am correct.

Thanks in advance for anyone to provide assistance or patch for me to
try to resolve this issue.  My system is Scientific Linux 6.3 x86_64
with custom compile kernel.

Related lspci -vvv output for Linux-3.8.4:

13:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd.
RTS5209 PCI Express Card Reader (rev 01)
        Subsystem: Hewlett-Packard Company Device 1657
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 50
        Region 0: Memory at c3500000 (32-bit, non-prefetchable) [size=4K]
        Expansion ROM at c2400000 [disabled] [size=64K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0-,D1+,D2+,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
                Address: 00000000feeff00c  Data: 4192
        Capabilities: [70] Express (v2) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<1us, L1 <8us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+
AuxPwr- TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 unlimited, L1 <64us
                        ClockPM+ Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
                DevCap2: Completion Timeout: Not Supported, TimeoutDis+
                DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
                LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
SpeedDis-, Selectable De-emphasis: -6dB
                         Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-
                         Compliance De-emphasis: -6dB
                LnkSta2: Current De-emphasis Level: -6dB
        Capabilities: [100] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
                AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
        Capabilities: [140] Device Serial Number 00-00-00-01-00-4c-e0-00
        Kernel driver in use: rtsx_pci
        Kernel modules: rtsx_pci

Related lspci -vvv output for Linux-3.7.9:

13:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd.
RTS5209 PCI Express Card Reader (rev 01)
	Subsystem: Hewlett-Packard Company Device 1657
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at c3500000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at c2400000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <1us, L1 <8us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
unlimited, L1 <64us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout+ NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140] Device Serial Number 00-00-00-01-00-4c-e0-00
	Kernel driver in use: rts_pstor
	Kernel modules: rts_pstor

lsmod as below:

Module                  Size  Used by
ntfs                  169779  1
des_generic            16223  0
ecb                     1896  0
md4                     3148  0
sha256_generic          9878  1
md5                     1772  2
nls_utf8                1294  2
cifs                  257810  2
fscache                40946  1 cifs
vfat                    8380  1
fat                    45628  1 vfat
fuse                   61752  0
rfcomm                 29571  4
bridge                 69234  0
stp                     1985  1 bridge
llc                     5097  2 bridge,stp
bnep                   10608  2
autofs4                20912  3
tun                    14344  2
cpufreq_ondemand        6443  8
ipv6                  246195  35 bridge
uinput                  7183  0
iTCO_wdt                5257  0
coretemp                5919  0
acpi_cpufreq            7464  1
mperf                   1396  1 acpi_cpufreq
kvm_intel             118002  0
kvm                   244028  1 kvm_intel
crc32c_intel            1891  0
microcode             109097  0
btusb                  11535  0
bluetooth             167389  24 rfcomm,bnep,btusb
uvcvideo               62721  0
videobuf2_core         23390  1 uvcvideo
videodev              104777  2 uvcvideo,videobuf2_core
media                  12133  2 uvcvideo,videodev
videobuf2_vmalloc       2277  1 uvcvideo
videobuf2_memops        2629  1 videobuf2_vmalloc
pcspkr                  1879  0
i2c_i801                9031  0
lpc_ich                11518  0
mfd_core                3332  1 lpc_ich
sg                     26176  0
arc4                    1910  2
iwldvm                108962  0
mac80211              206386  1 iwldvm
xhci_hcd               73266  0
iwlwifi                70480  1 iwldvm
cfg80211              166073  3 iwldvm,mac80211,iwlwifi
rfkill                 17043  4 bluetooth,cfg80211
r8169                  50240  0
mii                     4679  1 r8169
snd_hda_codec_hdmi     25561  1
snd_hda_codec_idt      55398  1
snd_hda_intel          26396  2
snd_hda_codec          86839  3
snd_hda_codec_hdmi,snd_hda_codec_idt,snd_hda_intel
snd_seq                45470  0
snd_seq_device          5691  1 snd_seq
snd_pcm                78531  3 snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec
snd_timer              18194  2 snd_seq,snd_pcm
snd                    63275  12
snd_hda_codec_hdmi,snd_hda_codec_idt,snd_hda_intel,snd_hda_codec,snd_seq,snd_seq_device,snd_pcm,snd_timer
soundcore               6373  1 snd
snd_page_alloc          7695  2 snd_hda_intel,snd_pcm
mei                    27723  0
ac                      3622  0
battery                12114  0
mac_hid                 3510  0
ext4                  268734  2
jbd2                   58613  1 ext4
crc16                   1596  2 bluetooth,ext4
sd_mod                 28206  6
sr_mod                 12718  0
cdrom                  32100  1 sr_mod
aesni_intel            43681  1
ablk_helper             2614  1 aesni_intel
cryptd                  8591  2 aesni_intel,ablk_helper
lrw                     3743  1 aesni_intel
aes_x86_64              7776  1 aesni_intel
xts                     3035  1 aesni_intel
gf128mul                7360  2 lrw,xts
ahci                   21108  4
libahci                22272  1 ahci
libata                179223  2 ahci,libahci
rts_pstor             353322  1
scsi_mod              155350  5 sg,sd_mod,sr_mod,libata,rts_pstor
wmi                     8879  0
i915                  448565  2
button                  5318  1 i915
video                  12381  1 i915
radeon                779482  0
ttm                    67286  1 radeon
drm_kms_helper         35087  2 i915,radeon
drm                   236891  5 i915,radeon,ttm,drm_kms_helper
hwmon                   1704  2 coretemp,radeon
i2c_algo_bit            5071  2 i915,radeon
i2c_core               23351  7
videodev,i2c_i801,i915,radeon,drm_kms_helper,drm,i2c_algo_bit
dm_mirror              12065  0
dm_region_hash          9702  1 dm_mirror
dm_log                  8193  2 dm_mirror,dm_region_hash
dm_mod                 66885  2 dm_mirror,dm_log


Once again, thanks.

Kindest regards,
Giam Teck Choon
