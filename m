Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaIMRiu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 13:38:50 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46440 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaIMRit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 13:38:49 -0400
Date: Sat, 13 Sep 2014 10:38:41 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Huang Shijie <shijie8@gmail.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Huang Shijie <shijie.huang@intel.com>,
        Mike Voytovich <mvoytovich@paypal.com>, linux-kernel@vger.kernel.org,
        Huang Shijie <b32955@freescale.com>, linux-mtd@lists.infradead.org,
        Roy Lee <roylee@paypal.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mtd: nand: gpmi: add proper raw access support
Message-ID: <20140913173841.GA18093@brian-ubuntu>
References: <1410339339-25561-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140911120928.GA1585@localhost.localdomain>
 <20140911143616.3ebb025a@bbrezillon>
 <20140911142511.GA2543@localhost.localdomain>
 <20140911163847.5e2f85c7@bbrezillon>
 <20140912004550.GB26904@shldeISGChi005.sh.intel.com>
 <20140912143050.014ad4c3@bbrezillon>
 <20140913153622.GA10132@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140913153622.GA10132@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 11:36:24PM +0800, Huang Shijie wrote:
> On Fri, Sep 12, 2014 at 02:30:50PM +0200, Boris BREZILLON wrote:
> > This test validates what's returned by ecc_strength file in sysfs
> > (which in turn is specified by the NAND controller when initializing
> > the NAND chip).
> > 
> > Doing this should not imply knowing the ECC algorithm in use in the
> > NAND controller or the layout used to store data on NAND.
> the difficulty is that the ECC parity area can be not byte aligned.

Is there a problem with just rounding up to the nearest byte alignment
and ignoring the few bits that are wasted?

> As I ever said, it is hard to implement the two hooks.

"Hard" doesn't mean we shouldn't. I really would like to encourage more
NAND drivers to be programmed against the expected MTD behavior -- that
(if possible with the given hardware) they can pass the MTD tests
(drivers/mtd/tests/*).

Brian
