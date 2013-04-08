Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936439Ab3DHV3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:29:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58525 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936268Ab3DHV3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:29:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Fabian Vogt" <fabian@ritter-vogt.de>
Subject: Re: [RFC PATCH arm: initial TI-Nspire support]
Date: Mon, 8 Apr 2013 23:29:07 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: "Daniel Tang" <dt.tangr@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, "Lionel Debroux" <lionel_debroux@yahoo.fr>,
        linux-kernel@vger.kernel.org,
        "Linus Walleij" <linus.walleij@linaro.org>
References: <6FE4B33E-A503-4A75-AEED-831CB2C06D83@gmail.com> <201304082138.15875.arnd@arndb.de> <op.wu8ng3wyu7prd4@fabians-laptop.fritz.box>
In-Reply-To: <op.wu8ng3wyu7prd4@fabians-laptop.fritz.box>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304082329.08105.arnd@arndb.de>
X-Provags-ID: V02:K0:foZQsuR69ACFvvBSkMeWJepUoLUJkgnA6idBGHTl7oo
 gUOxfNKHFfWIyWxaMUNAhIKVDjYjlGO3W8y0xTQYqK5SLhnste
 kBU5T8ONTs171Njyjkf92PoKW1t1rJ/+LcuVTk6Vva0I35i7L4
 ociWavib7ACqsqaQuIFoPI34NPhU7DK2yoKAXCBjSpIN2ieFme
 CvsuGM+jaWgknHaRzYJOXm0WnahH9zDFl4rDQYU8iIBaecu2jC
 SDGabbjbv9A5k4yrrq9YukuQZE14c6nmdTdMdhdmXREnLn5q+7
 ZNsQ1wjrR/qI7cZeg+1+kgk7QbfGN7aEnGz5ZXrNQz4cOfKGjF
 nW6wbzUOumab0cmjYIlo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 April 2013, Fabian Vogt wrote:
> Yes, I've heard that before, but than it would work/not work independently
> of NO_HZ. Can printk's be executet within console_lock() ..  
> console_unlock() blocks?

I think it's legal to call printk in that case, but the message will
not be printed until you reach the console_unlock()

> If not, it could be fb_notifier_call_chain, too, but that wouldn't be  
> likely at all.
> I also tried spinlock/mutex debugging and soft lockup detection,
> but neither of them outputs anything.

Unfortunately, lockdep does not help with console_lock, since that
is a weird semaphore variant, not a standard mutex or spinlock.

	Arnd
