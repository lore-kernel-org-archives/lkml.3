Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab3H1XIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 19:08:46 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:52685 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab3H1XIp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 19:08:45 -0400
From: Jerome Oufella <jerome.oufella@savoirfairelinux.com>
To: Chris Rodley <chris@snapithd.com>
Cc: kernel@savoirfairelinux.com, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: sht15 kernel driver
References: <521E7CA7.5060407@snapithd.com>
Date: Wed, 28 Aug 2013 19:08:42 -0400
In-Reply-To: <521E7CA7.5060407@snapithd.com> (Chris Rodley's message of "Thu,
	29 Aug 2013 10:41:43 +1200")
Message-ID: <87fvtt4dmt.fsf@jerows.sfl>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Rodley <chris@snapithd.com> writes:

> Hi,
>
> I am trying to get a sht75 humidity and temperature sensor working
> with the linux kernel module in 3.2.
> Is there a code example for application code that you have available?
>
> Many thanks,

Hi Chris,

There was much less support for the sht15 back in 3.2 compared to recent
kernel releases. You may want to backport features and/or fixes to suit
your needs.

You can find a usage example for 3.2 in arch/arm/mach-pxa/stargate2.c
around line 140:

First, create a platform data struct and specify which GPIO lines are
hooked to the data and sck lines of your sht-15:
 
 static struct sht15_platform_data platform_data_sht15 = {
        .gpio_data =  100,
        .gpio_sck  =  98,
 };

Then setup a platform device referencing those platform data, that you
will have to register on the platform bus using platform_add_devices()
or equivalent:

 static struct platform_device sht15 = {
        .name = "sht15",
        .id = -1,
        .dev = {
                .platform_data = &platform_data_sht15,
        },
 };

 ...

 platform_add_devices(...);



Cheers,
-- 
Jérôme Oufella
@: jerome.oufella@savoirfairelinux.com
T: 514-276-5468 ext. 125
