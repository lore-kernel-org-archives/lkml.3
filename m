Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab3KAQHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:07:33 -0400
Received: from forward1m.mail.yandex.net ([37.140.138.1]:38310 "EHLO
	forward1m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab3KAQHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:07:32 -0400
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Nov 2013 12:07:32 EDT
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <xa1teh71iz3a.fsf@mina86.com>
References: <5083d6c8452b765cb33acdf03fa9b20b1d15c452.1382788496.git.mina86@mina86.com> <20131030155938.0f5416fe3c5c2cbd3f9cd319@linux-foundation.org> <xa1teh71iz3a.fsf@mina86.com>
Subject: Re: [PATCH] drivers: w1: make w1_slave::flags long to avoid casts
MIME-Version: 1.0
Message-Id: <212981383321699@web5m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 01 Nov 2013 20:01:39 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone

31.10.2013, 13:12, "Michal Nazarewicz" <mina86@mina86.com>:

>>> ššššššššššint ttl;
>> š... w1_slave.ttl?

For noisy lines this was a 'timeout' after which system considered attached
device as failed, the noisier line is the longer is timeout

I experimented with meters-long w1 wires and it required several
search fails to correctly determine that device disappeared

> Now that I look at documentation, I think you are correct, but the
> problem is on big-endian 64-bit architectures. šThe fix is still
> valid, but the commit message not so much. šSomething along the
> lines of the following would be better:

Guys, you so much overcomplicate things - this field is basically a set of in-memory flags
for attached device, there is no need to even think about how it is present in different endianess

Or do I miss something fundamental there? I wrote it gazillions years ago and probably already forgot something
