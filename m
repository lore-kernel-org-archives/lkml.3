Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab3HFQJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 12:09:08 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:53142 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab3HFQJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 12:09:06 -0400
Message-ID: <52011FA5.9000406@linaro.org>
Date: Tue, 06 Aug 2013 18:09:09 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: monstr@monstr.eu
CC: Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?B?U8O2cmVuIEJyaW5rbWFu?= =?UTF-8?B?bg==?= 
	<soren.brinkmann@xilinx.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <51F77D93.4030505@linaro.org> <51F97842.6050200@linaro.org> <068436c6-ff98-428f-8875-bb1c6f86466b@TX2EHSMHS008.ehs.local> <51F97CE3.9030306@linaro.org> <15e19315-ce88-4d3c-bad9-0a37d9e52f6b@CO1EHSMHS007.ehs.local> <51F99747.4060901@linaro.org> <a48f159a-e88c-42fa-b76b-662302d3a585@AM1EHSMHS003.ehs.local> <51FA9AE8.1060004@linaro.org> <1c83c081-60c6-49e3-a85c-f64dd5be0e60@CH1EHSMHS030.ehs.local> <51FA9F54.3060704@linaro.org> <712d31e9-3584-48e1-aa9f-55bc94fa62c9@DB9EHSMHS001.ehs.local> <5200B7FE.4000306@linaro.org> <e43ebbd7-f520-4c66-bc8c-71a1122226ad@CO9EHSMHS020.ehs.local> <5200EC4C.5090202@linaro.org> <07cc684f-1d5c-44d7-b25c-6314efea4c58@CO9EHSMHS022.ehs.local> <5200F553.6000200@linaro.org> <5200F7C2.8090802@monstr.eu>
In-Reply-To: <5200F7C2.8090802@monstr.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 03:18 PM, Michal Simek wrote:

[ ... ]

>>>>> Soren: Are you able to replicate this issue on QEMU?
>>>>> If yes, it should be the best if you can provide Qemu, kernel .config/
>>>>> rootfs and simple manual to Daniel how to reach that fault.
>>>>
>>>> I tried to download qemu for zynq but it fails:
>>>>
>>>> git clone git://git.xilinx.com/qemu-xarm.git
>>>> Cloning into 'qemu-xarm'...
>>>> fatal: The remote end hung up unexpectedly
>>>
>>> Not sure which site have you found but
>>> it should be just qemu.git
>>> https://github.com/Xilinx/qemu
>>>
>>> or github clone.
>>
>> Ok, cool I was able to clone it.
>>
>>>> I am also looking for the option specified for the kernel:
>>>>
>>>> "The kernel needs to be built with this feature turned on (in
>>>> menuconfig, System Type->Xilinx Specific Features -> Device Tree At
>>>> Fixed Address)."
>>
>> Ok.
>>
>>> This also sound like a very ancient tree.
>>> This is the latest kernel tree - master-next is the latest devel branch.
>>> https://github.com/Xilinx/linux-xlnx
>>
>> Ok, cool. I have the right one.

Following the documentation, I was able to boot a kernel with qemu for
the linux-xlnx and qemu-xilinx.

But this kernel is outdated regarding the upstream one, so I tried to
boot a 3.11-rc4 kernel without success, I did the following:

I used the default config file from linux-xlnx for the upstream kernel.

I compiled the kernel with:

make -j 5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-
UIMAGE_LOADADDR=0x8000 uImage

I generated the dtb with:

make -j 5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- dtbs

For qemu, I started qemu with:

./arm-softmmu/qemu-system-arm -M arm-generic-fdt -nographic -smp 2
-machine linux=on -serial mon:stdio -dtb zynq-zed.dtb -kernel
kernel/zImage -initrd filesystem/ramdisk.img

I tried with the dtb available for the upstream kernel:

zynq-zc706.dtb, zynq-zc702.dtb and zynq-zed.dtb

Did I miss something ?

Thanks
  -- Daniel



>>
>>> Or there should be an option to use the latest kernel from kernel.org.
>>> (I think Soren is using it)
>>>
>>> Zynq is the part of multiplatfrom kernel and cadence ttc is there,
>>> dts is also in the mainline kernel.
>>>
>>>> ps : apart that, well documented website !
>>>
>>> Can you send me the link to it?
>>
>> http://xilinx.wikidot.com/zynq-qemu
>> http://xilinx.wikidot.com/zynq-linux
> 
> I will find out information why it is still there.
> I think it was moved to the new location.
> 
>>
>>> This should be the main page for it.
>>> http://www.wiki.xilinx.com/


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

