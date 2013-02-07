Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422777Ab3BGWhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:37:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56024 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422664Ab3BGWhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:37:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [char-misc-next 05/11] mei: bus: Call bus routines from the core code
Date: Thu, 7 Feb 2013 22:37:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com> <1360270997-7639-6-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1360270997-7639-6-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302072237.31048.arnd@arndb.de>
X-Provags-ID: V02:K0:YVgPZybswEuRgWtGoBwBQLVO+zqUohSmYJbq94we/HJ
 C8B7Udq2XIk60PmBHiOZpyo04bsGcjkW9Pdp2DybRnytP3c3/+
 hnkNlC2zH/Q/7ip+YAJalXclwWe+oD45EKgO6uogorxsjnW0kX
 hF8v3Cng8/RA/RRniicXzbiNFFONRbMpBbPYcwt9AULUXULC+k
 AmV9eNro5QfsMh2DwSlQ4Xw9O5UnefCTwkAq5DtbqJSpN8fe0+
 DNQ79//huuYBQ5lHZUoMuYD6ngu9eGVZsyCQoAokTfXy7xSfUS
 1+QxDEZpv92B8i3bfhmBG0AymVtBqJj2HvRJlrGUlRNQFr860L
 otPb+hi7b5exU22/PYrc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013, Tomas Winkler wrote:
> @@ -197,6 +197,9 @@ static int mei_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>         mei_pdev = pdev;
>         pci_set_drvdata(pdev, dev);
>  
> +       err = mei_bus_init(mei_pdev);
> +       if (err)
> +               goto deregister_mei;
>  
>         schedule_delayed_work(&dev->timer_work, HZ);
>  

This is fairly unusual, and will break if you ever have multiple mei devices
in one system, because you end up registering the bus type for each
device. I think it would be more logical to register/unregister
the bus_type from the module_init/exit functions of the module
that contains the bus_type object.

	Arnd
