Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaEZVcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 17:32:35 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:62832 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaEZVcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 17:32:31 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:c57e:23b4:6c1a:bac4]
In-Reply-To: <1397475725-5036-2-git-send-email-peter.ujfalusi@ti.com>
References: <1397475725-5036-1-git-send-email-peter.ujfalusi@ti.com>
	<1397475725-5036-2-git-send-email-peter.ujfalusi@ti.com>
Date: Mon, 26 May 2014 14:32:30 -0700
Message-ID: <CAOesGMg43jT6D_ot2tKfRXXgAgwqs5Pu_tAFKc35yxLAczrzGQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/10] platform_data: edma: Be precise with the paRAM struct
From: Olof Johansson <olof@lixom.net>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>, Sekhar Nori <nsekhar@ti.com>,
        Joel Fernandes <joelf@ti.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Apr 14, 2014 at 4:41 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> The edmacc_param struct should follow the layout of the paRAM area in the
> HW. Be explicit on the size of the fields (u32) and also mark the struct
> as packed to avoid any padding on non 32bit architectures.
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Acked-by: Joel Fernandes <joelf@ti.com>
> ---
>  include/linux/platform_data/edma.h | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/platform_data/edma.h b/include/linux/platform_data/edma.h
> index f50821cb64be..923f8a3e4ce0 100644
> --- a/include/linux/platform_data/edma.h
> +++ b/include/linux/platform_data/edma.h
> @@ -43,15 +43,15 @@
>
>  /* PaRAM slots are laid out like this */
>  struct edmacc_param {
> -       unsigned int opt;
> -       unsigned int src;
> -       unsigned int a_b_cnt;
> -       unsigned int dst;
> -       unsigned int src_dst_bidx;
> -       unsigned int link_bcntrld;
> -       unsigned int src_dst_cidx;
> -       unsigned int ccnt;
> -};
> +       u32 opt;
> +       u32 src;
> +       u32 a_b_cnt;
> +       u32 dst;
> +       u32 src_dst_bidx;
> +       u32 link_bcntrld;
> +       u32 src_dst_cidx;
> +       u32 ccnt;
> +} __packed;
>
>  /* fields in edmacc_param.opt */
>  #define SAM            BIT(0)

I came across this patch when I was looking at a pull request from
Sekhar for EDMA cleanups, and it made me look closer at the contents
of this file.

The include/linux/platform_data/ directory is meant to hold
platform_data definitions for drivers, and nothing more.
platform_data/edma.h also contains a whole bunch of interface
definitions for the driver. They do not belong there, and should be
moved to a different include file.

That also includes the above struct, because as far as I can tell it's
a runtime state structure, not something that is passed in with
platform data.

Can someone please clean this up? Thanks.


-Olof
