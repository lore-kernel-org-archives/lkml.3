Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964882AbaLKPqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:46:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933278AbaLKPqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:46:12 -0500
Date: Thu, 11 Dec 2014 10:25:17 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Peter Wu <peter@lekensteyn.nl>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] HID: logitech-hidpp: add boundary check for name
 retrieval
Message-ID: <20141211152517.GE29747@mail.corp.redhat.com>
References: <1418302280-14794-1-git-send-email-peter@lekensteyn.nl>
 <1418302280-14794-4-git-send-email-peter@lekensteyn.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1418302280-14794-4-git-send-email-peter@lekensteyn.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 11 2014 or thereabouts, Peter Wu wrote:
> The HID response has a limited size. Do not trust the value returned by
> hardware, check that it really fits in the message.
> 
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> ---

Well spotted!

Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Cheers,
Benjamin


>  drivers/hid/hid-logitech-hidpp.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> index 4d72c20..4292cc3 100644
> --- a/drivers/hid/hid-logitech-hidpp.c
> +++ b/drivers/hid/hid-logitech-hidpp.c
> @@ -313,6 +313,9 @@ static char *hidpp_get_unifying_name(struct hidpp_device *hidpp_dev)
>  
>  	len = response.rap.params[1];
>  
> +	if (2 + len > sizeof(response.rap.params))
> +		return NULL;
> +
>  	name = kzalloc(len + 1, GFP_KERNEL);
>  	if (!name)
>  		return NULL;
> -- 
> 2.1.3
> 
