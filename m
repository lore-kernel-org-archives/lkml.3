Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaEIHXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:23:53 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:35579 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaEIHXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:23:51 -0400
MIME-Version: 1.0
In-Reply-To: <3786444.hNhCASz73P@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1405081718200.995-100000@iolanthe.rowland.org>
	<2356017.WpDFDYKWcr@vostro.rjw.lan>
	<4232134.uNVe9bptuo@vostro.rjw.lan>
	<3786444.hNhCASz73P@vostro.rjw.lan>
Date: Fri, 9 May 2014 09:23:50 +0200
Message-ID: <CAPDyKFo7zODwqHxzTuLcnF5sOXNRh5-VHvRdOidBnkPs+airDg@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/3] PM / sleep: Flag to speed up suspend-resume of
 runtime-suspended devices
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

> @@ -1485,3 +1486,10 @@ out:
>         return ret;
>  }
>  EXPORT_SYMBOL_GPL(pm_runtime_force_resume);
> +
> +void pm_set_direct_resume(struct device *dev, bool val)
> +{
> +       spin_lock_irq(&dev->power.lock);
> +       __set_direct_resume(dev, val);
> +       spin_unlock_irq(&dev->power.lock);
> +}

I believe you have to move the implementation of this function inside
#ifdef CONFIG_PM_RUNTIME.

Kind regards
Ulf Hansson
