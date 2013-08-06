Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3HFQO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 12:14:56 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:36769
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756151Ab3HFQOr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 12:14:47 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI9371Ic89bh1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de096h8275bh1de097hz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh906i1155h192ch)
Date: Tue, 6 Aug 2013 09:13:32 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <1c83c081-60c6-49e3-a85c-f64dd5be0e60@CH1EHSMHS030.ehs.local>
 <51FA9F54.3060704@linaro.org>
 <712d31e9-3584-48e1-aa9f-55bc94fa62c9@DB9EHSMHS001.ehs.local>
 <5200B7FE.4000306@linaro.org>
 <e43ebbd7-f520-4c66-bc8c-71a1122226ad@CO9EHSMHS020.ehs.local>
 <5200EC4C.5090202@linaro.org>
 <07cc684f-1d5c-44d7-b25c-6314efea4c58@CO9EHSMHS022.ehs.local>
 <5200F553.6000200@linaro.org>
 <5200F7C2.8090802@monstr.eu>
 <52011FA5.9000406@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <52011FA5.9000406@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <fe6d6c61-3460-4f41-830d-f42891f29d1e@VA3EHSMHS022.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 06:09:09PM +0200, Daniel Lezcano wrote:
> On 08/06/2013 03:18 PM, Michal Simek wrote:
> 
> [ ... ]
> 
> >>>>> Soren: Are you able to replicate this issue on QEMU?
> >>>>> If yes, it should be the best if you can provide Qemu, kernel .config/
> >>>>> rootfs and simple manual to Daniel how to reach that fault.
> >>>>
> >>>> I tried to download qemu for zynq but it fails:
> >>>>
> >>>> git clone git://git.xilinx.com/qemu-xarm.git
> >>>> Cloning into 'qemu-xarm'...
> >>>> fatal: The remote end hung up unexpectedly
> >>>
> >>> Not sure which site have you found but
> >>> it should be just qemu.git
> >>> https://github.com/Xilinx/qemu
> >>>
> >>> or github clone.
> >>
> >> Ok, cool I was able to clone it.
> >>
> >>>> I am also looking for the option specified for the kernel:
> >>>>
> >>>> "The kernel needs to be built with this feature turned on (in
> >>>> menuconfig, System Type->Xilinx Specific Features -> Device Tree At
> >>>> Fixed Address)."
> >>
> >> Ok.
> >>
> >>> This also sound like a very ancient tree.
> >>> This is the latest kernel tree - master-next is the latest devel branch.
> >>> https://github.com/Xilinx/linux-xlnx
> >>
> >> Ok, cool. I have the right one.
> 
> Following the documentation, I was able to boot a kernel with qemu for
> the linux-xlnx and qemu-xilinx.
> 
> But this kernel is outdated regarding the upstream one, so I tried to
> boot a 3.11-rc4 kernel without success, I did the following:
> 
> I used the default config file from linux-xlnx for the upstream kernel.
> 
> I compiled the kernel with:
> 
> make -j 5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-
> UIMAGE_LOADADDR=0x8000 uImage
> 
> I generated the dtb with:
> 
> make -j 5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- dtbs
> 
> For qemu, I started qemu with:
> 
> ./arm-softmmu/qemu-system-arm -M arm-generic-fdt -nographic -smp 2
> -machine linux=on -serial mon:stdio -dtb zynq-zed.dtb -kernel
> kernel/zImage -initrd filesystem/ramdisk.img
> 
> I tried with the dtb available for the upstream kernel:
> 
> zynq-zc706.dtb, zynq-zc702.dtb and zynq-zed.dtb
> 
> Did I miss something ?

Unfortunately the public github QEMU is behind our internal development.
IIRC, there were a couple of DT compatible strings QEMU didn't know.
Those are sometimes removed making boot fail/hang.

Are you on IRC? It's probably easier to resolve this in a more direct
way (I'm 'sorenb' on freenode). Otherwise I could give you a few more
instructions for debugging this per mail?

	Sören


