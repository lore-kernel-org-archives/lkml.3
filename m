Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbaEOVxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:53:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbaEOVxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:53:34 -0400
Date: Thu, 15 May 2014 14:56:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: code@slynux.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sarath Lakshman <sarathlakshman@slynux.com>
Subject: Re: [PATCH] staging: wlan-ng: Fix sparse warnings
Message-ID: <20140515215652.GB4642@kroah.com>
References: <1397407189-6648-1-git-send-email-code@slynux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397407189-6648-1-git-send-email-code@slynux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 10:09:49PM +0530, code@slynux.com wrote:
> From: Sarath Lakshman <sarathlakshman@slynux.com>

This doesn't match your From: line, why?

> 
> Fixed missed declarations for few non-static functions.
> 
> Signed-off-by: Sarath Lakshman <sarathlakshman@slynux.com>
> ---
>  drivers/staging/wlan-ng/cfg80211.c   | 1 +
>  drivers/staging/wlan-ng/prism2mgmt.h | 6 ++++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
> index f76f95c..662581c 100644
> --- a/drivers/staging/wlan-ng/cfg80211.c
> +++ b/drivers/staging/wlan-ng/cfg80211.c
> @@ -1,4 +1,5 @@
>  /* cfg80211 Interface for prism2_usb module */
> +#include "prism2mgmt.h"
>  
>  
>  /* Prism2 channel/frequency/bitrate declarations */
> diff --git a/drivers/staging/wlan-ng/prism2mgmt.h b/drivers/staging/wlan-ng/prism2mgmt.h
> index 190d390..ad049ad 100644
> --- a/drivers/staging/wlan-ng/prism2mgmt.h
> +++ b/drivers/staging/wlan-ng/prism2mgmt.h
> @@ -60,6 +60,8 @@
>  #ifndef _PRISM2MGMT_H
>  #define _PRISM2MGMT_H
>  
> +#include "hfa384x.h"
> +
>  extern int prism2_reset_holdtime;
>  extern int prism2_reset_settletime;
>  
> @@ -109,4 +111,8 @@ void prism2sta_processing_defer(struct work_struct *data);
>  void prism2sta_commsqual_defer(struct work_struct *data);
>  void prism2sta_commsqual_timer(unsigned long data);
>  
> +void prism2_connect_result(wlandevice_t *wlandev, u8 failed);
> +void prism2_disconnected(wlandevice_t *wlandev);
> +void prism2_roamed(wlandevice_t *wlandev);

What about the existing declarations of these functions?  Shouldn't they
be removed?

thanks,

greg k-h
