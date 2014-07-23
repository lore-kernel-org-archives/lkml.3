Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbaGWSzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:55:44 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:60203 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557AbaGWSzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:55:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140723184111.GG3935@laptop>
References: <20140723113021.GP12054@laptop.lan>
	<20140723142454.GQ12054@laptop.lan>
	<CA+55aFwZ7kAqqhaE4g89CJLkpJOwGxcN4u+cc0ODfqjQ0rVMiA@mail.gmail.com>
	<20140723155526.GW3935@laptop>
	<CA+55aFzSU5u8MiGqRZ6BVojQPnxbd1hxmFY_BA=UuCAygxR8WQ@mail.gmail.com>
	<20140723170324.GZ3935@laptop>
	<CA+55aFwQSmBAs=QH9jAZz5JY7YFrDeuPH1RjFH+YKVr2NQM38g@mail.gmail.com>
	<CA+55aFzDWritxv5RiqwcZ1qCKJQKK-Lw6StYFF7qx5YWgiCUTQ@mail.gmail.com>
	<20140723182518.GD3935@laptop>
	<CA+55aFyFT9n5wUNifEHY6+t2bEcD91kL7+dqXuBMSMJvLeDDJQ@mail.gmail.com>
	<20140723184111.GG3935@laptop>
Date: Wed, 23 Jul 2014 11:55:42 -0700
X-Google-Sender-Auth: f0wnmGp_Ca9Dgv4HRAAbz5s7cEE
Message-ID: <CA+55aFwQfwfAP6U77_nD_mSvoygj=cZ09N644hKRtzgLnEqhZQ@mail.gmail.com>
Subject: Re: Random panic in load_balance() with 3.16-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 11:41 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> OK, that leaves us agreeing we want to clean that up, but still no
> closer to explaining WTH happened on Michel's machine. Weird that.

So looking at that destination pointer value (ffff10043c803e8c), it
*looks* like a pointer. Almost. If it was 0xffff80.. instead of
0xffff10.. it would probably be a fine pointer.

Can you send me the config? I'm wondering what else might be close to
that load_balance_mask percpu allocation, that migth perhaps have
overflowed and written a stray byte into the pointer or something?

                  Linus
