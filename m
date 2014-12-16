Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaLPP3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:29:15 -0500
Received: from mylo.jdl.com ([208.123.73.151]:34530 "EHLO mylo"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751118AbaLPP3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:29:13 -0500
X-Greylist: delayed 2656 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Dec 2014 10:29:12 EST
From: Jon Loeliger <jdl@jdl.com>
To: Chris Packham <chris.packham@alliedtelesis.co.nz>
cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        arnd@arndb.de, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dtc: Use quotes to include header files
In-reply-to: <1418696004-12829-1-git-send-email-chris.packham@alliedtelesis.co.nz>
References: <7947240.7yktm8fT2X@wuerfel> <1418696004-12829-1-git-send-email-chris.packham@alliedtelesis.co.nz>
Comments: In-reply-to Chris Packham <chris.packham@alliedtelesis.co.nz>
   message dated "Tue, 16 Dec 2014 15:13:24 +1300."
Date: Tue, 16 Dec 2014 08:44:44 -0600
Message-Id: <E1Y0tMi-0006IS-Bu@mylo>
X-Spam-Score: -1.9
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: jdl@jdl.com
X-SA-Exim-Scanned: No (on mylo); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, like, Chris Packham said:
> Hi,
> 
> This probably should come via git://git.jdl.com/software/dtc.git however
> this appears to be inaccessible at the moment. Is this still the
> canonical source for the device tree compiler and libfdt or has it been
> moved? How much deviation from the canonical source are we prepared to
> live with in the kernel?

That is because the official DTC repository has moved to git.kernel.org!



> Currently in arch and driver code that needs early access to the
> flattened device tree it is necessary to add specific CFLAGS so that
> when scripts/dtc/libfdt/libfdt.h is included the C preprocessor is able
> to locate the libfdt versions of libfdt_env.h and fdt.h without
> generating an error.
> 
> We already provide an alternative linux-specific
> version of libfdt_env.h and directly include scripts/dtc/libfdt/fdt.h
> so the inclusion by scripts/dtc/libfdt/libfdt.h is a no-op thanks to the
> inclusion guards.
> 
> By using quotes in scripts/dtc/libfdt/libfdt.h it picks up fdt.h and
> libfdt_env.h from the source directory without needing to add CFLAGS for
> the sources that happen to include linux/libfdt.h.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> ---

and:

> diff --git a/scripts/dtc/libfdt/libfdt.h b/scripts/dtc/libfdt/libfdt.h
> index 73f4975..ea1ddcd 100644
> --- a/scripts/dtc/libfdt/libfdt.h
> +++ b/scripts/dtc/libfdt/libfdt.h
> @@ -51,8 +51,8 @@
>   *     EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
>   */
>  
> -#include <libfdt_env.h>
> -#include <fdt.h>
> +#include "libfdt_env.h"
> +#include "fdt.h"
>  
>  #define FDT_FIRST_SUPPORTED_VERSION	0x10
>  #define FDT_LAST_SUPPORTED_VERSION	0x11


Hmm.  I seem to recall that the use of angle brackets was intentional.
I believe that was predicated on installing the FDT library on some
target machine and needing it to be able to find the other header
files in an installation, not source, directory.

Minor repository spelunking suggests that the angle brackets have
been around since Day Zero:

    commit 3da0f9a10dfa9b615d06c350c7b9fe29f360a6e0

David?

HTH?,
jdl
