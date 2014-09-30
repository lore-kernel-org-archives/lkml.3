Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbaI3IE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:04:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53007 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751809AbaI3IET convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:04:19 -0400
Date: Tue, 30 Sep 2014 10:04:15 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Iwo Mergler <Iwo.Mergler@netcommwireless.com>
Cc: Huang Shijie <shijie8@gmail.com>, Mike Voytovich <mvoytovich@paypal.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Roy Lee <roylee@paypal.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] mtd: nand: gpmi: add proper raw access support
Message-ID: <20140930100415.4834971d@bbrezillon>
In-Reply-To: <EACD232272DA4849B060F0828564D13B44955ABD82@ntcex01.corp.netcomm.com.au>
References: <1410339339-25561-1-git-send-email-boris.brezillon@free-electrons.com>
	<20140911120928.GA1585@localhost.localdomain>
	<20140911143616.3ebb025a@bbrezillon>
	<EACD232272DA4849B060F0828564D13B44955ABD82@ntcex01.corp.netcomm.com.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Iwo,

On Mon, 29 Sep 2014 11:22:11 +1000
Iwo Mergler <Iwo.Mergler@netcommwireless.com> wrote:

> On Thu, 11 Sep 2014 22:36:16 +1000
> Boris BREZILLON <boris.brezillon@free-electrons.com> wrote:
> > 
> > Well, I don't know about freescale specific tools, but at least I have
> > an example with mtd_nandbiterrs module.
> > This module is assuming it can write only the data part of a NAND page
> > without modifying the OOB area (see [1]), which in GPMI controller
> > case is impossible because raw write function store the data as if
> > there were no specific scheme, while there is one:
> > (metadata + n x (data_chunk + ECC bytes) + remaining_bytes).
> > 
> 
> Hi Boris,
> 
> 
> just as an aside, only the incremental bit errors test in nandbiterrs
> positively requires raw data write.
> 
> The overwrite test (re-write the same page data repeatedly without
> erase), only uses raw access because I was lazy. A normal ECC write
> would do just as well.

Okay.
Anyway, the test I'm really interested in is the incremental bit errors
test :-).

BTW, any reason you chose to implement this test/testsuite as a
module ?
>From my understanding (and tell me if I'm wrong) we could do the same
from user-space.

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
