Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbaKXVa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:30:59 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:50996 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaKXVaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:30:07 -0500
From: Anisse Astier <anisse@astier.eu>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Darren Hart <dvhart@infradead.org>, Ike Panhc <ike.pan@canonical.com>,
        Jonathan Woithe <jwoithe@just42.net>,
        Mattia Dongili <malattia@linux.it>,
        platform-driver-x86@vger.kernel.org,
        acpi4asus-user@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/1] platform: x86: Deletion of checks before backlight_device_unregister()
Date: Mon, 24 Nov 2014 22:28:32 +0100
Message-ID: <3842367.ojrMxTW2rH@path>
User-Agent: KMail/4.14.3 (Linux/3.17.3-200.fc20.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <547389A6.9090106@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net> <5317A59D.4@users.sourceforge.net> <547389A6.9090106@users.sourceforge.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

Le lundi 24 novembre 2014, 20:40:22 SF Markus Elfring a écrit :
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 24 Nov 2014 20:30:29 +0100
> 
> The backlight_device_unregister() function tests whether its argument is
> NULL and then returns immediately. Thus the test around the call is not
> needed.
> 
> This issue was detected by using the Coccinelle software.

What script was used ? Is it in scripts/coccinelle ?


> diff --git a/drivers/platform/x86/msi-wmi.c b/drivers/platform/x86/msi-wmi.c
> index 70222f2..6d2bac0 100644
> --- a/drivers/platform/x86/msi-wmi.c
> +++ b/drivers/platform/x86/msi-wmi.c
> @@ -354,8 +354,7 @@ static void __exit msi_wmi_exit(void)
>  		sparse_keymap_free(msi_wmi_input_dev);
>  		input_unregister_device(msi_wmi_input_dev);
>  	}
> -	if (backlight)
> -		backlight_device_unregister(backlight);
> +	backlight_device_unregister(backlight);
>  }
> 
>  module_init(msi_wmi_init);

For this part:
Acked-by: Anisse Astier <anisse@astier.eu>

Regards,

Anisse
