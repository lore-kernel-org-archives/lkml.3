Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab3CRIW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 04:22:28 -0400
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:59684 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3CRIW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 04:22:26 -0400
Message-ID: <5146CEBE.3070909@web.de>
Date: Mon, 18 Mar 2013 09:22:22 +0100
From: Danny Baumann <dannybaumann@web.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH v2 1/3] ACPI video: Fix brightness control initialization
 for some laptops.
References: <1363342248-6496-1-git-send-email-dannybaumann@web.de> <5146C1B4.4050907@intel.com>
In-Reply-To: <5146C1B4.4050907@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 154106::1363594943-000004E7-3E686271/0-0/0-0
X-Scan-AV: cora.hrz.tu-chemnitz.de;2013-03-18 09:22:23;1a2a2a490ebf7d1eb9df0e1a1b7e4aef
X-Scan-SA: cora.hrz.tu-chemnitz.de;2013-03-18 09:22:23;6ab94d1d40c9be58ca43cc2d7e0d6905
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 *  0.0 TVD_RCVD_IP TVD_RCVD_IP
 *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail provider
 *      (dannybaumann[at]web.de)
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
>> index 313f959..9c33871 100644
>> --- a/drivers/acpi/video.c
>> +++ b/drivers/acpi/video.c
>> @@ -222,7 +222,7 @@ static int acpi_video_device_lcd_set_level(struct acpi_video_device *device,
>>   			int level);
>>   static int acpi_video_device_lcd_get_level_current(
>>   			struct acpi_video_device *device,
>> -			unsigned long long *level, int init);
>> +			unsigned long long *level, int raw);
>
> Why not bool?

For two reasons:
- It previous was int ;-)
- It allowed the invocations of this function to fit within one 80-char 
line.

Neither reason is terribly strong, so if you prefer, I can convert this 
argument to bool.

Regards,

Danny
