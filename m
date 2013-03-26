Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab3CZRKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:10:33 -0400
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:44117 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3CZRKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:10:32 -0400
Message-ID: <5151D686.9070701@web.de>
Date: Tue, 26 Mar 2013 18:10:30 +0100
From: Danny Baumann <dannybaumann@web.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] drm/i915: Allow specifying a minimum brightness level
 for sysfs control.
References: <1364298525-4337-1-git-send-email-dannybaumann@web.de> <20130326170203.GA23549@srcf.ucam.org>
In-Reply-To: <20130326170203.GA23549@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 154106::1364317831-000004E7-68D43C5F/0-0/0-0
X-Scan-AV: cora.hrz.tu-chemnitz.de;2013-03-26 18:10:31;625c6725f6a0d3fb489f562c43620cf5
X-Scan-SA: cora.hrz.tu-chemnitz.de;2013-03-26 18:10:31;3f6e9083a0b266867468114d93140f74
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

Hi,

Am 26.03.2013 18:02, schrieb Matthew Garrett:
> On Tue, Mar 26, 2013 at 12:48:44PM +0100, Danny Baumann wrote:
>> This patch makes the behaviour of the intel_backlight backlight device
>> consistent to e.g. acpi_videoX: When writing the value 0, the set brightness
>> makes the panel content barely readable instead of turning the backlight off.
>> This matches the expectations of user space (e.g. kde-workspace or the Intel
>> X11 driver), which expects that it can use intel_backlight as a drop-in
>> replacement for acpi_videoX.
>
> I'm not quite clear what you mean here. The behaviour of "0" isn't well
> defined for the ACPI backlight driver - it's perfectly reasonable for it
> to turn the backlight off entirely. Anything assuming that "0" is still
> visible is broken.

Well, the ACPI spec says this (section B.5.2):

"
The OEM may define the number 0 as "Zero brightness" that can mean to 
turn off the lighting (e.g. LCD panel backlight) in the device. This may 
be useful in the case of an output device that can still be viewed using 
only ambient light, for example, a transflective LCD.
"

My interpretation of this is that the value 0 is supposed to still be 
visible. I'm pretty sure I saw a statement that 0 is supposed to mean 
"barely visible" somewhere, but can't find it at the moment. I'll search 
for the source of it.

Regards,

Danny
