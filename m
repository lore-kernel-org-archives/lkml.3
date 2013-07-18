Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142Ab3GRQNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:13:38 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:42827 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3GRQNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:13:36 -0400
MIME-Version: 1.0
In-Reply-To: <1374106861-3549-1-git-send-email-bleung@chromium.org>
References: <1374106861-3549-1-git-send-email-bleung@chromium.org>
Date: Thu, 18 Jul 2013 18:13:35 +0200
Message-ID: <CAC-DJzKqv7b0fdPOL5+Sx2AF7EG=2+xrq8R+UrK-ev1-sNu=Pw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Platform: x86: chromeos_laptop - Deferred Probing
From: Martin Nordholts <enselic@gmail.com>
To: Benson Leung <bleung@chromium.org>
Cc: matthew.garrett@nebula.com, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, adurbin@chromium.org,
        olofj@chromium.org, axel.lin@ingics.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/18 Benson Leung <bleung@chromium.org>
>
> The following patch series refactors the dmi check system and
> returns -EPROBE_DEFER when an expected i2c adapter is not present
> at probe time.
>
> This will allow the touchpad, touchscreen, and light sensors on
> Pixel to load even if the i915 DDC and PANEL buses are instantiated
> after chromeos_laptop.
>
> [PATCH 1/2] Platform: x86: chromeos_laptop - Restructure device associations
> [PATCH 2/2] Platform: x86: chromeos_laptop - Use deferred probing


Hi,

I have worked on the same problem for the last days and just submitted
my solution proposal for review:
http://www.mail-archive.com/platform-driver-x86@vger.kernel.org/msg04440.html

One downside with the solution in this set of patches is that more
lines are added to the driver.
By making use of the i2c_driver.detect() mechanism like in my patch,
we can actually reduce the number of lines in the driver.

Looking forward to your comments on my other solution proposal!

/ Martin
