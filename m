Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096AbaJ2NC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 09:02:57 -0400
Received: from down.free-electrons.com ([37.187.137.238]:42594 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932680AbaJ2NC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 09:02:56 -0400
Date: Wed, 29 Oct 2014 14:02:51 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Yassin Jaffer <yassinjaffer@gmail.com>
Subject: Re: [PATCH v7 1/2] mtd: nand: add sunxi NAND flash controller
 support
Message-ID: <20141029140251.142fed10@bbrezillon>
In-Reply-To: <20141028181310.GA23619@ld-irv-0074>
References: <1413896922-11680-1-git-send-email-boris.brezillon@free-electrons.com>
	<1413896922-11680-2-git-send-email-boris.brezillon@free-electrons.com>
	<20141028181310.GA23619@ld-irv-0074>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

On Tue, 28 Oct 2014 11:13:11 -0700
Brian Norris <computersforpeace@gmail.com> wrote:

> Hi Boris,
> 
> On Tue, Oct 21, 2014 at 03:08:41PM +0200, Boris Brezillon wrote:
> > +static int sunxi_nand_hw_ecc_ctrl_init(struct mtd_info *mtd,
> > +				       struct nand_ecc_ctrl *ecc,
> > +				       struct device_node *np)
> > +{
> > +	struct nand_ecclayout *layout;
> > +	int i, j;
> > +	int ret;
> > +
> > +	ret = sunxi_nand_hw_common_ecc_ctrl_init(mtd, ecc, np);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ecc->read_page = sunxi_nfc_hw_ecc_read_page;
> > +	ecc->write_page = sunxi_nfc_hw_ecc_write_page;
> > +	layout = ecc->layout;
> > +
> > +	for (i = 0; i < ecc->steps; i++) {
> 
> Hmm, did you retest this since changing this to ecc->steps? I think this
> won't work, since ecc->steps is only initialized in nand_scan_tail(),
> which comes after this. I only recommended the change for the
> {read,write}_page() type of functions, not the initialization functions.
> 
> [snip the rest]
> 
> So I'd suggest the following additional patch, and otherwise, the series
> is fine with me. If you give your ack, I can just squash this in and
> apply it to my tree:

It works, you can squash those changes into my first patch.

Thanks,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
