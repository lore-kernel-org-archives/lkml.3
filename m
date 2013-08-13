Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab3HMVyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 17:54:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:11436 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756904Ab3HMVyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 17:54:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,873,1367996400"; 
   d="scan'208";a="380470954"
From: "Skidmore, Donald C" <donald.c.skidmore@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [E1000-devel] 3.11-rc4 ixgbevf: endless "Last Request of type
 00 to	PF Nacked" messages
Thread-Topic: [E1000-devel] 3.11-rc4 ixgbevf: endless "Last Request of type
 00 to	PF Nacked" messages
Thread-Index: AQHOlSTqRXYmH+T/60yJytMLRmvNlZmTmTIQ
Date: Tue, 13 Aug 2013 21:54:15 +0000
Message-ID: <F6FB0E698C9B3143BDF729DF222866466FD41225@ORSMSX110.amr.corp.intel.com>
References: <CAErSpo53L3-feEw0qZvBTmRrY+SXpGrGU6oxZg3wVjH1M8JDXg@mail.gmail.com>
In-Reply-To: <CAErSpo53L3-feEw0qZvBTmRrY+SXpGrGU6oxZg3wVjH1M8JDXg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Bjorn,

Sorry for the slow reply I was on vacation last week and have been playing catch up on my email.  

We were unable to recreate your failure here locally so I have some additional questions.  First off you mentioned it was failing as far back as v3.9, was it ever working for you?  If so bisecting would be really helpful as I mentioned we have been unable to cause the failure in house.  If not could you see if the problem still occurs without the external Magma PCIe expansion chassis, this is of course assuming that you can plug the X540 into your system without it.

One other note we are in the process of testing several patch (in house) that touch on the code you are seeing the error in.  I can't say they would have any effect on what you are seeing, since I'm not sure what that is, but may be worth testing once they get upstream.

Thanks,
-Don Skidmore <donald.c.skidmore@intel.com>
	
> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Friday, August 09, 2013 10:19 AM
> To: e1000-devel@lists.sourceforge.net
> Cc: linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [E1000-devel] 3.11-rc4 ixgbevf: endless "Last Request of type 00 to
> PF Nacked" messages
> 
> When I enable VFs via sysfs on an Intel X540-AT, I see an endless stream of
> 
>     ixgbevf 0000:08:10.2: Last Request of type 03 to PF Nacked
> 
> messages.  This on an HP z420 with the Intel X540-AT in external Magma PCIe
> expansion chassis.  No cable is attached to the X540-AT.
> 
> ixgbe is built as a module and is auto-loaded during boot, with no VFs
> enabled.  The "Last request Nacked" messages start when I enable VFs
> with:
> 
>     # echo -n 8 > /sys/bus/pci/devices/0000:08:00.0/sriov_numvfs
>     ixgbe 0000:08:00.0 eth1: SR-IOV enabled with 8 VFs
>     pci 0000:08:10.0: [8086:1515] type 00 class 0x020000
>     pci 0000:08:10.2: [8086:1515] type 00 class 0x020000
>     ...
>     ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver -
> version 2.7.12-k
>     ...
>     ixgbevf 0000:08:10.2: Last Request of type 03 to PF Nacked
>     ...
> 
> This happens with v3.11-rc4, v3.10, and v3.9, which is as far back as I checked.
> Complete console log and lspci output are here:
> 
>     http://helgaas.com/linux/ixgbe/z420.log
>     http://helgaas.com/linux/ixgbe/lspci
> 
> ------------------------------------------------------------------------------
> Get 100% visibility into Java/.NET code with AppDynamics Lite!
> It's a free troubleshooting tool designed for production.
> Get down to code-level detail for bottlenecks, with <2% overhead.
> Download for free and get started troubleshooting in minutes.
> http://pubads.g.doubleclick.net/gampad/clk?id=48897031&iu=/4140/ostg.clk
> trk
> _______________________________________________
> E1000-devel mailing list
> E1000-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/e1000-devel
> To learn more about Intel&#174; Ethernet, visit
> http://communities.intel.com/community/wired
