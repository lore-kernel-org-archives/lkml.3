Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbaIHMaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:30:05 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:55836 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaIHMaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:30:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Robert Richter <rric@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Robert Richter <robert.richter@caviumnetworks.com>,
        Olof Johansson <olof@lixom.net>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
Subject: Re: [PATCH v2 1/4] arm64, thunder: Add Kconfig option for Cavium Thunder SoC Family
Date: Mon, 08 Sep 2014 14:29:10 +0200
Message-ID: <8282633.qB60Cj5UPD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140908110131.GX4703@rric.localhost>
References: <1409903205-2762-1-git-send-email-rric@kernel.org> <2952834.1P42roDKD9@wuerfel> <20140908110131.GX4703@rric.localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8G8kruEm7shLd0U+Rd2jjj9pz3yvnM3VoD5njNXgZdq
 TDuFKwQ3/QitBQ6o6R+muytwpKQOKEGfpgrhSdROyxRVBkIp5I
 Bp9khvG/iEtoSGqug7Pl8QFEE8kVMmWe5t11KkCzkIRlJ0vvY9
 uhc5A4VRsSxjOdPxqAr7M3oAyqNB8Uju17xxFwkPCM9M46/xHf
 9VboA2h55yT/PMdUBYxMS9Y2sHcrwGeYIlQdx8FFZqzO3jgHtR
 4RzqOwfmcP+wH9vgCVNGbW3cokbG+40IZ41zWGE5V1867FwoNo
 2vF14a7v4LFkT2z41tkSKF5colN4JkPNMs/7UP1nOg4RK5Wf9F
 SoGHhXUhNrKj4Gp0/EXA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2014 13:01:31 Robert Richter wrote:
> This is well hidden on x86, but each vendor has a config option. For
> AMD systems we have had our own option to disable vendor specific
> code, see CPU_SUP_AMD for example. Disabling this will remove all AMD
> specific code in the kernel. Of course this is enabled per default.
> 
> With ARCH_THUNDER I intended to do the same (you could name this also
> SOC_SUP_CAVIUM or so but I kept the current naming scheme). In patch
> 4/4 I have added the option to defconfig. This enables this per
> default and nobody has to deal with any option manually, just running
> make defconfig is fine.
> 
> Also, at least to disable building the dtb file for foo, you will need
> ARCH_FOO too. How else would you deal with dtb files then?

The only alternative I see is to build them all.

> Having ARCH_FOO might not be necessary for drivers. One could enable
> drivers manually, but this option is still a good reference for the
> drivers needed by foo. At some point you will carry tons of enabled
> drivers in your defconfig and you don't know which platform actually
> is using it. For generic drivers this might be fine.  But in my point
> of few, each soc specific driver should have an soc specific option
> too. Then you easily can remove an soc from the defconfig.

Yes, that's what I had in my example.

	Arnd
