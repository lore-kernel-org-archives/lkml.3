Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaHIUjy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 16:39:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbaHIUju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 16:39:50 -0400
Date: Sat, 9 Aug 2014 22:39:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: [PATCH] Input: wacom - Fix compiler warning if !CONFIG_PM
In-Reply-To: <1407604023-7429-1-git-send-email-geert@linux-m68k.org>
Message-ID: <alpine.LNX.2.00.1408092238290.15220@pobox.suse.cz>
References: <1407604023-7429-1-git-send-email-geert@linux-m68k.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Aug 2014, Geert Uytterhoeven wrote:

> If CONFIG_PM is not set:
> 
> drivers/hid/wacom_sys.c:1436: warning: ‘wacom_reset_resume’ defined but
> not used
> 
> Protect the unused functions by #ifdef CONFIG_PM to fix this.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks Geert.

hid-wacom is in a sort of temporary mode of operation, being moved from 
Input to HID driver.

Adding Benjamin and Dmitry to CC, as this will likely still go through 
Dmitry's queue.

> ---
>  drivers/hid/wacom_sys.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
> index 3e388ec31da8..f0db7eca9023 100644
> --- a/drivers/hid/wacom_sys.c
> +++ b/drivers/hid/wacom_sys.c
> @@ -1416,6 +1416,7 @@ static void wacom_remove(struct hid_device *hdev)
>  	kfree(wacom);
>  }
>  
> +#ifdef CONFIG_PM
>  static int wacom_resume(struct hid_device *hdev)
>  {
>  	struct wacom *wacom = hid_get_drvdata(hdev);
> @@ -1436,6 +1437,7 @@ static int wacom_reset_resume(struct hid_device *hdev)
>  {
>  	return wacom_resume(hdev);
>  }
> +#endif /* CONFIG_PM */
>  
>  static struct hid_driver wacom_driver = {
>  	.name =		"wacom",
> -- 
> 1.9.1
> 

-- 
Jiri Kosina
SUSE Labs
