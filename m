Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaH2LaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 07:30:09 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:36688 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaH2LaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 07:30:07 -0400
MIME-Version: 1.0
In-Reply-To: <C4A61A5CA4AD2246942F4BA6F20ACB80435790DF@ALVA-EXMB04.alv.autoliv.int>
References: <20140626151424.GT32514@n2100.arm.linux.org.uk>
	<20140806125550.GO30282@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB804357526C@ALVA-EXMB04.alv.autoliv.int>
	<20140807121248.GY30282@n2100.arm.linux.org.uk>
	<20140808180900.GG30282@n2100.arm.linux.org.uk>
	<C4A61A5CA4AD2246942F4BA6F20ACB8043576356@ALVA-EXMB04.alv.autoliv.int>
	<CAOMZO5B8GR+ABBoJ=dJcFqw3Wagfaip7HM+C1FTz+aE4CmqiPw@mail.gmail.com>
	<C4A61A5CA4AD2246942F4BA6F20ACB80435776D3@ALVA-EXMB04.alv.autoliv.int>
	<CAOMZO5B7FgzB7ThVyV2Vk7wTwYgjRWjEnkkAN5uwwKMaBKq1yg@mail.gmail.com>
	<C4A61A5CA4AD2246942F4BA6F20ACB8043577770@ALVA-EXMB04.alv.autoliv.int>
	<53F11FF6.8030303@gmail.com>
	<CAOMZO5CDvQDD7gVLFStwv4MPrUyqZE3sEDZwb0gukkXujYG-6Q@mail.gmail.com>
	<53F2E89B.80009@gmail.com>
	<53F5BE3D.5070209@gmail.com>
	<CAOMZO5A3CgaVCKxNDG-zEdwprYdRDXD_XZ2ikW+mns-iieYHsg@mail.gmail.com>
	<53F71D1B.8090004@gmail.com>
	<C4A61A5CA4AD2246942F4BA6F20ACB8043578CB2@ALVA-EXMB04.alv.autoliv.int>
	<53FDB649.2070506@gmail.com>
	<C4A61A5CA4AD2246942F4BA6F20ACB80435790DF@ALVA-EXMB04.alv.autoliv.int>
Date: Fri, 29 Aug 2014 08:30:05 -0300
Message-ID: <CAOMZO5CY7cDRspdgcPKr0LVBx3PGsBu5jGeQk+_DdVnvL_sSEg@mail.gmail.com>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
From: Fabio Estevam <festevam@gmail.com>
To: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
Cc: Iain Paton <ipaton0@gmail.com>,
        Fredrik Noring <fredrik.noring@autoliv.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mattis,

On Fri, Aug 29, 2014 at 7:57 AM, Mattis Lorentzon
<Mattis.Lorentzon@autoliv.com> wrote:
> Iain,
>
>> Interesting. We obviously have some differences in how we boot, my
>> changes to your config to get it to boot basically amount to reverting the
>> patch you attached and then enabling sata and mmc. So far I've been unable
>> to get your config to fail.
>
> Our version of U-boot doesn't support specifying a device tree separate from
> the kernel, so we append it to the end of the kernel binary. We also enable
> automatic configuration of IP addresses (CONFIG_IP_PNP). Our bootargs are:
> console=ttymxc1,115200
> ip=192.168.2.157:192.168.2.1:192.168.2.1:255.255.255.0:armcard:eth0:on
> earlyprintk enable_wait_mode=off

I suppose that this 'enable_wait_mode=off' is a left over from the
time you used the FSL BSP.

This is not needed in mainline.

>> It would be good to know what makes my config work for you, I don't think
>> I've done anything special with it.
>
> With a couple of modifications (attached) we have been able to get your
> config running on our Zynq boards as well, solving our ethernet issues.
>
> The serial port and ethernet are essentially the only things we use. No disks,
> no graphics, no USB, etc. which is why we tried to reduce the kernel
> configuration to a bare minimum. We have no idea which disabled and/or
> enabled options that are causing the stalls.

It's good to hear you do not have the lockups anymore, but this is
still a big mistery for us as we have not yet understood the root
cause and what is the 'guilty' kernel config option that makes things
FEC to work unreliably.
