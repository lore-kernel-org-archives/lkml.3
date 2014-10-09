Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaJIS2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 14:28:45 -0400
Received: from hauke-m.de ([5.39.93.123]:59542 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbaJIS2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 14:28:35 -0400
Message-ID: <5436D3CF.2030506@hauke-m.de>
Date: Thu, 09 Oct 2014 20:28:31 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Arend van Spriel <arend@broadcom.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] bcma: Add dependency on OF_ADDRESS
References: <1412872877-1771-1-git-send-email-linux@roeck-us.net> <CACna6rzOeGcKrrftLx_3uWe_bAXQaQMmWb3wWHP0CjtdO8D0eg@mail.gmail.com> <5436C2B4.6030801@broadcom.com> <5436C367.5080908@broadcom.com> <20141009172924.GD2410@roeck-us.net>
In-Reply-To: <20141009172924.GD2410@roeck-us.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2014 07:29 PM, Guenter Roeck wrote:
> On Thu, Oct 09, 2014 at 07:18:31PM +0200, Arend van Spriel wrote:
>> On 10/09/14 19:15, Arend van Spriel wrote:
>>> On 10/09/14 18:54, Rafał Miłecki wrote:
>>>> On 9 October 2014 18:41, Guenter Roeck<linux@roeck-us.net> wrote:
>>>>> Commit 2101e533f41a ("bcma: register bcma as device tree driver")
>>>>> introduces a hard dependency on OF_ADDRESS into the bcma driver.
>>>>> OF_ADDRESS is specifically disabled for the sparc architecture.
>>>>> This results in the following error when building sparc64:allmodconfig.
>>>
>>> Does this mean on sparc (using allmodconfig) you will get CONFIG_OF and
>>> !CONFIG_OF_ADDRESS? Does that makes sense?
>>
>> Is CONFIG_OF is used on sparc to access OpenBoot information?
>>
> I have no idea. All I know is that the driver doesn't build anymore with OF
> enabled and OF_ADDRESS disabled.

Device tree support in bcma is only needed on some SoC, when this is
used on a PCIe card it is not needed.

I would just deactivate the parts that are using device tree in bcma
when it is not available. I will send a patch after having something to eat.

Is there a better method which is compatible with SPARC than using
of_translate_address() to get the reg address and also take the ranges
attribute of the bus into account?

Hauke
