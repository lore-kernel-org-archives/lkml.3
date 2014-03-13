Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbaCMEqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 00:46:37 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:40408 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaCMEqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 00:46:36 -0400
MIME-Version: 1.0
In-Reply-To: <1394456094-21671-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1394456094-21671-1-git-send-email-mika.westerberg@linux.intel.com>
 <1394456094-21671-2-git-send-email-mika.westerberg@linux.intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 13 Mar 2014 13:46:15 +0900
Message-ID: <CAAVeFuLSqMvi5o-n+6Dif+tBbPb-zASzibkTgLMbn3uu2GfuXg@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] gpiolib: Allow GPIO chips to request their own GPIOs
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lan Tianyu <tianyu.lan@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 9:54 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> Sometimes it is useful to allow GPIO chips themselves to request GPIOs they
> own through gpiolib API. One use case is ACPI ASL code that should be able
> to toggle GPIOs through GPIO operation regions.
>
> We can't use gpio_request() because it will pin the module to the kernel
> forever (it calls try_module_get()). To solve this we move module refcount
> manipulation to gpiod_request() and let __gpiod_request() handle the actual
> request. This changes the sequence a bit as now try_module_get() is called
> outside of gpio_lock (I think this is safe, try_module_get() handles
> serialization it needs already).
>
> Then we provide gpiolib internal functions gpiochip_request/free_own_desc()
> that do the same as gpio_request() but don't manipulate module refrence
> count. This allows the GPIO chip driver to request and free descriptors it
> owns without being pinned to the kernel forever.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>

The change is clear and does not add too much complexity to the code,
so no reason to oppose it.
