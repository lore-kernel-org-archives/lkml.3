Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3AOGUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 01:20:16 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:56011 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab3AOGUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 01:20:04 -0500
Date: Mon, 14 Jan 2013 22:20:04 -0800
From: Olof Johansson <olof@lixom.net>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-mmc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Will Newton <will.newton@imgtec.com>, Chris Ball <cjb@laptop.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 1/5] mmc: dw_mmc: Add "disable-wp" device tree property
Message-ID: <20130115062004.GA19801@quad.lixom.net>
References: <1357842269-15062-1-git-send-email-dianders@chromium.org>
 <1357923834-31641-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357923834-31641-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 09:03:50AM -0800, Doug Anderson wrote:
> The "disable-wp" property is used to specify that a given SD card slot
> doesn't have a concept of write protect.  This eliminates the need for
> special case code for SD slots that should never be write protected
> (like a micro SD slot or a dev board).
> 
> The dw_mmc driver is special in needing to specify "disable-wp"
> because the lack of a "wp-gpios" property means to use the special
> purpose write protect line.  On some other mmc devices the lack of
> "wp-gpios" means that write protect should be disabled.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Acked-by: Seungwon Jeon <tgih.jun@samsung.com>

Acked-by: Olof Johansson <olof@lixom.net>

Nit below.

> @@ -825,7 +828,13 @@ static int dw_mci_get_ro(struct mmc_host *mmc)
>  	struct dw_mci_board *brd = slot->host->pdata;
>  
>  	/* Use platform get_ro function, else try on board write protect */
> -	if (brd->quirks & DW_MCI_QUIRK_NO_WRITE_PROTECT)
> +
> +	/*
> +	 * NOTE: DW_MCI_QUIRK_NO_WRITE_PROTECT will be removed in a future
> +	 * patch in the series once reference to it is removed.
> +	 */
> +	if ((brd->quirks & DW_MCI_QUIRK_NO_WRITE_PROTECT) ||
> +	    (slot->quirks & DW_MCI_SLOT_QUIRK_NO_WRITE_PROTECT))

Given that it never worked properly, you could have nuked it first and avoid
the extra churn. Still, not a strong enough reason to respin the series, IMHO.


-Olof
