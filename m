Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaIMKEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 06:04:35 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbaIMKEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 06:04:33 -0400
Message-ID: <541416AB.7000808@nod.at>
Date: Sat, 13 Sep 2014 12:04:27 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Li RongQing <roy.qing.li@gmail.com>, Guenter Roeck <linux@roeck-us.net>
CC: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, fabf@skynet.be,
        jkosina@suse.cz, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        oleg@redhat.com, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH] signal: replace !likely with unlikely!
References: <1410396496-13845-1-git-send-email-roy.qing.li@gmail.com>	<20140911191830.GA31511@roeck-us.net> <CAJFZqHwsjuw5As6duphrgbzxtwmE2ZqbraNEme88M3hi1WBiRQ@mail.gmail.com>
In-Reply-To: <CAJFZqHwsjuw5As6duphrgbzxtwmE2ZqbraNEme88M3hi1WBiRQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.09.2014 04:48, schrieb Li RongQing:
> I did not test, how to test it?

Compare the object files of both variants to find out whether both create
semantically equivalent code and whether the un/likely have an effect.
i.e. objdump -S -d kernel/signal.o
I guess you can just remove the likely as gcc is smart enough to detect the "goto ret;"
as an unlikely taken branch.

Thanks,
//richard
