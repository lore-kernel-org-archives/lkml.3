Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaF1RIb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:08:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44486 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbaF1RI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:08:28 -0400
Date: Sat, 28 Jun 2014 19:08:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Lukas M?rdian <lukas@goldelico.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "H. Nikolaus Schaller" <hns@goldelico.com>
Subject: Re: [PATCH] gpio_keys, twl4030-pwrbutton: stay awake for 1sec on
 resume
Message-ID: <20140628170820.GF23634@xo-6d-61-c0.localdomain>
References: <1403906118-23517-1-git-send-email-lukas@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403906118-23517-1-git-send-email-lukas@goldelico.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This gives the userspace (Replicant) a chance to fully handle the
> pm_wakeup_event, before autosleep suspends the system alltogether
> again.
> 
> This fixes suspend/resume on the OpenPhoenux GTA04, in combination with
> the Replicant 4.2.2 userspace, which needs to execute this to stay
> awake: 'echo on > /sys/power/state'
> 
> Signed-off-by: Lukas Märdian <lukas@goldelico.com>
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>

I'm sorry, but we should not be doing this.

You basically put a delay in driver to work around userspace bug. There must be better
solution....

										Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
