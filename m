Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbaF1SER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:04:17 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:21309 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299AbaF1SEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 14:04:14 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jun 2014 14:04:14 EDT
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat5gtPvyo0=
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH] gpio_keys, twl4030-pwrbutton: stay awake for 1sec on resume
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=iso-8859-1
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20140628170820.GF23634@xo-6d-61-c0.localdomain>
Date: Sat, 28 Jun 2014 19:57:53 +0200
Cc: Lukas M?rdian <lukas@goldelico.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Marek Belisko <marek@goldelico.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <BD5D0538-BD03-4CD8-8E12-2344AD7ED669@goldelico.com>
References: <1403906118-23517-1-git-send-email-lukas@goldelico.com> <20140628170820.GF23634@xo-6d-61-c0.localdomain>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Am 28.06.2014 um 19:08 schrieb Pavel Machek:

> Hi!
> 
>> This gives the userspace (Replicant) a chance to fully handle the
>> pm_wakeup_event, before autosleep suspends the system alltogether
>> again.
>> 
>> This fixes suspend/resume on the OpenPhoenux GTA04, in combination with
>> the Replicant 4.2.2 userspace, which needs to execute this to stay
>> awake: 'echo on > /sys/power/state'
>> 
>> Signed-off-by: Lukas Märdian <lukas@goldelico.com>
>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> 
> I'm sorry, but we should not be doing this.
> 
> You basically put a delay in driver to work around userspace bug.

Do you think it is a user-space bug if the kernel goes to sleep again
before giving user space any chance to react to an event?

And the msec parameter is described as:

@msec: Anticipated event processing time (in milliseconds).

Isn't calling pm_wakeup_event() with a non-zero msec the standard
method to handle this situation? And it is used in other drivers. E.g. in
_mmc_detect_change() or hub_suspend().

And if I understand the code of __pm_wakeup_event() correctly it does
*not* delay, but just modifies the wakeup_source timer to expire a little
later. I.e. keep the system longer awake. So as long as the system is
not suspended there is no difference to current driver.

> There must be better
> solution....

I am not sure how it could look like.

-- hns