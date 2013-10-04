Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab3JGMCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:02:54 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:56728 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab3JGMCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 08:02:49 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 23/28] of: introduce common FDT machine related functions
To: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <1379372965-22359-24-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com> <1379372965-22359-24-git-send-email-robherring2@gmail.com>
Date: Fri, 04 Oct 2013 19:49:59 +0100
Message-Id: <20131004184959.CAA4EC42926@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep 2013 18:09:19 -0500, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Introduce common of_flat_dt_match_machine and
> of_flat_dt_get_machine_name functions to unify architectures' handling
> of machine level model and compatible properties.
> 
> Several architectures match the root compatible string with an arch
> specific list of machine descriptors duplicating the same search
> algorithm. Create a common implementation with a simple architecture
> specific hook to iterate over each machine's match table.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> ---
>  drivers/of/fdt.c       | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of_fdt.h |  4 ++++
>  2 files changed, 64 insertions(+)
> 
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index 83cdeb5..e21d1dc 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -619,6 +619,66 @@ int __init of_scan_flat_dt_by_path(const char *path,
>  		return ret;
>  }
>  
> +const char *of_flat_dt_get_machine_name(void)

Just discovered that this needs to be __init.

g.
