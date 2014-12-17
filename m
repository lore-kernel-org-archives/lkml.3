Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaLQRRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 12:17:09 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:48254 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaLQRRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 12:17:07 -0500
Message-ID: <5491BA90.9040007@gmail.com>
Date: Wed, 17 Dec 2014 11:17:04 -0600
From: Dinh Nguyen <dinh.linux@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ley Foon Tan <lftan@altera.com>, Suman Anna <s-anna@ti.com>
CC: Jassi Brar <jassisinghbrar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH (resend)] mailbox: Add Altera mailbox driver
References: <1418378690-3466-1-git-send-email-lftan@altera.com>	<548AFDE9.6000909@gmail.com>	<548F4A99.7040409@ti.com> <CAFiDJ5-b9qsLKj8Qh2+yx8_Y1nv5CG1PHyn2Se0zzZLSHWTKNg@mail.gmail.com>
In-Reply-To: <CAFiDJ5-b9qsLKj8Qh2+yx8_Y1nv5CG1PHyn2Se0zzZLSHWTKNg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/16/14, 12:33 AM, Ley Foon Tan wrote:
> On Tue, Dec 16, 2014 at 4:54 AM, Suman Anna <s-anna@ti.com> wrote:
>> Hi Ley Foon,
>>
>> On 12/12/2014 08:38 AM, Dinh Nguyen wrote:
>>>
>>>
>>> On 12/12/14, 4:04 AM, Ley Foon Tan wrote:
>>>> The Altera mailbox allows for interprocessor communication. It supports
>>>> only one channel and work as either sender or receiver.
>>
>> I have a few more comments in addition to those that Dinh provided.
>>
>>>>
>>>> Signed-off-by: Ley Foon Tan <lftan@altera.com>
>>>> ---
>>>>  .../devicetree/bindings/mailbox/altera-mailbox.txt |  49 +++
>>>>  drivers/mailbox/Kconfig                            |   6 +
>>>>  drivers/mailbox/Makefile                           |   2 +
>>>>  drivers/mailbox/mailbox-altera.c                   | 404 +++++++++++++++++++++
>>>>  4 files changed, 461 insertions(+)
>>>>  create mode 100644 Documentation/devicetree/bindings/mailbox/altera-mailbox.txt
>>>>  create mode 100644 drivers/mailbox/mailbox-altera.c
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/mailbox/altera-mailbox.txt b/Documentation/devicetree/bindings/mailbox/altera-mailbox.txt
>>>> new file mode 100644
>>>> index 0000000..c261979
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/mailbox/altera-mailbox.txt
>>>> @@ -0,0 +1,49 @@
>>>> +Altera Mailbox Driver
>>>> +=====================
>>>> +
>>>> +Required properties:
>>>> +- compatible :      "altr,mailbox-1.0".
>>

<snip>

>>>> +static const struct of_device_id altera_mbox_match[] = {
>>>> +    { .compatible = "altr,mailbox-1.0" },
>>>> +    { /* Sentinel */ }
>>>> +};
>>>> +
>>>> +MODULE_DEVICE_TABLE(of, altera_mbox_match);
>>>> +
>>>> +static struct platform_driver altera_mbox_driver = {
>>>> +    .probe  = altera_mbox_probe,
>>>> +    .remove = altera_mbox_remove,
>>>> +    .driver = {
>>>> +            .name   = DRIVER_NAME,
>>>> +            .owner  = THIS_MODULE,
>>>> +            .of_match_table = altera_mbox_match,
>>
>> of_match_ptr(altera_mbox_match).
> Okay.

This driver is DT-only, so of_match_ptr() is not needed.

Dinh
