Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab3ILVkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 17:40:20 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:52372 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3ILVkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 17:40:18 -0400
MIME-Version: 1.0
In-Reply-To: <87vc25pvvm.fsf@linaro.org>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
	<1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
	<87vc25pvvm.fsf@linaro.org>
Date: Thu, 12 Sep 2013 14:40:15 -0700
Message-ID: <CAGa+x85vxX8dbmk-8mOEQ03q6Ud1a-OfnV7t5-rNtu06vn_cSQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] i2c: prepare runtime PM support for I2C client devices
From: Kevin Hilman <khilman@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 2:34 PM, Kevin Hilman <khilman@linaro.org> wrote:
> Mika Westerberg <mika.westerberg@linux.intel.com> writes:
>
>> From: Aaron Lu <aaron.lu@intel.com>
>>
>> This patch adds runtime PM support for the I2C bus in a similar way that
>> has been done for PCI bus already. This means that the I2C bus core
>> prepares runtime PM for a client device just before a driver is about to be
>> bound to it. Devices that are not bound to any driver are not prepared for
>> runtime PM.
>>
>> In order to take advantage of this runtime PM support, the client device
>> driver needs drop the device runtime PM reference count by calling
>> pm_runtime_put() in its ->probe() callback and possibly implement rest of
>> the runtime PM callbacks.
>>
>> If the driver doesn't support runtime PM (like most of the existing I2C
>> client drivers), the device in question is regarded as being runtime PM
>> active and powered on.
>
> But for existing drivers which already support runtime PM (at least 7 by
> a quick grep), they will be stuck runtime enabled and stop hitting
> low-power states after this patch.

Oops, nevermind.  I was mixing this up with runtime PM on the i2c
adapter but this is for the i2c client.

Sorry for the noise.

Kevin
