Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbbAISxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 13:53:50 -0500
Received: from smtprelay.synopsys.com ([198.182.47.9]:52386 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbbAISxr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 13:53:47 -0500
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jan 2015 13:53:47 EST
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: "acme@redhat.com" <acme@redhat.com>
CC: "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bp@suse.de" <bp@suse.de>, "jolsa@kernel.org" <jolsa@kernel.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 0/5] Perf fixes for ARC + uClibc
Thread-Topic: [PATCH 0/5] Perf fixes for ARC + uClibc
Thread-Index: AQHQKbgHeWsSw6r9cEq+IB1YZuKcqpy4FSKA
Date: Fri, 9 Jan 2015 18:47:08 +0000
Message-ID: <1420829227.5917.5.camel@synopsys.com>
References: <1420552335-26886-1-git-send-email-vgupta@synopsys.com>
	 <20150106151329.GD2517@redhat.com>
	 <C2D7FE5348E1B147BCA15975FBA2307565BCA4D7@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA2307565BCA4D7@IN01WEMBXA.internal.synopsys.com>
Reply-To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.225.15.208]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <A5AB0857DFB8D84981436CA330C02280@internal.synopsys.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Wed, 2015-01-07 at 07:38 +0000, Vineet Gupta wrote:
> On Tuesday 06 January 2015 08:43 PM, Arnaldo Carvalho de Melo wrote:
> 
> > Em Tue, Jan 06, 2015 at 07:22:10PM +0530, Vineet Gupta escreveu:
> > > > Hi,
> > > > 
> > > > This series based off linux-next of 20150105 allows us to build/use perf
> > > > for ARC with uClibc based userland.
> > Do you have some ready made ARC VM image with devel tools I could use with qemu?
> > 
> > - Arnaldo
> >  
> 
> FWIW, most of the issues I posted fixes for can be reproduced with
> building perf with ARC buildroot !
> 
> git://github.com:foss-for-synopsys-dwc-arc-processors/buildroot.git

To reproduce described build problems (covered in patches 1, 2, 3, 5) you may indeed use Buildroot.
Just get the most recent release from here http://buildroot.uclibc.org/downloads/buildroot-2014.11.tar.gz
and use load following configuration in "menuconfig":
--->---
BR2_arcle=y
BR2_TOOLCHAIN_BUILDROOT_LARGEFILE=y
BR2_LINUX_KERNEL=y
BR2_LINUX_KERNEL_DEFCONFIG="fpga"
BR2_PACKAGE_PERF=y
BR2_TARGET_ROOTFS_INITRAMFS=y 
--->---

Then say "make" and you'll see the problem.
If you experience any problems trying to follow my advice please let me
know and I'll try to help you.

-Alexey
