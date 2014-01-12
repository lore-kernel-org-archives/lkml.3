Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbaALTOm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 14:14:42 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:41761 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaALTOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 14:14:40 -0500
Date: Sun, 12 Jan 2014 11:14:36 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, linux-input@vger.kernel.org,
        vojtech@suse.cz, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Subject: Re: [PATCH 1/1] Drivers: input: serio:hyperv-keyoard:  Handle 0xE1
 prefix
Message-ID: <20140112191436.GB13131@core.coreip.homeip.net>
References: <1389498110-4790-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389498110-4790-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 07:41:50PM -0800, K. Y. Srinivasan wrote:
> Handle the 0xE1 prefix.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Applied, thank you.

> ---
>  drivers/input/serio/hyperv-keyboard.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/serio/hyperv-keyboard.c b/drivers/input/serio/hyperv-keyboard.c
> index 3a83c3c..6132619 100644
> --- a/drivers/input/serio/hyperv-keyboard.c
> +++ b/drivers/input/serio/hyperv-keyboard.c
> @@ -160,7 +160,9 @@ static void hv_kbd_on_receive(struct hv_device *hv_dev,
>  			if (info & IS_E0)
>  				serio_interrupt(kbd_dev->hv_serio,
>  						XTKBD_EMUL0, 0);
> -
> +			if (info & IS_E1)
> +				serio_interrupt(kbd_dev->hv_serio,
> +						XTKBD_EMUL1, 0);
>  			scan_code = __le16_to_cpu(ks_msg->make_code);
>  			if (info & IS_BREAK)
>  				scan_code |= XTKBD_RELEASE;
> -- 
> 1.7.4.1
> 

-- 
Dmitry
