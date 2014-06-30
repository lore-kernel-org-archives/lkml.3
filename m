Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbaF3LWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:22:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbaF3LWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:22:07 -0400
Date: Mon, 30 Jun 2014 13:22:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jslaby@suse.cz>
cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        jirislaby@gmail.com,
        srinivas pandruvada <srinivas.pandruvada@intel.com>
Subject: Re: [PATCH 1/1] hid: sensor-hub, fix potential memory leak
In-Reply-To: <1404120888-10692-1-git-send-email-jslaby@suse.cz>
Message-ID: <alpine.LNX.2.00.1406301322000.28307@pobox.suse.cz>
References: <1404120888-10692-1-git-send-email-jslaby@suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014, Jiri Slaby wrote:

> hsdev is not freed in sensor_hub_probe when kasprintf inside the for
> loop fails. This is because hsdev is not set to platform_data yet (to
> be freed by the code in the err_no_mem label). So free the memory
> explicitly in the 'if' branch, as this is the only place where this is
> (and will) be needed.
> 
> Reported-by: coverity
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: srinivas pandruvada <srinivas.pandruvada@intel.com>
> Cc: Jiri Kosina <jkosina@suse.cz>
> ---
>  drivers/hid/hid-sensor-hub.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
> index a8d5c8faf8cf..584e17ce80e4 100644
> --- a/drivers/hid/hid-sensor-hub.c
> +++ b/drivers/hid/hid-sensor-hub.c
> @@ -632,6 +632,7 @@ static int sensor_hub_probe(struct hid_device *hdev,
>  			if (name == NULL) {
>  				hid_err(hdev, "Failed MFD device name\n");
>  					ret = -ENOMEM;
> +					kfree(hsdev);
>  					goto err_no_mem;
>  			}
>  			sd->hid_sensor_hub_client_devs[

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
