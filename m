Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaEZMgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 08:36:14 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54409 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751537AbaEZMgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 08:36:13 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Kui Zhang <kuizhang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: rmmod thermal, unable to handle kernel NULL pointer dereference
Date: Mon, 26 May 2014 14:53:16 +0200
Message-ID: <1497452.gmjrTF0UzW@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <537C6262.5030500@intel.com>
References: <CAKx2Y1mzLesGFYz30fH8xCZTkvNGPUNYkHptYLYq_hVExoh_8g@mail.gmail.com> <537C6262.5030500@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 21, 2014 04:22:58 PM Aaron Lu wrote:
> On 05/21/2014 01:57 PM, Kui Zhang wrote:
> > Hello,
> > 
> > I get following error when rmmod thermal.
> > 
> > rmmod  thermal
> > Killed
> 
> Thanks for the report. Here is a fix patch that should solve this
> problem.
> 
> From: Aaron Lu <aaron.lu@intel.com>
> Date: Wed, 21 May 2014 16:00:42 +0800
> Subject: [PATCH] ACPI / thermal: fix workqueue destroy order
> 
> When the thermal module is to be removed, we should destroy the wq
> acpi_thermal_pm_queue after the ACPI driver's remove callback is
> executed as we will need to flush the workqueue there, or a NULL pointer
> access will be hit.
> 
> Reported-by: Kui Zhang <kuizhang@gmail.com>
> Reference: http://www.spinics.net/lists/kernel/msg1747251.html
> Cc: All applicable <stable@vger.kernel.org>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

I'm going to push this as a fix for 3.15, thanks!

> ---
>  drivers/acpi/thermal.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
> index c1e31a41f949..25bbc55dca89 100644
> --- a/drivers/acpi/thermal.c
> +++ b/drivers/acpi/thermal.c
> @@ -1278,8 +1278,8 @@ static int __init acpi_thermal_init(void)
>  
>  static void __exit acpi_thermal_exit(void)
>  {
> -	destroy_workqueue(acpi_thermal_pm_queue);
>  	acpi_bus_unregister_driver(&acpi_thermal_driver);
> +	destroy_workqueue(acpi_thermal_pm_queue);
>  
>  	return;
>  }
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
