Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab3JIW03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:26:29 -0400
Received: from mout.gmx.net ([212.227.17.21]:56856 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423Ab3JIW02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:26:28 -0400
Message-ID: <5255D810.1040702@gmx.com>
Date: Thu, 10 Oct 2013 00:26:24 +0200
From: Martin Nyhus <martin.nyhus@gmx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Dave Airlie <airlied@redhat.com>, nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Nouveau] Panic in nouveau on resume after 5addcf0a
References: <5255AFFA.60104@gmx.com> <CAPM=9tzSNjingreRyVPaHXF4zf6AgaEX_YoqJj7rFmFgwkKQXw@mail.gmail.com>
In-Reply-To: <CAPM=9tzSNjingreRyVPaHXF4zf6AgaEX_YoqJj7rFmFgwkKQXw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:kmIODAu7UoTi54DCvXCzmtTqr963jFIY956ahvmwOHHi0na+oGn
 NHR1kFtGnby9Fd2ZNT+IN7OEplLLKhdrt22qOjhVE2/WjVFGE90SGuFteLONJXszlbNgR1/
 xqb9rtfLkBzsuW1RiDbd+7ymBLIJ9P6u5a/L7kQ5lvHo83cSdZU2/QgoPnQnJ5s2QJBVRmi
 ey/fzhHqj/BDYR2Xhl6kA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 11:34 PM, Dave Airlie wrote:
> On Thu, Oct 10, 2013 at 5:35 AM, Martin Nyhus <martin.nyhus@gmx.com> wrote:
>> After 5addcf0a (nouveau: add runtime PM support (v0.9)) I'm getting kernel
>> panics immediately after resuming from suspend. Unfortunately it happens so
>> early that I don't get any more info than the blinking keyboard lights...
>>
>> The nouveau tree still panics up to 2fb9d6c, which fails before I can test
>> it.
>
> Looks like you've got bigger problems here though, the chip doesn't
> seem to initialise properly at all.
>
> does it s/r okay with nouveau.runpm=0 on the command line?

No, it still panics on resume (aa4cf96 from nouveau tree).

I've included dmesg output again since it seems to find the vbios image 
earlier than before (acpi vs platform), but that might be due to 
different kernel versions, not 100% which one I got the last log from.

Martin


