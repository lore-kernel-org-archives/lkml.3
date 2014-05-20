Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbaETSZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 14:25:50 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:34055 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbaETSZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 14:25:47 -0400
Date: Tue, 20 May 2014 11:25:42 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Boris BREZILLON <b.brezillon.dev@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robherring2@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        dev@linux-sunxi.org
Subject: Re: [PATCH v3 4/9] of: mtd: add documentation for the ONFI NAND
 timing mode property
Message-ID: <20140520182542.GS28907@ld-irv-0074>
References: <1394647664-8258-1-git-send-email-b.brezillon.dev@gmail.com>
 <1394647664-8258-5-git-send-email-b.brezillon.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394647664-8258-5-git-send-email-b.brezillon.dev@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Wed, Mar 12, 2014 at 07:07:39PM +0100, Boris BREZILLON wrote:
> Add documentation for the ONFI NAND timing mode property.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
> ---
>  Documentation/devicetree/bindings/mtd/nand.txt |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mtd/nand.txt b/Documentation/devicetree/bindings/mtd/nand.txt
> index b53f92e..2046027 100644
> --- a/Documentation/devicetree/bindings/mtd/nand.txt
> +++ b/Documentation/devicetree/bindings/mtd/nand.txt
> @@ -19,3 +19,11 @@ errors per {size} bytes".
>  The interpretation of these parameters is implementation-defined, so not all
>  implementations must support all possible combinations. However, implementations
>  are encouraged to further specify the value(s) they support.
> +
> +- onfi,nand-timing-mode: an integer encoding the supported ONFI timing modes of
> +  the NAND chip. Each supported mode is represented as a bit position (i.e. :
> +  mode 0 and 1 => (1 << 0) | (1 << 1) = 0x3).
> +  This is only used when the chip does not support the ONFI standard.
> +  The last bit set represent the closest mode fulfilling the NAND chip timings.
> +  For a full description of the different timing modes see this document:
> +  www.onfi.org/~/media/ONFI/specs/onfi_3_1_spec.pdf

I'm not 100% convinced this property should go in the device tree. With
most other flash properties (device size, page size, and even minimum
ECC requirements), we try to auto-detect these parameters to some
extent. ONFI makes it easy for some class of chips, but for others, we
typically rely on an in-kernel device ID table or ID decoding heuristic
-- we don't require a DT description of every property of the flash. So
what makes this property different?

I realize that we may not include device ID entries for every flash that
you need in the ID table (although we still are able to detect the
important properties accurately, like page and block size). But would it
suffice to default these flash to a lowest common timing mode, like mode
0?

If no other option works well, then I am still open to describing the
supported timing modes in the DT.

BTW, this bitfield property looks kinda strange to me. Do non-ONFI flash
typically support multiple timing modes? And if so, how are we supposed
to *change* modes? AFAIK, ONFI provides the only standard for
configuring the flash's timing mode. So maybe you're really only wanting
a "default timing mode" property that is a single integer, not a
bitfield.

Regards,
Brian
