Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab3KYUth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 15:49:37 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:36196 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab3KYUtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 15:49:35 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <5293AD4B.6030401@infradead.org>
References: <1385408226-22369-1-git-send-email-olof@lixom.net>
	<5293AD4B.6030401@infradead.org>
Date: Mon, 25 Nov 2013 12:49:34 -0800
Message-ID: <CAOesGMhPYq4i9j3iTSPvi5iAB5rEBxmdFdj57QsKLPeOVg+Pyg@mail.gmail.com>
Subject: Re: [PATCH] platform/chrome: Add pstore platform_device
From: Olof Johansson <olof@lixom.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, Benson Leung <bleung@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 12:04 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 11/25/13 11:37, Olof Johansson wrote:
>> Add the ramoops pstore device so that we get logs of panics across reboots.
>>
>> Signed-off-by: Olof Johansson <olof@lixom.net>
>> ---
>>
>>  drivers/platform/chrome/Kconfig           |  14 +++++
>>  drivers/platform/chrome/Makefile          |   1 +
>>  drivers/platform/chrome/chromeos_pstore.c | 101 ++++++++++++++++++++++++++++++
>>  3 files changed, 116 insertions(+)
>>  create mode 100644 drivers/platform/chrome/chromeos_pstore.c
>>
>> diff --git a/drivers/platform/chrome/Kconfig b/drivers/platform/chrome/Kconfig
>> index b13303e75a34..06c53c8132ad 100644
>> --- a/drivers/platform/chrome/Kconfig
>> +++ b/drivers/platform/chrome/Kconfig
>> @@ -25,4 +25,18 @@ config CHROMEOS_LAPTOP
>>         If you have a supported Chromebook, choose Y or M here.
>>         The module will be called chromeos_laptop.
>>
>> +config CHROMEOS_PSTORE
>> +     tristate "Chrome OS pstore support"
>> +     ---help---
>> +       This module instantiates the persistent storage on x86 ChromeOS
>> +       devices. It can be used to store away console logs and crash
>> +       information across reboots.
>> +
>> +       The range of memory used is 0xf00000-0x1000000, tradionally the
>
>                                                           traditionally

Thanks! Fixed in-tree but won't repost if this is the only feedback.


-Olof
