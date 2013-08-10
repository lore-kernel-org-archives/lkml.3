Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968435Ab3HJIUV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 04:20:21 -0400
Received: from mail-pa0-f66.google.com ([209.85.220.66]:54983 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968414Ab3HJIUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 04:20:17 -0400
Date: Sat, 10 Aug 2013 01:20:13 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, dedekind1@gmail.com
Subject: Re: [PATCH v2 append] mtd: update the ABI document about the ecc step
Message-ID: <20130810082013.GC3467@norris.computersforpeace.net>
References: <1368619642.15764.96.camel@sauron.fi.intel.com>
 <1368677383-29224-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368677383-29224-1-git-send-email-b32955@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 12:09:43PM +0800, Huang Shijie wrote:
> We add a new sys node for ecc step. So update the ABI document about it.
> 
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>  Documentation/ABI/testing/sysfs-class-mtd |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-mtd b/Documentation/ABI/testing/sysfs-class-mtd
> index 3105644..62a1cda 100644
> --- a/Documentation/ABI/testing/sysfs-class-mtd
> +++ b/Documentation/ABI/testing/sysfs-class-mtd
> @@ -173,3 +173,14 @@ Description:
>  		This is generally applicable only to NAND flash devices with ECC
>  		capability.  It is ignored on devices lacking ECC capability;
>  		i.e., devices for which ecc_strength is zero.
> +
> +What:		/sys/class/mtd/mtdX/ecc_step
> +Date:		May 2013
> +KernelVersion:	3.10
> +Contact:	linux-mtd@lists.infradead.org
> +Description:
> +		The size of ecc step which is used for per ecc correction.

Despite the usage of lower-case 'ecc' in some places, I would prefer
consistent usage of upper-case 'ECC'. And "ECC correction" is redundant.

Also, "...which is used for per ecc correction" doesn't make sense to
me. Perhaps you just mean "...which is used for ECC"?

The following note under the current ecc_strength documentation makes
more sense here, actually:

  "Note that some devices will have multiple ecc steps within each
   writesize region."

Maybe just copy-and-paste it here too?

> +		See more in the ecc_strength above. This will always be a
> +		non-negative integer.
> +
> +		In the case of devices lacking any ECC capability, it is 0.

These wording comments aren't highly important. If I have any more
changes, I can just edit before applying when you send v3.

Thanks,
Brian
