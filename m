Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbaESWIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:08:21 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:46290 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaESWIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:08:18 -0400
MIME-Version: 1.0
In-Reply-To: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1398116624-31052-1-git-send-email-srinivas.kandagatla@linaro.org>
Date: Mon, 19 May 2014 15:08:18 -0700
Message-ID: <CAJAp7Oj5e8_zqNsHUxex8pd1zh4_sSzZMvp+67YSE39JDkoLAQ@mail.gmail.com>
Subject: Re: [PATCH RFC 00/12] Add Qualcomm SD Card Controller support.
From: Bjorn Andersson <bjorn@kryo.se>
To: srinivas.kandagatla@linaro.org
Cc: linux-mmc@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        agross@quicinc.com, linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 2:43 PM,  <srinivas.kandagatla@linaro.org> wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
[snip]
>
> This patches are tested in PIO mode on IFC8064 board with both eMMC and
> external SD card. I would appreciate any feedback/suggestions on the overall
> approach.

Hi Srini,

I finally got around to give this series a spin on our APQ8064 based
devices as well. I had a few reported CRC issues on our msm8960 based
devices, but thinks seems functionally "ok".

On APQ8064, the kernel finds the onboard eMMC and when mounting it I
get the following:

[    1.624118] mmc0: new high speed MMC card at address 0001
[    1.627521] mmcblk0: mmc0:0001 MAG2GA 14.5 GiB
[    1.632714] mmcblk0boot0: mmc0:0001 MAG2GA partition 1 2.00 MiB
[    1.636989] mmcblk0boot1: mmc0:0001 MAG2GA partition 2 2.00 MiB
[    1.637393] Freeing unused kernel memory: 332K (c09c6000 - c0a19000)
[    1.663379] mmcblk0: response CRC error sending r/w cmd command,
card status 0xb00
[    1.663659] mmcblk0: error -84 transferring data, sector 30535648,
nr 8, cmd response 0x900, card status 0xb00
[    1.669851] mmcblk0: retrying using single block read
[    1.681534] mmcblk0: response CRC error sending r/w cmd command,
card status 0xb00
[    1.686758]  mmcblk0: p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13
p14 p15 p16 p17 p18 p19 p20 p21 p22 p23 p24 p25 p26
mkdir: can't create directory '/dev': File exists
[    1.712644]  mmcblk0boot1: unknown partition table
[    1.717419]  mmcblk0boot0: unknown partition table
[    2.255625] EXT3-fs (mmcblk0p24): error: couldn't mount because of
unsupported optional features (40)
[    2.256687] EXT2-fs (mmcblk0p24): error: couldn't mount because of
unsupported optional features (40)
[    2.277945] mmcblk0: error -84 transferring data, sector 160824, nr
232, cmd response 0x900, card status 0xb00
[    2.277985] mmcblk0: retrying using single block read
[    2.288518] mmcblk0: response CRC error sending r/w cmd command,
card status 0xb00
[    2.292914] mmcblk0: response CRC error sending r/w cmd command,
card status 0xb00
[    2.300985] mmcblk0: response CRC error sending r/w cmd command,
card status 0xb00
[    2.311787] mmcblk0: response CRC error sending r/w cmd command,
card status 0xb00
[    2.316151] mmcblk0: response CRC error sending r/w cmd command,
card status 0xb00
[    2.322986] mmcblk0: response CRC error sending r/w cmd command,
card status 0xb00
[    2.329640] end_request: I/O error, dev mmcblk0, sector 160853
[    2.337266] end_request: I/O error, dev mmcblk0, sector 160856
[    2.343093] end_request: I/O error, dev mmcblk0, sector 160864
[    2.348826] end_request: I/O error, dev mmcblk0, sector 160872
[    2.354720] end_request: I/O error, dev mmcblk0, sector 160880
[    2.360458] end_request: I/O error, dev mmcblk0, sector 160888
[    2.366346] end_request: I/O error, dev mmcblk0, sector 160896
[    2.372175] end_request: I/O error, dev mmcblk0, sector 160904
[    2.377906] end_request: I/O error, dev mmcblk0, sector 160912
[    2.383802] end_request: I/O error, dev mmcblk0, sector 160920
[    2.393204] EXT4-fs (mmcblk0p24): mounted filesystem with ordered
data mode. Opts: (null)
[    2.407231] EXT3-fs (mmcblk0p26): error: couldn't mount because of
unsupported optional features (40)
[    2.408196] EXT2-fs (mmcblk0p26): error: couldn't mount because of
unsupported optional features (44)
[    2.416686] mmcblk0: response CRC error sending r/w cmd command,
card status 0xb00
[    2.426058] mmcblk0: response CRC error sending r/w cmd command,
card status 0xb00
[    2.446754] mmcblk0: response CRC error sending r/w cmd command,
card status 0xb00
[    2.510905] mmcblk0: response CRC error sending r/w cmd command,
card status 0xb00
[    2.559272] mmcblk0: response CRC error sending r/w cmd command,
card status 0xb00
[    2.622231] mmcblk0: response CRC error sending r/w cmd command,
card status 0xb00
[    2.623297] mmcblk0: error -84 transferring data, sector 5492888,
nr 192, cmd response 0x900, card status 0xb00
[    2.628702] mmcblk0: retrying using single block read
[    2.640005] mmcblk0: response CRC error sending r/w cmd command,
card status 0xb00
[    2.645574] mmcblk0: response CRC error sending r/w cmd command,
card status 0xb00
[    2.652991] mmcblk0: response CRC error sending r/w cmd command,
card status 0xb00
[    2.659765] mmcblk0: response CRC error sending r/w cmd command,
card status 0xb00
[    2.668126] mmcblk0: response CRC error sending r/w cmd command,
card status 0xb00
[    2.674257] JBD2: Failed to read block at offset 283
[    2.681602] JBD2: recovery failed
[    2.686819] EXT4-fs (mmcblk0p26): error loading journal

Any suggestions of what I could do to help you debug this?

Regards,
Bjorn
