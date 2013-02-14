Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761306Ab3BNP5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 10:57:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:57719 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab3BNP5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 10:57:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Haojian Zhuang <haojian.zhuang@linaro.org>
Subject: Re: [PATCH] driver core: add wait event for deferred probe
Date: Thu, 14 Feb 2013 15:57:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        viro@zeniv.linux.org.uk, rusty@rustcorp.com.au, hpa@linux.intel.com,
        jim.cromie@gmail.com, linux-kernel@vger.kernel.org,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        broonie@opensource.wolfsonmicro.com,
        Patch Tracking <patches@linaro.org>
References: <1360429077-14616-1-git-send-email-haojian.zhuang@linaro.org> <20130213213624.079BA3E3557@localhost> <CAD6h2NT73-af1Hgx0hCBkg8z1hQukK0XPESvrEcrUFv_VKGWjA@mail.gmail.com>
In-Reply-To: <CAD6h2NT73-af1Hgx0hCBkg8z1hQukK0XPESvrEcrUFv_VKGWjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302141557.18308.arnd@arndb.de>
X-Provags-ID: V02:K0:VbvwuumtUT519QthutDiuMFIFGVtjhBqrziq+swuR1m
 FR8zNPKgF7SsD9lSgw1XzmJ4zEeeIUaKMYPDF/ULPdOTVLEbE+
 KmcsqNJqae8SzVtQr2Q4cpyMxKezdQ2eKrKDDF8SEaW21Kf99E
 yEAq6WB6d4Pi08NcJ9GCo4ST6gB66G3OLnjZ/OXW527AulXDCn
 X7e8N/H1w1oDN7aUabBfjfHJngLT49Y+DxKAtjU/rK8aJGC5/p
 +8E2AUrnRyhDHt+7dz6EnOm9OzMLZcat+2508xyppm0iZZ9R0b
 QIjHlQM0L+J/BISsYjPZ365J26GqQbSUQIrTwspX0FVYjTrvix
 ucmojqXeoVYV9jpsCKe8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2013, Haojian Zhuang wrote:
> If you can change it into code in below, it could work. Otherwise, it
> always fails.
>         driver_deferred_probe_enable = true;
>         driver_deferred_probe_trigger();
> +      deferred_probe_work_func(NULL);
>         return 0;
> 
> Because deferred_probe_work_func() depends on that deferred_probe is added
> into deferred_probe_active_list. If driver_deferred_probe_trigger() isn't called
> first, the deferred uart probe can't be added into active list. So even you call
> work_func at here, it doesn't help.
> 

Would that not cause two instances of the work function to run at the same time?
That sounds like a source for a lot of problems.

	Arnd
