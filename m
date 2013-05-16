Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3EPBHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:07:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:57465 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948Ab3EPBH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:07:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="303118567"
Message-ID: <1368666443.2063.22.camel@rzhang1-mobl4>
Subject: Re: ACPI fan driver: uninitialized variable when CONFIG_PM is not
 set
From: Zhang Rui <rui.zhang@intel.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Thu, 16 May 2013 09:07:23 +0800
In-Reply-To: <CANN689GoQm8dGEN6L1xuuc_aZ_65G3N7tBPbEXHjAfebB7xrLw@mail.gmail.com>
References: <CANN689GoQm8dGEN6L1xuuc_aZ_65G3N7tBPbEXHjAfebB7xrLw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Michel,

On Mon, 2013-04-29 at 05:32 -0700, Michel Lespinasse wrote:
> In the following code:
> 
> static int fan_get_cur_state(struct thermal_cooling_device *cdev, unsigned long
>                              *state)
> {
>         struct acpi_device *device = cdev->devdata;
>         int result;
>         int acpi_state;
> 
>         if (!device)
>                 return -EINVAL;
> 
>         result = acpi_bus_update_power(device->handle, &acpi_state);
>         if (result)
>                 return result;
> 
>         *state = (acpi_state == ACPI_STATE_D3 ? 0 :
>                  (acpi_state == ACPI_STATE_D0 ? 1 : -1));
>         return 0;
> }
> 
> With CONFIG_PM not set, acpi_bus_update_power() returns 0 and does not
> initialize acpi_state. This results in acpi_state being used before
> initialization.
> 
> (I found out by random chance, as I suppose people don't normally
> build without CONFIG_PM anymore ?)
> 
> I'm not sure what a proper fix would be, so I'll just report this here
> and enable CONFIG_PM locally :)
> 
thanks for your report.
please check if the following patch helps or not.
https://patchwork.kernel.org/patch/2574691/

thanks,
rui

