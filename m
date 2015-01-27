Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbbA0W2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 17:28:55 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:58962 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbbA0W2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 17:28:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v8 0/4] net: Add Keystone NetCP ethernet driver support
Date: Tue, 27 Jan 2015 23:28:42 +0100
Message-ID: <25883654.BLFxICW9P0@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54BE7A00.2020205@ti.com>
References: <1421367007-19744-1-git-send-email-m-karicheri2@ti.com> <20150119.151106.822126941934010309.davem@davemloft.net> <54BE7A00.2020205@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:HMwlm9+ghKHxT9jxqwJW8o9A2iyU2nMLhCBScvgJl5DCcmlNKLG
 8RKGnKcZEkeDC1ycRuwkxqA5fbG5y6s9Zhw6vDKDTyDz7GhTWMRtIJ/uLkoSYaGZwkiRLSn
 YKe0DCIaBqPtiuZS2n3hDJPaumhmTUsmg1pQYGLX8v9nb8iaNSkySR44rkBDcjMgTFub139
 mxGvfjcpA6yWdneJPyM4A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 January 2015 10:53:36 Murali Karicheri wrote:
> On 01/19/2015 03:11 PM, David Miller wrote:
> > From: Murali Karicheri<m-karicheri2@ti.com>
> > Date: Thu, 15 Jan 2015 19:10:03 -0500
> >
> >> The Network Coprocessor (NetCP) is a hardware accelerator that processes
> >> Ethernet packets. NetCP has a gigabit Ethernet (GbE) subsystem with a ethernet
> >> switch sub-module to send and receive packets. NetCP also includes a packet
> >> accelerator (PA) module to perform packet classification operations such as
> >> header matching, and packet modification operations such as checksum
> >> generation. NetCP can also optionally include a Security Accelerator(SA)
> >> capable of performing IPSec operations on ingress/egress packets.
> >>
> >> Keystone SoC's also have a 10 Gigabit Ethernet Subsystem (XGbE) which
> >> includes a 3-port Ethernet switch sub-module capable of 10Gb/s and
> >> 1Gb/s rates per Ethernet port.
> >>
> >> Both GBE and XGBE network processors supported using common driver. It
> >> is also designed to handle future variants of NetCP.
> >
> > Series applied to net-next, thanks.
> David,
> 
> Thanks a lot for applying this series. This helps us move forward to 
> work on the next set of patches.

Hi Murali,

Building an ARM 'allmodconfig' kernel now runs into two separate problems
from your driver:

- you have two module_init() instances in one module, which conflict.

- you have two files that are linked into more than one module, so building
  both TI_CPSW and TI_KEYSTONE_NETCP in the same kernel fails.

The answer to both of these is probably to have separate loadable modules,
but you might be able to come up with a different solution.

	Arnd
