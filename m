Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836AbaFLIbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:31:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41429 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932740AbaFLIbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:31:40 -0400
Date: Thu, 12 Jun 2014 10:29:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: rmi: Protect PM-only functions by #ifdef
 CONFIG_PM
In-Reply-To: <1402513398-17546-1-git-send-email-geert@linux-m68k.org>
Message-ID: <alpine.LNX.2.00.1406121029000.1321@pobox.suse.cz>
References: <1402513398-17546-1-git-send-email-geert@linux-m68k.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014, Geert Uytterhoeven wrote:

> If CONFIG_PM=n:
> 
> drivers/hid/hid-rmi.c:432: warning: ‘rmi_post_reset’ defined but not used
> drivers/hid/hid-rmi.c:437: warning: ‘rmi_post_resume’ defined but not used
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/hid/hid-rmi.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
> index 2451c7e5febd..578bbe65902b 100644
> --- a/drivers/hid/hid-rmi.c
> +++ b/drivers/hid/hid-rmi.c
> @@ -428,6 +428,7 @@ static int rmi_raw_event(struct hid_device *hdev,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM
>  static int rmi_post_reset(struct hid_device *hdev)
>  {
>  	return rmi_set_mode(hdev, RMI_MODE_ATTN_REPORTS);
> @@ -437,6 +438,7 @@ static int rmi_post_resume(struct hid_device *hdev)
>  {
>  	return rmi_set_mode(hdev, RMI_MODE_ATTN_REPORTS);
>  }
> +#endif /* CONFIG_PM */
>  
>  #define RMI4_MAX_PAGE 0xff
>  #define RMI4_PAGE_SIZE 0x0100

Applied, thanks for spotting it.

-- 
Jiri Kosina
SUSE Labs
