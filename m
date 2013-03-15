Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab3COMQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 08:16:45 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46505 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab3COMQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:16:44 -0400
Date: Fri, 15 Mar 2013 08:16:59 -0400 (EDT)
Message-Id: <20130315.081659.636423702994054939.davem@davemloft.net>
To: arnd@arndb.de
Cc: geert@linux-m68k.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, isdn@linux-pingi.de,
        netdev@vger.kernel.org, dhowells@redhat.com
Subject: Re: [PATCH] isdn: hisax: netjet requires VIRT_TO_BUS
From: David Miller <davem@davemloft.net>
In-Reply-To: <201303151015.00746.arnd@arndb.de>
References: <1363298204-8014-4-git-send-email-arnd@arndb.de>
	<CAMuHMdVhjnX_hag5Y5VvDWVcjPK8tMM-qx-TQ2x=M88yTZQwYg@mail.gmail.com>
	<201303151015.00746.arnd@arndb.de>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 15 Mar 2013 05:16:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 15 Mar 2013 10:15:00 +0000

> David Howells brought up the topic of endian checks recently, noting
> that the way we define __BIG_ENDIAN and __LITTLE_ENDIAN in the kernel
> is incompatible to how do it in user space, and not much better either.
> 
> A few architectures that are bi-endian (arc, arm, c6x, mips, sh) already
> have CONFIG_CPU_IS_LITTLE_ENDIAN and CONFIG_CPU_IS_BIG_ENDIAN. I guess
> it would be a good idea to provide these on all architectures.

I do not want to see us add such a Kconfig dependency knob.

Then the real tendency will exist to make new drivers little-endian
only, refuse to fix endian-broken old drivers, etc.

Which means that allmodconfig on my architecture will have build
coverage on less code, which is really the only thing that matters
for me.  I want all drivers that could be effected by my changes
to be compile testable on as many platforms as possible.
