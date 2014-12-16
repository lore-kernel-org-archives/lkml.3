Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaLPUYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 15:24:39 -0500
Received: from mail-oi0-f43.google.com ([209.85.218.43]:50319 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbaLPUYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 15:24:37 -0500
MIME-Version: 1.0
In-Reply-To: <20141216135639.GA1238@hudson.localdomain>
References: <1418624603-19054-1-git-send-email-dudley.dulixin@gmail.com>
	<1418624603-19054-10-git-send-email-dudley.dulixin@gmail.com>
	<20141216135639.GA1238@hudson.localdomain>
Date: Tue, 16 Dec 2014 12:24:37 -0800
Message-ID: <CANLzEks+hyNGy4_c+pHPW203oZUY=ms-cF3CttkW2NyRmNt8Zw@mail.gmail.com>
Subject: Re: [PATCH v15 09/12] input: cyapa: add gen5 trackpad device firmware
 update function support
From: Benson Leung <bleung@google.com>
To: Jeremiah Mahler <jmmahler@gmail.com>, Dudley Du <dudley.dulixin@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Benson Leung <bleung@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 5:56 AM, Jeremiah Mahler <jmmahler@gmail.com> wrote:
> On Mon, Dec 15, 2014 at 02:23:20PM +0800, Dudley Du wrote:
>> Add firmware image update function supported for gen5 trackpad device,
>> it can be used through sysfs update_fw interface.
>> TEST=test on Chromebooks.
>>
>> Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
>> ---
>>  drivers/input/mouse/Kconfig      |   1 +
>>  drivers/input/mouse/cyapa_gen5.c | 292 ++++++++++++++++++++++++++++++++++++++-
>>  2 files changed, 292 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
>> index d8b46b0..728490e 100644
>> --- a/drivers/input/mouse/Kconfig
>> +++ b/drivers/input/mouse/Kconfig
>> @@ -206,6 +206,7 @@ config MOUSE_BCM5974
>>  config MOUSE_CYAPA
>>       tristate "Cypress APA I2C Trackpad support"
>>       depends on I2C
>> +     select CRC_ITU_T
>>       help
>
> Just found out that if I2C_DESIGNWARE_PCI isn't enabled the touchpad
> won't work.  Verify this on your machines.  Then perhaps add a depends
> for I2C_DESIGNWARE_PCI instead of I2C since it would include the former.

This isn't strictly true on all devices, though. This is true on
DESIGNWARE_PCI based devices like the Acer C720 and the HP Chromebook
14, but on other platforms that use Cypress trackpads, such as ARM
platforms like the Samsung Chromebook Series 3 DESIGNWARE_PCI is not
required, and will just result in a driver that's never used being
built.

The specific I2C bus that's being used here shouldn't matter here...
that's more of a platform issue. In the case with Chromebooks, it
might make sense to change drivers/platform/chrome/Kconfig so that
CHROMEOS_LAPTOP depends on I2C_DESIGNWARE_PCI, maybe.

-- 
Benson Leung
Software Engineer, Chrome OS
Google Inc.
bleung@google.com
