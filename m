Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaFWW1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 18:27:20 -0400
Received: from lekensteyn.nl ([178.21.112.251]:35170 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbaFWW1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 18:27:18 -0400
From: Peter Wu <peter@lekensteyn.nl>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 0/6] rtlwifi: Fix incorrect MSR mask
Date: Tue, 24 Jun 2014 00:26:56 +0200
Message-ID: <2124336.rxQ7Vr5PF1@al>
User-Agent: KMail/4.13.2 (Linux/3.15.0-rc8-custom-00058-gd2cfd31; KDE/4.13.2; x86_64; ; )
In-Reply-To: <1403560098-7520-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1403560098-7520-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Score: -0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2014 23:48:16 Rickard Strandqvist wrote:
> An error was found in many rtlwifi drivers where an invalid mask was used,
> (bt_msr & 0xfc) will never match 0x3. This has been corrected by supplying
> a valid mask as a macro. Drivers which did not have this bug are still
> modified for consistency.

LGTM for all 6 patches. Reviewed-by was added with permission in a
private conversation.

> Rickard Strandqvist (1):
>   rtlwifi: Fix media status register mask AND Replace magic number by macro

This looks a bit unfortunate, next time just wipe old patches and
generate new ones with git-format-patch, then use the command
git-send-email patches/*. In that way, the threading stays intact.

Kind regards,
Peter

>  drivers/net/wireless/rtlwifi/rtl8188ee/hw.c  |    2 +-
>  drivers/net/wireless/rtlwifi/rtl8188ee/reg.h |    1 +
>  drivers/net/wireless/rtlwifi/rtl8192ce/hw.c  |    2 +-
>  drivers/net/wireless/rtlwifi/rtl8192ce/reg.h |    1 +
>  drivers/net/wireless/rtlwifi/rtl8192cu/hw.c  |    2 +-
>  drivers/net/wireless/rtlwifi/rtl8192de/hw.c  |    2 +-
>  drivers/net/wireless/rtlwifi/rtl8192de/reg.h |    1 +
>  drivers/net/wireless/rtlwifi/rtl8723ae/hw.c  |    2 +-
>  drivers/net/wireless/rtlwifi/rtl8723ae/reg.h |    1 +
>  drivers/net/wireless/rtlwifi/rtl8723be/hw.c  |    2 +-
>  drivers/net/wireless/rtlwifi/rtl8723be/reg.h |    1 +
>  drivers/staging/rtl8821ae/rtl8821ae/hw.c     |    2 +-
>  drivers/staging/rtl8821ae/rtl8821ae/reg.h    |    1 +
>  13 files changed, 13 insertions(+), 7 deletions(-)

