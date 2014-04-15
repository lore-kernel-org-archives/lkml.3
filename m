Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbaDOJ3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:29:08 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:52542
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751169AbaDOJ3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:29:04 -0400
X-WSS-ID: 0N42FO6-08-6MO-02
X-M-MSG: 
Message-ID: <534CFBD7.3070604@amd.com>
Date: Tue, 15 Apr 2014 11:28:55 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, <dri-devel@lists.freedesktop.org>
CC: Alex Deucher <alexander.deucher@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: 15-rc1: radeon modesetting fails
References: <20140415070204.GA4806@pd.tnic>
In-Reply-To: <20140415070204.GA4806@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.152.106]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(377424004)(189002)(199002)(52314003)(81542001)(15202345003)(92566001)(92726001)(59896001)(20776003)(47776003)(65956001)(23756003)(65816999)(83506001)(65806001)(80022001)(87936001)(31966008)(85852003)(81342001)(74502001)(74662001)(83072002)(15975445006)(86362001)(64126003)(84676001)(77982001)(575784001)(33656001)(46102001)(44976005)(80976001)(19580395003)(83322001)(19580405001)(97736001)(4396001)(76482001)(36756003)(77096999)(50986999)(99396002)(2009001)(76176999)(54356999)(50466002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR02MB113;H:atltwp02.amd.com;FPR:DC69F2CD.A1D2DB21.2DE191A8.4F1E5D92.20495;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0182DBBB05
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

that's a known issue and should be fixed in the next rc, see this 
bugreport: https://bugs.freedesktop.org/show_bug.cgi?id=77009

You might also want to try my branch with 3.15 fixes which includes the 
necessary patch for this: 
http://cgit.freedesktop.org/~deathsimple/linux/log/?h=drm-fixes-3.15-wip

Let me know if that branch works for you or not.

Regards,
Christian.

Am 15.04.2014 09:02, schrieb Borislav Petkov:
> Hi guys,
>
> so I'm booting 15-rc1 + tip/master and around the time modesetting gets
> initialized, the screen blanks and on it appears a message from the
> monitors:
>
> "The current input timing is not supported by the monitor display.
> Please change your input timing to 1920x1200@60Hz or any other monitor
> listed timing as per the monitor specifications."
>
> The box is still responsive, I can reboot it with Ctrl-Alt-Del but
> screens are blank.
>
> If I boot with radeon.modeset=0, I see the normal nomodeset big letters
> on the console and not very optimal screen resolution.
>
> Diffing drm init chatter from dmesg shows only this:
>
> --- /tmp/working        2014-04-15 08:40:21.979985352 +0200
> +++ /tmp/b0rked 2014-04-15 08:40:11.983985364 +0200
> @@ -44,4 +44,5 @@
>   [drm]    pitch is 7680
>   fbcon: radeondrmfb (fb0) is primary device
>   radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
> -[drm] Initialized radeon 2.37.0 20080528 for 0000:01:00.0 on minor 0
> +[drm] Initialized radeon 2.38.0 20080528 for 0000:01:00.0 on minor 0
> +
>
> Below is the whole thing, btw.
>
> Anyway, if you guys have any ideas, I'm all ears. Otherwise, would a quick
> bisect on the 59 patches touching drivers/gpu/drm/radeon/ make sense?
>
> git log --oneline v3.14.. drivers/gpu/drm/radeon/ | wc -l
> 59
>
> Thanks.
>
> [drm] Initialized drm 1.1.0 20060810
> [drm] radeon kernel modesetting enabled.
> [drm] initializing kernel modesetting (RV635 0x1002:0x9598 0x1043:0x01DA).
> [drm] register mmio base: 0xFEA20000
> [drm] register mmio size: 65536
> [drm] Detected VRAM RAM=512M, BAR=256M
> [drm] RAM width 128bits DDR
> [drm] radeon: 512M of VRAM memory ready
> [drm] radeon: 512M of GTT memory ready.
> [drm] Loading RV635 Microcode
> [drm] Internal thermal controller without fan control
> [drm] radeon: power management initialized
> [drm] GART: num cpu pages 131072, num gpu pages 131072
> [drm] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0
> [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
> [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [drm] Driver supports precise vblank timestamp query.
> [drm] radeon: irq initialized.
> [drm] ring test on 0 succeeded in 0 usecs
> [drm] ib test on ring 0 succeeded in 0 usecs
> [drm] Radeon Display Connectors
> [drm] Connector 0:
> [drm]   DVI-I-1
> [drm]   HPD1
> [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
> [drm]   Encoders:
> [drm]     DFP1: INTERNAL_UNIPHY
> [drm]     CRT2: INTERNAL_KLDSCP_DAC2
> [drm] Connector 1:
> [drm]   DIN-1
> [drm]   Encoders:
> [drm]     TV1: INTERNAL_KLDSCP_DAC2
> [drm] Connector 2:
> [drm]   DVI-I-2
> [drm]   HPD2
> [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
> [drm]   Encoders:
> [drm]     CRT1: INTERNAL_KLDSCP_DAC1
> [drm]     DFP2: INTERNAL_KLDSCP_LVTMA
> [drm] fb mappable at 0xC0141000
> [drm] vram apper at 0xC0000000
> [drm] size 9216000
> [drm] fb depth is 24
> [drm]    pitch is 7680
> fbcon: radeondrmfb (fb0) is primary device
> radeon 0000:01:00.0: fb0: radeondrmfb frame buffer device
> [drm] Initialized radeon 2.38.0 20080528 for 0000:01:00.0 on minor 0
>