$ dmesg | grep nouveau
[    0.000000] Command line: 
BOOT_IMAGE=/vmlinuz-3.12.0-rc3-00024-gaa4cf96 
root=/dev/mapper/fedora_anthea-root ro rd.lvm.lv=fedora_anthea/root 
rd.md=0 rd.dm=0 vconsole.keymap=no 
rd.luks.uuid=luks-f3e174cb-3b82-4283-90e7-6fef94e72d3a 
vconsole.font=latarcyrheb-sun16 rd.lvm.lv=fedora_anthea/swap rhgb quiet 
LANG=en_US.UTF-8 nouveau.runpm=0
[    0.000000] Kernel command line: 
BOOT_IMAGE=/vmlinuz-3.12.0-rc3-00024-gaa4cf96 
root=/dev/mapper/fedora_anthea-root ro rd.lvm.lv=fedora_anthea/root 
rd.md=0 rd.dm=0 vconsole.keymap=no 
rd.luks.uuid=luks-f3e174cb-3b82-4283-90e7-6fef94e72d3a 
vconsole.font=latarcyrheb-sun16 rd.lvm.lv=fedora_anthea/swap rhgb quiet 
LANG=en_US.UTF-8 nouveau.runpm=0
[    2.499656] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0e71f0a2
[    2.499659] nouveau  [  DEVICE][0000:01:00.0] Chipset: GK107 (NVE7)
[    2.499660] nouveau  [  DEVICE][0000:01:00.0] Family : NVE0
[    2.504978] nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for 
image...
[    2.553165] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
[    2.553168] nouveau  [   VBIOS][0000:01:00.0] checking PROM for image...
[    2.553245] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
[    2.553248] nouveau  [   VBIOS][0000:01:00.0] checking ACPI for image...
[    2.746196] nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
[    2.746199] nouveau  [   VBIOS][0000:01:00.0] using image from ACPI
[    2.746288] nouveau  [   VBIOS][0000:01:00.0] BIT signature found
[    2.746291] nouveau  [   VBIOS][0000:01:00.0] version 80.07.95.00.07
[    2.832854] nouveau 0000:01:00.0: irq 43 for MSI/MSI-X
[    2.832875] nouveau  [     PMC][0000:01:00.0] MSI interrupts enabled
[    2.832957] nouveau  [     PFB][0000:01:00.0] RAM type: DDR3
[    2.832959] nouveau  [     PFB][0000:01:00.0] RAM size: 2048 MiB
[    2.832960] nouveau  [     PFB][0000:01:00.0]    ZCOMP: 0 tags
[    2.870677] nouveau  [  PTHERM][0000:01:00.0] FAN control: none / 
external
[    2.870685] nouveau  [  PTHERM][0000:01:00.0] fan management: disabled
[    2.870737] nouveau  [  PTHERM][0000:01:00.0] internal sensor: yes
[    2.904920] nouveau E[    PBUS][0000:01:00.0] MMIO read of 0x00000000 
FAULT at 0x300000 [ IBUS ]
[    2.905631] nouveau  [     DRM] VRAM: 2048 MiB
[    2.905633] nouveau  [     DRM] GART: 1048576 MiB
[    2.905637] nouveau E[     DRM] Pointer to TMDS table invalid
[    2.905664] nouveau  [     DRM] DCB version 4.0
[    2.905666] nouveau E[     DRM] Pointer to flat panel table invalid
[    2.906153] nouveau  [     DRM] ACPI backlight interface available, 
not registering our own
[    2.906157] nouveau W[     DRM] voltage table 0x50 unknown
[    2.906162] nouveau  [     DRM] 2 available performance level(s)
[    2.906165] nouveau  [     DRM] 1: core 202MHz shader 405MHz memory 
405MHz voltage 490mV
[    2.906167] nouveau  [     DRM] 3: core 450MHz shader 901MHz memory 
1080MHz voltage 580mV
[    2.906169] nouveau  [     DRM] c:
[    2.918550] nouveau  [     DRM] MM: using COPY for buffer copies
[    2.918555] [drm] Initialized nouveau 1.1.1 20120801 for 0000:01:00.0 
on minor 0
[   54.136097] nouveau E[    PBUS][0000:01:00.0] MMIO write of 
0x00000000 FAULT at 0x418880 [ IBUS ]
[   54.136153] nouveau E[   PIBUS][0000:01:00.0] GPC0: 0x419eb4 
0xbadf1000 (0x3800820c)
[   56.138049] nouveau E[  PGRAPH][0000:01:00.0] HUB_INIT timed out
[   56.138058] nouveau E[  PGRAPH][0000:01:00.0] 409000 - done 0x00000244
[   56.138068] nouveau E[  PGRAPH][0000:01:00.0] 409000 - stat 
0x00000000 0x00000000 0x00000000 0x00000000
[   56.138078] nouveau E[  PGRAPH][0000:01:00.0] 409000 - stat 
0x00000000 0x00000000 0x00000002 0x00000009
[   56.138082] nouveau E[  PGRAPH][0000:01:00.0] 502000 - done 0x00000300
[   56.138087] nouveau E[  PGRAPH][0000:01:00.0] 502000 - stat 
0x00000000 0x00000000 0x00000000 0x00000000
[   56.138092] nouveau E[  PGRAPH][0000:01:00.0] 502000 - stat 
0x00000000 0x00000000 0x00000000 0x00000000
[   56.138095] nouveau E[  PGRAPH][0000:01:00.0] init failed, -16
