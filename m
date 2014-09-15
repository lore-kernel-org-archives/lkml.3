Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaIOOnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:43:20 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36705 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaIOOnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:43:19 -0400
Date: Mon, 15 Sep 2014 22:43:02 +0800
From: Huang Shijie <shijie8@gmail.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Huang Shijie <shijie.huang@intel.com>,
        Mike Voytovich <mvoytovich@paypal.com>, linux-kernel@vger.kernel.org,
        Huang Shijie <b32955@freescale.com>, linux-mtd@lists.infradead.org,
        Roy Lee <roylee@paypal.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mtd: nand: gpmi: add proper raw access support
Message-ID: <20140915144259.GA1947@localhost.localdomain>
References: <1410339339-25561-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140911120928.GA1585@localhost.localdomain>
 <20140911143616.3ebb025a@bbrezillon>
 <20140911142511.GA2543@localhost.localdomain>
 <20140911163847.5e2f85c7@bbrezillon>
 <20140912004550.GB26904@shldeISGChi005.sh.intel.com>
 <20140912143050.014ad4c3@bbrezillon>
 <20140913153622.GA10132@localhost.localdomain>
 <20140913173841.GA18093@brian-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140913173841.GA18093@brian-ubuntu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 10:38:41AM -0700, Brian Norris wrote:
> On Sat, Sep 13, 2014 at 11:36:24PM +0800, Huang Shijie wrote:
> > On Fri, Sep 12, 2014 at 02:30:50PM +0200, Boris BREZILLON wrote:
> > > This test validates what's returned by ecc_strength file in sysfs
> > > (which in turn is specified by the NAND controller when initializing
> > > the NAND chip).
> > > 
> > > Doing this should not imply knowing the ECC algorithm in use in the
> > > NAND controller or the layout used to store data on NAND.
> > the difficulty is that the ECC parity area can be not byte aligned.
> 
> Is there a problem with just rounding up to the nearest byte alignment
> and ignoring the few bits that are wasted?

I feel a little confused with the two hooks.

does the ecc->write_page_raw need to write the ECC parity data?

The page's layout after an ecc->write_page  will look like this:
                                              (Block Mark)
                                                    |      |
                                                    |  D   |
                                                    |<---->|
                                                    V      V
     +---+----------+-+----------+-+----------+-+----------+-+
     | M |   data   |E|   data   |E|   data   |E|   data   |E|
     +---+----------+-+----------+-+----------+-+----------+-+

What will the page's layout look like after the ecc->write_page_raw?


thanks
Huang Shijie

