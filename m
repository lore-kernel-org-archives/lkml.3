Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150AbaLOVix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:38:53 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:50288 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaLOViw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:38:52 -0500
Date: Mon, 15 Dec 2014 23:38:43 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Aleksey Makarov <feumilieu@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH 14/14] MIPS: OCTEON: Handle OCTEON III in csrc-octeon.
Message-ID: <20141215213843.GE10323@fuloong-minipc.musicnaut.iki.fi>
References: <1418666603-15159-1-git-send-email-aleksey.makarov@auriga.com>
 <1418666603-15159-15-git-send-email-aleksey.makarov@auriga.com>
 <20141215212422.GD10323@fuloong-minipc.musicnaut.iki.fi>
 <548F52B8.7030606@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548F52B8.7030606@caviumnetworks.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 15, 2014 at 01:29:28PM -0800, David Daney wrote:
> On 12/15/2014 01:24 PM, Aaro Koskinen wrote:
> >On Mon, Dec 15, 2014 at 09:03:20PM +0300, Aleksey Makarov wrote:
> >>  	if (current_cpu_type() == CPU_CAVIUM_OCTEON2) {
> >>  		union cvmx_mio_rst_boot rst_boot;
> >>+
> >>  		rst_boot.u64 = cvmx_read_csr(CVMX_MIO_RST_BOOT);
> >>  		rdiv = rst_boot.s.c_mul;	/* CPU clock */
> >>  		sdiv = rst_boot.s.pnr_mul;	/* I/O clock */
> >>  		f = (0x8000000000000000ull / sdiv) * 2;
> >>+	} else if (current_cpu_type() == CPU_CAVIUM_OCTEON3) {
> >>+		union cvmx_rst_boot rst_boot;
> >>+
> >>+		rst_boot.u64 = cvmx_read_csr(CVMX_RST_BOOT);
> >>+		rdiv = rst_boot.s.c_mul;	/* CPU clock */
> >>+		sdiv = rst_boot.s.pnr_mul;	/* I/O clock */
> >>+		f = (0x8000000000000000ull / sdiv) * 2;
> >>  	}
> >
> >The f = ... part could be moved outside the if blocks to avoid copy paste.
> >
> 
> No, If you look at the rest of the file, you will find that there are checks
> in the form:
> 
>   if (f != 0) ...
> 
> There is a reason that we leave f with its default value of zero in some of
> the cases.

Right, sorry, I overlooked the fact that both of those if conditions
can be false.

A.
