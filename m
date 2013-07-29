Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab3G2DL5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 23:11:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33293 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752533Ab3G2DLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 23:11:55 -0400
Message-ID: <1375067513.2075.27.camel@joe-AO722>
Subject: Re: [PATCH 2/3] ACPI / PM: Make messages in acpi_device_set_power()
 print device names
From: Joe Perches <joe@perches.com>
To: Lan Tianyu <lantianyu1986@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org
Date: Sun, 28 Jul 2013 20:11:53 -0700
In-Reply-To: <CAOLK0pyBsD8vR0a2mcSucnD8zFTz8ZB72OPE0R9Z67SxH9VHRw@mail.gmail.com>
References: <10433383.dueoNg39qi@vostro.rjw.lan>
	 <1895563.95T8SxMegu@vostro.rjw.lan>
	 <CAOLK0pyBsD8vR0a2mcSucnD8zFTz8ZB72OPE0R9Z67SxH9VHRw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-29 at 11:06 +0800, Lan Tianyu wrote:
> 2013/7/27 Rafael J. Wysocki <rjw@sisk.pl>:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[]
> >  drivers/acpi/device_pm.c |   22 ++++++++++------------
[]
> > @@ -166,20 +166,20 @@ int acpi_device_set_power(struct acpi_de
[]
> >         if (device->parent && (state < device->parent->power.state)) {
> > -               printk(KERN_WARNING PREFIX
> > -                             "Cannot set device to a higher-powered"
> > -                             " state than parent\n");
> > +               dev_warn(&device->dev, "Cannot transition to a higher-powered "
> > +                        "state than parent\n");

coalesce format please.


