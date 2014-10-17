Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaJQSYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 14:24:31 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:52108 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaJQSY3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 14:24:29 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1510578.dSiEYPPI9m@vostro.rjw.lan>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <11223831.j9KAEfSQsY@vostro.rjw.lan> <1510578.dSiEYPPI9m@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH v5 10/12] gpio: Support for unified device properties interface
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 17 Oct 2014 20:09:51 +0200
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Message-ID: <E99B44D9-C9E3-4C0B-8B18-450121793EB5@arndb.de>
X-Provags-ID: V02:K0:wQoW9OSWbYYY95Q5WpqOZxrV+ZJ6bZV263lD0FT6LwC
 IwBREbJL1LJMfVk5/64uOtrjt0Rxu3VO8oa/4oe0UEL6fkQR6W
 epInyHECEPFpfih1l3fbRjIrPMU+IoKn+QbIAWWmL2mRDT1yWE
 lt1yIWmiBXnYucSg2n3ry7cv8ec9Y3ux1z1mMaaRRTk5IiNDJW
 25KWyo0zcPA8B6+nW4/JSZM1CkZk/VmVeV52R1/rnf+U+BbkFx
 vb/ZUYMHzrTE06MXhCHwSDaZswCDUbtf+MHKFXRPCAnIUrl14F
 RMgkAhC2AqPT+iS7Io2EstEpXRMsI3I918Tmo+2EWPYEwDvmBK
 9gkF/RYb+UEeIdhGIwfceqJ4oF9qVmmR4OJkifkIe
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On October 17, 2014 2:16:00 PM CEST, "Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:
>From: Mika Westerberg <mika.westerberg@linux.intel.com>
>
>Some drivers need to deal with only firmware representation of its
>GPIOs. An example would be a GPIO button array driver where each button
>is described as a separate firmware node in device tree. Typically
>these
>child nodes do not have physical representation in the Linux device
>model.
>
>In order to help device drivers to handle such firmware child nodes we
>add dev[m]_get_named_gpiod_from_child() that takes a child firmware
>node pointer as its second argument (the first one is the parent device
>itself), finds the GPIO using whatever is the underlying firmware
>method, and requests the GPIO properly.

Could we also have a wrapper around this function without a "name" argument, using just the index?

       Arnd
