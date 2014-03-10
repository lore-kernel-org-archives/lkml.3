Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaCJPQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:16:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:51791 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbaCJPQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:16:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Kleine-Budde <mkl@pengutronix.de>, monstr@monstr.eu,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, michal.simek@xilinx.com,
        linux-can@vger.kernel.org, robh+dt@kernel.org,
        Kedareswara rao Appana <appana.durga.rao@xilinx.com>,
        grant.likely@linaro.org, Kedareswara rao Appana <appanad@xilinx.com>,
        wg@grandegger.com
Subject: Re: [PATCH v5] can: xilinx CAN controller support.
Date: Mon, 10 Mar 2014 16:15:42 +0100
Message-ID: <3245971.RIuVmbVL0Z@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <531DD5E7.7090406@pengutronix.de>
References: <5254bfec-c6fd-4681-a34d-706d51e60fbb@VA3EHSMHS004.ehs.local> <531DD493.3030306@monstr.eu> <531DD5E7.7090406@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:sfT3TcSZPPbOV+G53XmBQtO5tQ4iHEX+9EZSCCalw/X
 nfKCuRSVgEyph3BaLdTF9IUFwHPw7HnobZ4A9NTW8+uNMYLYFV
 LgPuFy6JZGB2WCXelYCPipzpZcnSl/BouaYApPnzuatd4XQUxy
 6ZlcbPwcu1ZTyPcDJAEnLF4ZoZE1IyETNDvJCYyjYkUFLLX+Vr
 9F23mNgMScGAsw9A1pCEx4btgxgQNfWLPm0nWKdgw24OMnWjTB
 zGASaM4ruW1xhkt+lRVTnSAbldYvRlRogWeEubTgSsoVg3iXzY
 vm2uMR0FnwpPgdkIj2JEj47fFCwHHzvz5o0Rt36mYmgobQ0dUY
 l1WxxjMZnP6HvDUUr6NE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2014 16:10:31 Marc Kleine-Budde wrote:
> >>> +config CAN_XILINXCAN
> >>> +   tristate "Xilinx CAN"
> >>> +   depends on ARCH_ZYNQ || MICROBLAZE
> >>
> >> Is Zynq multiarch already?
> > 
> > let me just answer this. Zynq is device with hardcoded dual arm cortex-a9 + some IPs
> > and programmable logic.
> > It means if you add Microblaze to PL or another CPU then you get multi architecture setup.
> 
> Sorry for the confusion, I'm not talking about
> more-than-one-architecture-in-a-FPGA, but the feature of the ARM-Linux
> Kernel to run on different ARM architecture. For example, it's possible
> to start the same kernel on a freescale imx6 and a the new marvel ebu
> platform. If the Zynq Kernel supports this feature, too, we should not
> limit to ARCH_ZYNQ, but use ARM instead.

Zynq has been multiplatform capable from the start. Ideally we'd let
users build the driver for any architecture and specify the exact
dependencies, it doesn't even have to be limited to ARM.

You probably want something like

	config CAN_XILINX
	tristate "Xilinx CAN"
	depends on ARCH_ZYNQ || MICROBLAZE || COMPILE_TEST
	depends on COMMON_CLK && HAS_MMIO  # whatever you need for other architectures

	Arnd
