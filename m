Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaKGS2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:28:36 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:54105 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaKGS2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:28:34 -0500
Date: Fri, 7 Nov 2014 10:28:23 -0800
From: Darren Hart <dvhart@infradead.org>
To: Giedrius Statkevicius <giedriuswork@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rafael Wysocki <rjw@rjwysocki.net>,
        Linux ACPI Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] platform: x86: remove redundant variable in hp-wireless.c
Message-ID: <20141107182822.GA62564@vmdeb7>
References: <1415144839-2035-1-git-send-email-giedriuswork@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415144839-2035-1-git-send-email-giedriuswork@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 01:47:19AM +0200, Giedrius Statkevicius wrote:
> Remove a variable because it only holds the results of a function call
> and then gets returned so instead just return the result of a function
> call.
> 
> Signed-off-by: Giedrius Statkevičius <giedriuswork@gmail.com>
> ---
>  drivers/platform/x86/hp-wireless.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/platform/x86/hp-wireless.c b/drivers/platform/x86/hp-wireless.c
> index 415348f..670c62b 100644
> --- a/drivers/platform/x86/hp-wireless.c
> +++ b/drivers/platform/x86/hp-wireless.c
> @@ -82,10 +82,7 @@ static void hpwl_notify(struct acpi_device *acpi_dev, u32 event)
>  
>  static int hpwl_add(struct acpi_device *device)
>  {
> -	int err;
> -
> -	err = hp_wireless_input_setup();
> -	return err;
> +	return hp_wireless_input_setup();

Since acpi_device_probe() does not print a warning if add() fails, it might be
preferable to print the message here, rather than ignoring it completely.

Rafael?

-- 
Darren Hart
Intel Open Source Technology Center
