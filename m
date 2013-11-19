Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3KSOuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:50:14 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:57031 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab3KSOuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:50:12 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-b6-528b7aa2efe2
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Jonghwan Choi <jhbird.choi@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: Re: [PATCH 4/4] PM / devfreq: Consider hibernation in pm notifier
Date: Tue, 19 Nov 2013 15:50:05 +0100
Message-id: <27161890.Zx6CiZOMr8@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1384867831-15383-1-git-send-email-jhbird.choi@samsung.com>
References: <1384867831-15383-1-git-send-email-jhbird.choi@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t9jAd1FVd1BBhPfmlvsPbKWxWJJM7dF
	74KrbBaXd81hs5hxfh+Txe3GFWwWZ05fYnVg99g56y67x5ar7SwefVtWMXp83iQXwBLFZZOS
	mpNZllqkb5fAlbHu/nH2gstcFV2tW9gbGM9xdDFyckgImEjsunWSFcIWk7hwbz1bFyMXh5DA
	IkaJn+cXsEA4LUwSy1/OZgSpYhOwkpjYvgrMFhHQlGiY1A3WwSzwglHi6ISzLCAJYQEviY9f
	FoLZLAKqEn09K5i6GDk4eAW0JE59DAQJiwp4SuzYvpINJMwp4CEx5xMnSFhIwF1iTdsVdhCb
	V0BQ4sfke2BTmAXkJfbtn8oKYetI7G+dxjaBUWAWkrJZSMpmISlbwMi8ilE0tSC5oDgpPddI
	rzgxt7g0L10vOT93EyM4sJ9J72Bc1WBxiFGAg1GJh3eCe1eQEGtiWXFl7iFGCQ5mJRHexvzu
	ICHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1utA4UE0hNLUrNTUwtSi2CyTBycUg2MPY/6Vzk+
	fHy2IUM96O35YzlJEv7BDWfWXJbaHSWQqMv+cc9Uj1i3CZ4x3hG71cLNPWZml+27Jau788tS
	m79Lg1+dFrnH0SFc6/GEJy+o55myuzJjIcOxPD+uPQWcnXl5oTFPS/Jbs/hXRDTdz2wxEtgg
	vjJcRNjvcehk95bWgtnPPrX+nKvEUpyRaKjFXFScCADpeHEVaAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Are you planning to add hibernation support to ARM?

If so then this should be stated somewhere in the patch description.

OTOH if you are not going to add hibernation support to ARM I see
a little sense in adding hibernation support to ARM-only drivers..

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

On Tuesday, November 19, 2013 10:30:31 PM Jonghwan Choi wrote:
> Frequency lock should be considered in suspend/hibernation.
> 
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/devfreq/exynos/exynos5_bus.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/devfreq/exynos/exynos5_bus.c b/drivers/devfreq/exynos/exynos5_bus.c
> index a60da3c..bd672de0 100644
> --- a/drivers/devfreq/exynos/exynos5_bus.c
> +++ b/drivers/devfreq/exynos/exynos5_bus.c
> @@ -268,6 +268,7 @@ static int exynos5_busfreq_int_pm_notifier_event(struct notifier_block *this,
>  	int err = 0;
>  
>  	switch (event) {
> +	case PM_HIBERNATION_PREPARE:
>  	case PM_SUSPEND_PREPARE:
>  		/* Set Fastest and Deactivate DVFS */
>  		mutex_lock(&data->lock);
> @@ -300,6 +301,7 @@ unlock:
>  		if (err)
>  			return NOTIFY_BAD;
>  		return NOTIFY_OK;
> +	case PM_POST_HIBERNATION:
>  	case PM_POST_RESTORE:
>  	case PM_POST_SUSPEND:
>  		/* Reactivate */

