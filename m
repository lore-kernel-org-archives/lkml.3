Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbaDKNlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:41:19 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:53737 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539AbaDKNlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:41:14 -0400
X-Originating-IP: 50.43.32.211
Date: Fri, 11 Apr 2014 06:41:05 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Neil Armstrong <superna9999@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Himangi Saraogi <himangi774@gmail.com>,
        Tugce Sirin <ztugcesirin@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wlan-ng: fix bad symbol declaration
Message-ID: <20140411134104.GA29002@leaf>
References: <5347E781.3030309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5347E781.3030309@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 03:00:49PM +0200, Neil Armstrong wrote:
> With sparse, the following error appears :
>   CHECK   drivers/staging/wlan-ng/p80211netdev.c
> drivers/staging/wlan-ng/cfg80211.c:710:6: warning: symbol 'prism2_connect_result' was not declared. Should it be static?
> drivers/staging/wlan-ng/cfg80211.c:719:6: warning: symbol 'prism2_disconnected' was not declared. Should it be static?
> drivers/staging/wlan-ng/cfg80211.c:725:6: warning: symbol 'prism2_roamed' was not declared. Should it be static?
> 
> Move functions declaration to coherent internal header file.
> 
> Signed-off-by: Neil 'Superna' Armstrong <superna9999@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/staging/wlan-ng/prism2mgmt.h |    5 +++++
>  drivers/staging/wlan-ng/prism2sta.c  |    4 ----
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/prism2mgmt.h b/drivers/staging/wlan-ng/prism2mgmt.h
> index 190d390..b62fdcb 100644
> --- a/drivers/staging/wlan-ng/prism2mgmt.h
> +++ b/drivers/staging/wlan-ng/prism2mgmt.h
> @@ -109,4 +109,9 @@ void prism2sta_processing_defer(struct work_struct *data);
>  void prism2sta_commsqual_defer(struct work_struct *data);
>  void prism2sta_commsqual_timer(unsigned long data);
>  
> +/* Interface callback functions, passing data back up to the cfg80211 layer */
> +void prism2_connect_result(wlandevice_t *wlandev, u8 failed);
> +void prism2_disconnected(wlandevice_t *wlandev);
> +void prism2_roamed(wlandevice_t *wlandev);
> +
>  #endif
> diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
> index f9ccf23..3fd4538 100644
> --- a/drivers/staging/wlan-ng/prism2sta.c
> +++ b/drivers/staging/wlan-ng/prism2sta.c
> @@ -120,10 +120,6 @@ MODULE_PARM_DESC(prism2_reset_settletime, "reset settle time in ms");
>  
>  MODULE_LICENSE("Dual MPL/GPL");
>  
> -void prism2_connect_result(wlandevice_t *wlandev, u8 failed);
> -void prism2_disconnected(wlandevice_t *wlandev);
> -void prism2_roamed(wlandevice_t *wlandev);
> -
>  static int prism2sta_open(wlandevice_t *wlandev);
>  static int prism2sta_close(wlandevice_t *wlandev);
>  static void prism2sta_reset(wlandevice_t *wlandev);
> -- 
> 1.7.10.4
