Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbaDCPFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:05:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:64636 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaDCPFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:05:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Cc: "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Linaro-acpi] How to pass I2C platform_data under ACPI
Date: Thu, 03 Apr 2014 17:05:33 +0200
Message-ID: <13098525.yKYfGA04Ut@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <D854C92F57B1B347B57E531E78D05EAD57464000@BGSMSX104.gar.corp.intel.com>
References: <D854C92F57B1B347B57E531E78D05EAD57463568@BGSMSX104.gar.corp.intel.com> <20140403135826.GF19349@intel.com> <D854C92F57B1B347B57E531E78D05EAD57464000@BGSMSX104.gar.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8nKjK5C3isFCHGV33dRJAFA/SNWS8sbdyJsllMmG8PC
 ZtCGDq6Et5GmINxjMEg5YYWmdyN4g1xZkXtKa1+LTNiMXndwQ2
 hkLD2TctaoL8oZfxCMrTKuWnKYLxSI1nQ4Q0nT+AJf0NjIWwf9
 pkOcirYdjbctH8jNZ6iFtr2R3j1IxDBGZUPSYkRnpW3jYd7A9g
 aUnejzOi+EgehxtKOvsO+VDMfW2VWBANccf8IzpzRZK+6q9TUf
 Hri4TNsMjcp4mZ0CSQ7W3b4VoNRepDkrKRUL2IK8z4buv1jVtt
 XU3o2lddjW7jbrC0pQjfZKIgoperFHY70HmuQLMXIaYQOXP89b
 1GA8QzgJcZEzTDfXbB5c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 April 2014 13:59:18 Pallala, Ramakrishna wrote:
> >> We definitely don't want per-board match entries, that does not scale.
> >> The driver should be reasonably generic and get all the necessary data 
> >> out of well-defined tables. You can have different IDs when there are 
> >> only a few cases that are actually relevant, but it has to be 
> >> conceivable that the same driver get used on future hardware without 
> >> changes.
> >
> >Yes, I meant that when the platform data information is not available
> >in ACPI namespace, then (and only then) pass the data by means of different IDs.
> >
> >Preferably this information is included in the ACPI namespace.
> 
> The idea is use the single platform_data struct  and initiaze it 
> accordingly from the driver's __init call based on the board/platform.

In general, you should think of it as being isolated from the board or
platform question, and not rely on an an initcall to do this for you.
A device driver, in particular for a device on something like an i2c
bus, should be able to figure out all the dependencies in its own
probe() function, without code on the platform side or in a specific
driver initcall.

What information it needs of course depends on the specific device,
but if you boot using FDT or ACPI, all the information you need should
be encoded in the data passed from the boot loader in a generic and
documented fashion. What data specifically do you want to pass here
that was previously encoded in platform data?

	Arnd
