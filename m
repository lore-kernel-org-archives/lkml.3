Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab3CZRgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:36:00 -0400
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:33988 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab3CZRf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:35:59 -0400
X-Greylist: delayed 1878 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Mar 2013 13:35:58 EDT
Message-ID: <5151D525.3040807@web.de>
Date: Tue, 26 Mar 2013 18:04:37 +0100
From: Danny Baumann <dannybaumann@web.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/1] drm/i915: Allow specifying a minimum brightness level
 for sysfs control.
References: <1364298525-4337-1-git-send-email-dannybaumann@web.de> <1364298525-4337-2-git-send-email-dannybaumann@web.de> <20130326151313.GU9021@phenom.ffwll.local> <20130326152029.GA993@cantiga.alporthouse.com>
In-Reply-To: <20130326152029.GA993@cantiga.alporthouse.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 154106::1364317478-000004D6-9458920D/0-0/0-0
X-Scan-AV: nick.hrz.tu-chemnitz.de;2013-03-26 18:04:38;58a6677e882c524eca54db051d9d8f40
X-Scan-SA: nick.hrz.tu-chemnitz.de;2013-03-26 18:04:38;2b164ff87e2e0812db17fe8e3af36ca9
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

>> Thus far our assumption always was that the acpi backlight works better
>> than the intel native backlight. So everything only uses the intel
>> backlight if there's no other backlight driver by default.
>
> There are machines, such as the pnv netbook on my desk, on which
> intel_backlight does nothing and the only control is through
> acpi_backlight0.

That's fine - but on my machine, (at least currently) it's the other way 
around. acpi_video[0|1] do nothing, while intel_backlight is the only 
method that works. This sucks (please also see my reply to Daniel), but 
it's a fact.

> Generalising expected behaviour based on one firmware
> implementation is fraught with danger.

I'm not sure what you mean here. I interpret the statement as 'user 
space should treat acpi_videoX and intel_backlight differently'. Is this 
interpretation correct?
If so, how is user space supposed to know how the respective backlight 
device will behave, as this behaviour might change at any point in time 
if there's no understanding in how it _should_ behave? What currently 
happens on my machine is that KDE completely turns off the backlight 
after the dim timeout, because it assumes that the value 0 will keep the 
backlight at a readable level (which would be the case if it used 
acpi_videoX because this behaviour is mandated by the spec there). I 
first thought of sending a patch to KDE, but I couldn't figure out how 
KDE is _supposed_ to correctly handle the situation, especially given 
that the actual sysfs interface used is abstracted away by Xrandr (and 
chosen by the Intel Xorg driver). With my patch, intel_backlight behaves 
in a way that roughly matches the behaviour mandated by the ACPI spec.
Do you have a way in mind that allows fixing this in user space?

Thanks,

Danny
