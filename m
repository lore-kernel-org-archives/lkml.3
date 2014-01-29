Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbaA2SqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:46:24 -0500
Received: from top.free-electrons.com ([176.31.233.9]:33618 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751116AbaA2SqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:46:22 -0500
Date: Wed, 29 Jan 2014 15:46:20 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Boris BREZILLON <b.brezillon.dev@gmail.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v2 08/14] mtd: nand: add sunxi NAND flash controller
 support
Message-ID: <20140129184619.GC27143@localhost>
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
 <1391006064-28890-9-git-send-email-b.brezillon.dev@gmail.com>
 <20140129175641.GF1427@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140129175641.GF1427@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 10:56:42AM -0700, Jason Gunthorpe wrote:
> On Wed, Jan 29, 2014 at 03:34:18PM +0100, Boris BREZILLON wrote:
> 
> [..]
> 
> > +static int sunxi_nand_chip_init(struct device *dev, struct sunxi_nfc *nfc,
> [..]
> > +       ret = sunxi_nand_chip_init_timings(chip, np);
> > +       if (ret)
> > +               return ret;
> [..]
> > +       ret = nand_scan_ident(mtd, nsels, NULL);
> 
> This ordering looks a bit problematic, will onfi_get_async_timing_mode
> ever return anything other than ONFI_TIMING_MODE_UNKNOWN if it is
> called before nand_scan_ident ? What sets clk_rate to non-zero if there
> is no DT property?
> 
> For a flow that uses onfi_get_async_timing_mode rather than DT the
> driver should set the interface to timing mode 0 (slowest) and then
> call nand_scan_ident, and then reset the interface to the detected
> timing mode.
> 

Yes. And I believe this is a requirement from the ONFI 2.1 spec:

"""
4.1.4.3. Source Synchronous to Asynchronous
[..]

The host shall transition to the asynchronous data interface. Then the
host shall issue the Reset (FFh) command described in the previous paragraph
using asynchronous timing mode 0, thus the host transitions to the asynchronous
data interface prior to issuing the Reset (FFh). A device in any timing mode is
required to recognize a Reset (FFh) command issued in asynchronous timing
mode 0.

[..]

After CE# has been pulled high and then transitioned low again, the host
should issue a Set Features to select the appropriate asynchronous timing mode.
"""

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
