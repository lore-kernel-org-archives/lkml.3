Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab3KATao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 15:30:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab3KATan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 15:30:43 -0400
Date: Fri, 1 Nov 2013 12:30:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Michal Nazarewicz <mina86@mina86.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: w1: make w1_slave::flags long to avoid casts
Message-Id: <20131101123041.d08adc9739cf6e733d822770@linux-foundation.org>
In-Reply-To: <212981383321699@web5m.yandex.ru>
References: <5083d6c8452b765cb33acdf03fa9b20b1d15c452.1382788496.git.mina86@mina86.com>
	<20131030155938.0f5416fe3c5c2cbd3f9cd319@linux-foundation.org>
	<xa1teh71iz3a.fsf@mina86.com>
	<212981383321699@web5m.yandex.ru>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Nov 2013 20:01:39 +0400 Evgeniy Polyakov <zbr@ioremap.net> wrote:

> > Now that I look at documentation, I think you are correct, but the
> > problem is on big-endian 64-bit architectures. __The fix is still
> > valid, but the commit message not so much. __Something along the
> > lines of the following would be better:
> 
> Guys, you so much overcomplicate things - this field is basically a set of in-memory flags
> for attached device, there is no need to even think about how it is present in different endianess
> 
> Or do I miss something fundamental there? I wrote it gazillions years ago and probably already forgot something

set_bit() operates on longs.  So if we do

struct foo {
	u32 a;
	u32 b;
} f;

	...
	set_bit(0, (long *)&f.a);
	...

then we'll scribble on f.b on a big-endian 64-bit machine.
