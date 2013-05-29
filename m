Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934464Ab3E2QTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 12:19:00 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:4655 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757730Ab3E2QSx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 12:18:53 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 5
X-BigFish: VPS5(zz98dIc89bh1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh906i192cn1155h)
Date: Wed, 29 May 2013 09:18:39 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
CC: <linux-kernel@vger.kernel.org>, Michal Simek <monstr@monstr.eu>,
        Pallav Joshi <pallav.joshi@xilinx.com>, <git-dev@xilinx.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] video: xilinxfb: Fix OF probing on little-endian
 systems
References: <502367ddf6d79b7b343b3165ad54cb9e2d4713db.1369843969.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <502367ddf6d79b7b343b3165ad54cb9e2d4713db.1369843969.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <fbca0735-c7df-4d44-a429-a2042ed6324a@CO9EHSMHS021.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 06:12:56PM +0200, Michal Simek wrote:
> From: Michal Simek <monstr@monstr.eu>
> 
> DTB is always big-endian that's why is necessary
> to convert it.
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>  drivers/video/xilinxfb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
> index af0b4fd..5af341e 100644
> --- a/drivers/video/xilinxfb.c
> +++ b/drivers/video/xilinxfb.c
> @@ -428,7 +428,7 @@ static int xilinxfb_of_probe(struct platform_device *op)
>  	 * interface and initialize the tft_access accordingly.
>  	 */
>  	p = (u32 *)of_get_property(op->dev.of_node, "xlnx,dcr-splb-slave-if", NULL);
You should consider using 'of_property_read_u32() (or one of its other
variants for arrays, strings, etc). That already implicitly does the
endian conversion.

	Sören


