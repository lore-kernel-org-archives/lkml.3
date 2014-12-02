Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbaLBAsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 19:48:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:39590 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230AbaLBAsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 19:48:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,497,1413270000"; 
   d="scan'208";a="641038453"
Date: Tue, 2 Dec 2014 08:47:43 +0800
From: Huang Shijie <shijie.huang@intel.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, Roy Lee <roylee@paypal.com>,
        Mike Voytovich <mvoytovich@paypal.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 0/3] mtd: nand: gpmi: add proper raw access support
Message-ID: <20141202004743.GB11370@shldeISGChi005.sh.intel.com>
References: <1417371030-24015-1-git-send-email-boris.brezillon@free-electrons.com>
 <20141201084709.GI29070@brian-ubuntu>
 <20141201095858.75ac3889@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201095858.75ac3889@bbrezillon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 09:58:58AM +0100, Boris Brezillon wrote:
> Hi Brian,
> 
> On Mon, 1 Dec 2014 00:47:09 -0800
> Brian Norris <computersforpeace@gmail.com> wrote:
> 
> > On Sun, Nov 30, 2014 at 07:10:27PM +0100, Boris Brezillon wrote:
> > > Hello,
> > > 
> > > This series provides an implementation for raw accesses taking care of
> > > hidding the specific layout used by the GPMI controller.
> > > 
> > > Best Regards,
> > > 
> > > Boris
> > > 
> > > Changes since v5:
> > >  - rename gpmi_move_bits into gpmi_copy_bits
> > > 
> > > Changes since v4:
> > >  - fixed a few corner cases in gpmi_move_bits (tested it with:
> > >    https://github.com/bbrezillon/gpmi-move-bits-test/blob/master/gpmi-move-bits-test.c)
> > >  - add documentation and comments for the new gpmi functions
> > > 
> > > Changes since v3:
> > >  - add comments to the gpmi_move_bits function
> > >  - extend raw read/write documentation
> > >  - move last part of the raw_page_read function into a conditional block
> > > 
> > > Changes since v2:
> > >  - fixed a bug in gpmi_move_bits
> > >  - add a raw_buffer field to be used when using raw access methods
> > >    (experienced memory corruptions when directly using page_buffer_virt
> > >    buffer)
> > >  - add raw OOB access functions
> > 
> > Applied the series. Thanks!
> > 
> > Out of curiosity, what tests does gpmi-nand.c now pass/fail?
> 
> The oobtest is still failing. I started to debug it, but didn't have
> enough time to make it work.
> 
> The nandbiterrs test is working, though I didn't manage to make the
> incremental test fail (writing the same pattern 10000 times without
> erasing the block between each write does not generate any bit flips) on
> my SLC NAND: MT29F2G08ABAEAH4.
> Can someone with another SLC NAND chip try it ?
> 
> > 
> > Also, is it time to yank / fixup some of these comments from
> > gpmi-nand.c?
> 
> I was asking myself the same question...
> 
> > 
> >  ...
> >  * FIXME: The following paragraph is incorrect, now that there exist
> >  * ecc.read_oob_raw and ecc.write_oob_raw functions.
> >  *
> >  * Since MTD assumes the OOB is not covered by ECC, there is no pair of
> >  * ECC-based/raw functions for reading or or writing the OOB. The fact that the
> >  * caller wants an ECC-based or raw view of the page is not propagated down to
> >  * this driver.
> >  */
> 
> I guess we can remove them.
> Huang can you confirm that the raw access functions introduced in this
> series are covering what's described here ?
I think we can remove these comments now.

thanks
Huang Shijie
