Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab3GJKAD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 06:00:03 -0400
Received: from www84.your-server.de ([213.133.104.84]:51412 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab3GJKAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 06:00:01 -0400
Message-ID: <1373450412.1016.3.camel@wall-e>
Subject: Re: BUG: 32 Bit Kernel kexec hangs on P2020
From: Stefani Seibold <stefani@seibold.net>
To: "tiejun.chen" <tiejun.chen@windriver.com>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org
Date: Wed, 10 Jul 2013 12:00:12 +0200
In-Reply-To: <51DD1FC7.6080203@windriver.com>
References: <1373445543.348.5.camel@wall-e> <51DD1FC7.6080203@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 10.07.2013, 16:48 +0800 schrieb tiejun.chen:
> On 07/10/2013 04:39 PM, Stefani Seibold wrote:
> > Hi,
> >
> > i have tried to kexec a 32 bit kernel on a Freescale P2020 dual core CPU
> > (e500v2, revison 5.1 - pvr 8021 1051), but Kexec will hang after the
> > "Bye!".
> >
> > The host and the kexec kernel are the same, based on the current kernel
> > version 3.10.
> >
> > I have tried it with kexec-tools 2.0.4.git released 30 June 2013.
> >
> > Invoking kexec with
> >
> > kexec --command-line "1 maxcpus=1 noirqdistrib reset_devices $(cat /proc/cmdline)" -t elf-ppc --dtb=rs2020.dtb \
> > --reuse-node="/cpus/PowerPC,P2020@0/timebase-frequency" \
> > --reuse-node="/cpus/PowerPC,P2020@0/bus-frequency" \
> > --reuse-node="/cpus/PowerPC,P2020@0/clock-frequency" \
> > --reuse-node="/cpus/PowerPC,P2020@0/next-level-cache" \
> > --reuse-node="/cpus/PowerPC,P2020@1/timebase-frequency" \
> > --reuse-node="/cpus/PowerPC,P2020@1/bus-frequency" \
> > --reuse-node="/cpus/PowerPC,P2020@1/clock-frequency" \
> > --reuse-node="/cpus/PowerPC,P2020@1/next-level-cache" \
> > --reuse-node="/cpus/PowerPC,P2020@1/cpu-release-addr" \
> > --reuse-node="/cpus/PowerPC,P2020@1/enable-method" \
> > --reuse-node="/soc@ffe00000/bus-frequency" \
> > --reuse-node="/soc@ffe00000/serial@4500/clock-frequency" \
> > --reuse-node="/soc@ffe00000/ethernet@24000/local-mac-address" \
> > -d -l -x vmlinux
> > kexec -e
> 
> Could you try again with one simple command like,
> 
> kexec -l vmlinux --append="`cat /proc/cmdline`";kexec -e
> 

Great, this works.

I did more test and the issue for the fail is the passing of the device
tree. But the device tree is exact the same as the previous used one.

Is passing a new device tree not allowed?

Stefani


