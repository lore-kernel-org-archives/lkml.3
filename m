Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab3CaGPY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 02:15:24 -0400
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:37121 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3CaGPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 02:15:21 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1364648501-5127-1-git-send-email-artem.savkov@gmail.com>
References: <1364648501-5127-1-git-send-email-artem.savkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] acpi/video: lcd_get_level_current doen't return current level
From: Danny Baumann <dannybaumann@web.de>
Date: Sun, 31 Mar 2013 08:15:14 +0200
To: Artem Savkov <artem.savkov@gmail.com>
CC: aaron.lu@intel.com, rafael.j.wysocki@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <3fb82299-bdb9-4842-bd55-f3b87d2d789e@email.android.com>
X-purgate: clean.bounce
X-purgate-type: clean.bounce
X-purgate-ID: 154106::1364710518-000004D6-73D945A5/0-0/0-18
X-Scan-AV: nick.hrz.tu-chemnitz.de;2013-03-31 08:15:18;0bbcc4aff66de68cde84b810fb117165
X-Scan-SA: nick.hrz.tu-chemnitz.de;2013-03-31 08:15:18;61669b95eaa41302b68463e310052413
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail provider
 *      (dannybaumann[at]web.de)
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Artem Savkov <artem.savkov@gmail.com> schrieb:

>acpi_video_device_lcd_get_level_current() called
>acpi_video_bqc_value_to_level()
>with "*level" as a second argument, resulting in level being returned
>based on
>initial input, not current brightness, breaking backlight controls.

I don't think this change is correct. As level was passed as parameter into the evaluation of _BQC, *level contains the AML returned brightness level afterwards, so it's correct to use it as an input to acpi_video_bqc_value_to_level(). Actually, the whole point of acpi_video_device_lcd_get_level_current() is to update device->brightness->curr, so it doesn't make sense to me to use it in that function.

What's the exact problem this patch tries to solve?

Regards,

Danny
Hi,
