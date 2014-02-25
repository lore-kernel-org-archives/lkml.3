Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaBYFzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 00:55:07 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:55446 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750706AbaBYFzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 00:55:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmkEAHovDFOl5H4JgWdsb2JhbABYiUq5EoMHgS4OAQEWJiiCJQEBBAE6MgoDEAsOCgkVEA8BRwaIEAjGdheODVcHhDgElAWaFyiBLQ
From: Alistair Popple <alistair@popple.id.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 7/7] powerpc: Added PCI MSI support using the HSTA module
Date: Tue, 25 Feb 2014 16:54:58 +1100
Message-ID: <1541869.UgdfUgWYNB@mexican>
User-Agent: KMail/4.11.5 (Linux/3.11.0-17-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1393015286.6771.110.camel@pasglop>
References: <1392964293-13687-1-git-send-email-alistair@popple.id.au> <1574137.lzDhNaVqIe@wuerfel> <1393015286.6771.110.camel@pasglop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Feb 2014 07:41:26 Benjamin Herrenschmidt wrote:
> On Fri, 2014-02-21 at 15:33 +0100, Arnd Bergmann wrote:

[...]

> 
> Should we (provided it's possible in HW) create two ranges instead ? One
> covering RAM and one covering MSIs ? To avoid stray DMAs whacking random
> HW registers in the chip ...
> 

The thought occurred to me but I figured if we had stray DMAs then they could 
already whack random bits of system memory which would likely break your 
system anyway so I wasn't sure how much we'd gain. I guess whacking random HW 
registers is arguably a bit worse though.

I did a bit of digging into the HW documentation and it looks like it _may_ be 
possible to create a second range that would limit access to a subset of HW 
registers, although there doesn't seem to be much flexibility. Personally I'm 
not sure it justifies the work, but I'm happy to look into it a bit more if 
you feel it's important?

- Alistair

