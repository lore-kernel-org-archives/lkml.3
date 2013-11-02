Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750902Ab3KBEQu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 00:16:50 -0400
Received: from forward12.mail.yandex.net ([95.108.130.94]:48181 "EHLO
	forward12.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3KBEQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 00:16:49 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Nov 2013 00:16:49 EDT
From: =?koi8-r?B?8tXT1MHGwSDk1sHN1dLByM3F1M/X?= <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Nazarewicz <mina86@mina86.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20131101123041.d08adc9739cf6e733d822770@linux-foundation.org>
References: <5083d6c8452b765cb33acdf03fa9b20b1d15c452.1382788496.git.mina86@mina86.com>
	<20131030155938.0f5416fe3c5c2cbd3f9cd319@linux-foundation.org>
	<xa1teh71iz3a.fsf@mina86.com>
	<212981383321699@web5m.yandex.ru> <20131101123041.d08adc9739cf6e733d822770@linux-foundation.org>
Subject: Re: [PATCH] drivers: w1: make w1_slave::flags long to avoid casts
MIME-Version: 1.0
Message-Id: <7061383365433@web15j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Sat, 02 Nov 2013 08:10:33 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

01.11.2013, 23:30, "Andrew Morton" <akpm@linux-foundation.org>:

> set_bit() operates on longs. šSo if we do
>
> struct foo {
> ššššššššu32 a;
> ššššššššu32 b;
> } f;
>
> šššššššš...
> ššššššššset_bit(0, (long *)&f.a);
> šššššššš...
>
> then we'll scribble on f.b on a big-endian 64-bit machine.

Argh, why would we just don't do that? Its in-memory field, it can be anything,
I wouldn't be surprised if it even can be non-atomic because of proper locks already
being held
