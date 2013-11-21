Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab3KUJan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 04:30:43 -0500
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:53035 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3KUJak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 04:30:40 -0500
X-SENDER-IP: [85.230.168.69]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AskeALTKjVJV5qhFPGdsb2JhbAANTItEtUqBMwMBAQEBOIJaAQEBAQIBeQULCyElDwIyFAYBDAEHAQGHdwuuZpF4F44qgUEHhDIDoluJMYE/gWg
X-IronPort-AV: E=Sophos;i="4.93,743,1378850400"; 
   d="scan'208";a="433894635"
Message-ID: <528DCCBD.80009@euromail.se>
Date: Thu, 21 Nov 2013 10:05:01 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Friedrich_Sch=F6ller?= <linux@schoeller.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Input: Fixed ABS_MT_TOUCH_MINOR scale factor in BCM5974
 multitouch driver
References: <1384988052-31898-1-git-send-email-linux@schoeller.se>
In-Reply-To: <1384988052-31898-1-git-send-email-linux@schoeller.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Friedrich,

> On wellspring3 devices ABS_MT_TOUCH_MINOR was sometimes reported bigger than
> ABS_MT_TOUCH_MAJOR. This is fixed by rescaling ABS_MT_TOUCH_MINOR by a factor of
> 0.85 instead of 2. Excessive tapping on the trackpad shows this to be the right
> value. Circular touches should now lead to values for ABS_MT_TOUCH_MAJOR and
> ABS_MT_TOUCH_MINOR that are similar, with ABS_MT_TOUCH_MINOR never greater than
> ABS_MT_TOUCH_MAJOR.
> ---
>  drivers/input/mouse/bcm5974.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)

The major/minor scales are following the aspect ratio of the device, and as such
it could happen that minor > major. Most userland drivers do not use the finger
width limits, which are estimates, but only the device axes limit, which are
accurate.

Also, we cannot have floats in the kernel.

I would consider a patch which tries to make the finger widths more accurate,
but all in all, I think this problem is best solved in userland.

Thanks,
Henrik

