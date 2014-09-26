Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbaIZEfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 00:35:08 -0400
Received: from mail-yk0-f172.google.com ([209.85.160.172]:50075 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbaIZEfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 00:35:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140926030126.GA40523@vmdeb7>
References: <1411518268-2773-1-git-send-email-coproscefalo@gmail.com>
	<1411518268-2773-2-git-send-email-coproscefalo@gmail.com>
	<20140926030126.GA40523@vmdeb7>
Date: Thu, 25 Sep 2014 22:35:04 -0600
Message-ID: <CAGdLNWEWu6wo_oD9WZMM1pgTV94uRWvteukNr5XmACVOgdO=1Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] toshiba_acpi: Rename hci_raw to tci_raw
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-25 21:01 GMT-06:00 Darren Hart <dvhart@infradead.org>:
> On Tue, Sep 23, 2014 at 06:24:25PM -0600, Azael Avalos wrote:
>> The function name hci_raw was used before to reflect
>> a raw (read/write) call to the Toshiba's Hardware
>> Configuration Interface (HCI), however, since the
>> introduction of the System Configuration Interface
>> (SCI), that "name" no longer applies.
>>
>> This patch changes the name of that function to
>> tci_raw (for Toshiba Configuration Interface), and
>> change the comments about it.
>
> I'm not following the motivation for this change. The HCI clearly still exists,
> at least on the platforms this driver was written to support. When/Where was the
> "SCI" "introduced" in a way that requires a change here? Was this a change by
> Toshiba you are refering to?

The HCI and SCI form an integral part of the Toshiba configuration scheme,
the SCI has been present on any Toshiba branded laptop to date, what
was not present (at least on toshiba_acpi) was (propper) SCI support
until the patches I sent.

Take a look at Jonathan Buzzard documentation [1], and also the toshiba
module under char, the documentation was written in 1999, and the
module has a (starting) date of 1996.

By the time toshiba_acpi was written, only HCI functions were accessed,
as well as the configuration handle was (and still is, depending on model)
named GHCI, and so the comments refer to it, now that we have SCI
(driver support) on board, the naming seems obsolete, or at least
misguiding, as the HCI is not the only configuration interface.

Hope this clears things a bit.

[1] http://www.buzzard.me.uk/toshiba/docs.html

>
>
>>
>> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
>> ---
>>  drivers/platform/x86/toshiba_acpi.c | 40 ++++++++++++++++++-------------------
>>  1 file changed, 20 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
>> index edd8f3d..b7030dc 100644
>> --- a/drivers/platform/x86/toshiba_acpi.c
>> +++ b/drivers/platform/x86/toshiba_acpi.c
>> @@ -71,7 +71,7 @@ MODULE_LICENSE("GPL");
>>  /* Toshiba ACPI method paths */
>>  #define METHOD_VIDEO_OUT     "\\_SB_.VALX.DSSX"
>>
>> -/* Toshiba HCI interface definitions
>> +/* Toshiba configuration interface definitions
>>   *
>>   * HCI is Toshiba's "Hardware Control Interface" which is supposed to
>
> I'm not sure this patch is appropriate/necessary, but if so, you missed a spot
> here :)

Oh no, this is intentional, what I probably should have done here is be more
verbose about it, perhaps something like:

/*
 * The Toshiba configuration interface is composed of the HCI and the
 * SCI, which are defined as
...

>
> --
> Darren Hart
> Intel Open Source Technology Center


Cheers
Azael

-- 
-- El mundo apesta y vosotros apestais tambien --
