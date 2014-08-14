Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbaHNMjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 08:39:04 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8776 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbaHNMjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 08:39:01 -0400
X-IronPort-AV: E=McAfee;i="5600,1067,7529"; a="149643102"
X-IronPort-AV: E=Sophos;i="5.01,862,1400050800"; 
   d="scan'208";a="731495909"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Hans Wennborg <hans@hanshq.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ath6kl@lists.infradead.org>
Subject: Re: [PATCH 10/19] ath6kl: fix %d confusingly prefixed with 0x in format strings
References: <1407111596-14944-1-git-send-email-hans@hanshq.net>
Date: Thu, 14 Aug 2014 15:38:54 +0300
In-Reply-To: <1407111596-14944-1-git-send-email-hans@hanshq.net> (Hans
	Wennborg's message of "Sun, 3 Aug 2014 17:19:56 -0700")
Message-ID: <8738czmejl.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans Wennborg <hans@hanshq.net> writes:

> Signed-off-by: Hans Wennborg <hans@hanshq.net>
> ---
>  drivers/net/wireless/ath/ath6kl/init.c | 2 +-
>  drivers/net/wireless/ath/ath6kl/main.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
> index fffd523..91af845 100644
> --- a/drivers/net/wireless/ath/ath6kl/init.c
> +++ b/drivers/net/wireless/ath/ath6kl/init.c
> @@ -1049,7 +1049,7 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
>  			ar->hw.reserved_ram_size = le32_to_cpup(val);
>  
>  			ath6kl_dbg(ATH6KL_DBG_BOOT,
> -				   "found reserved ram size ie 0x%d\n",
> +				   "found reserved ram size ie 0x%x\n",
>  				   ar->hw.reserved_ram_size);

Actually the original intent here was to use %d.

> diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
> index 21516bc..933aef0 100644
> --- a/drivers/net/wireless/ath/ath6kl/main.c
> +++ b/drivers/net/wireless/ath/ath6kl/main.c
> @@ -225,7 +225,7 @@ int ath6kl_diag_write32(struct ath6kl *ar, u32 address, __le32 value)
>  	ret = ath6kl_hif_diag_write32(ar, address, value);
>  
>  	if (ret) {
> -		ath6kl_err("failed to write 0x%x during diagnose window to 0x%d\n",
> +		ath6kl_err("failed to write 0x%x during diagnose window to 0x%x\n",
>  			   address, value);

This is ok.

-- 
Kalle Valo
