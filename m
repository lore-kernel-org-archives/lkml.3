Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3KLBDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 20:03:49 -0500
Received: from forward14.mail.yandex.net ([95.108.130.92]:36748 "EHLO
	forward14.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab3KLBD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 20:03:28 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Evgeny Boger <eugenyboger@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <5281691F.4060604@gmail.com>
References: <1384180614-9025-1-git-send-email-boger@contactless.ru> <10261384211376@web11j.yandex.ru> <5281691F.4060604@gmail.com>
Subject: Re: [PATCH 1/1] Add strong pullup emulation to w1-gpio master driver.
MIME-Version: 1.0
Message-Id: <37621384218204@web11j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 12 Nov 2013 05:03:24 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

12.11.2013, 03:32, "Evgeny Boger" <eugenyboger@gmail.com>:
>> Why did you drop this check? It has nothing with w1-gpio driver
> This check prevents master from implementing "set_pullup"š provided it does support only "write_bit" method.
> The comment above states that
>> šw1_io.c would need to support calling set_pullup before - * the last write_bit operation of a w1_write_8 which it currently - * doesn't.
> which is kind of strange, since it describes what w1_io.c actually does support.
>
> w1_write_8 (w1_io.c:154, https://github.com/torvalds/linux/blob/master/drivers/w1/w1_io.c#L154):
>> ššššššššššššššššfor (i = 0; i < 8; ++i) {
>> ššššššššššššššššššššššššif (i == 7)
>> ššššššššššššššššššššššššššššššššw1_pre_write(dev);
>> ššššššššššššššššššššššššw1_touch_bit(dev, (byte >> i) & 0x1);
>> šššššššššššššššš}
>
> It seems like w1_write_8() calls w1_pre_write(), which in turn calls set_pullup() just before the last write_bit().
>
> I'm not sure why this check was there in the first place.

Please add author of those lines to clarify things.
This doesn't look obvious to me
