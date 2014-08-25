Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaHYF3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 01:29:41 -0400
Received: from ozlabs.org ([103.22.144.67]:54653 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbaHYF3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 01:29:39 -0400
Message-ID: <1408944577.7941.4.camel@concordia>
Subject: Re: [PATCH] powerpc: edac: Fix build error
From: Michael Ellerman <mpe@ellerman.id.au>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:EDAC-CORE" <linux-edac@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 25 Aug 2014 15:29:37 +1000
In-Reply-To: <1408673991-17892-1-git-send-email-bobby.prani@gmail.com>
References: <1408673991-17892-1-git-send-email-bobby.prani@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-21 at 22:19 -0400, Pranith Kumar wrote:
> Fix the following build error:
> 
> drivers/edac/ppc4xx_edac.c: In function 'mfsdram':
> drivers/edac/ppc4xx_edac.c:249: error: implicit declaration of function
> '__mfdcri'
> drivers/edac/ppc4xx_edac.c: In function 'mtsdram':
> drivers/edac/ppc4xx_edac.c:266: error: implicit declaration of function
> '__mtdcri'
> drivers/edac/ppc4xx_edac.c:269: warning: 'return' with a value, in function
> returning void
> drivers/edac/ppc4xx_edac.c: In function 'ppc4xx_edac_init_csrows':
> drivers/edac/ppc4xx_edac.c:924: warning: initialization from incompatible
> pointer type
> drivers/edac/ppc4xx_edac.c:977: error: request for member 'dimm' in something
> not a structure or union
> drivers/edac/ppc4xx_edac.c: In function 'ppc4xx_edac_map_dcrs':
> drivers/edac/ppc4xx_edac.c:1209: warning: passing argument 1 of 'dcr_map_mmio'
> discards qualifiers from pointer target type
> 
> This driver depends on PPC_DCR_NATIVE to be set for the relevant headers to be
> included. Also if PPC_DCR_MMIO=n the build fails. So make PPC_DCR depend on both
> these options.

Um, NAK I think. The whole point is that some platforms implement DCR natively
and some via MMIO, and that's meant to be hidden by the DCR API.

If the driver is directly calling DCR native routines then it should depend on
that.

cheers



