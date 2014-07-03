Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbaGCXIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 19:08:35 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:41972 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997AbaGCXIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 19:08:32 -0400
MIME-Version: 1.0
In-Reply-To: <CANGgnMZBXbBnr1J+HDtDTo3TD-KgjerLA7BH9x6tmsdDfrNWbA@mail.gmail.com>
References: <CANGgnMbHckBQdKGN_N5Q6qEKc9n1CenxvMpeXog1NbSdL8UrTw@mail.gmail.com>
 <CANGgnMYDXerOUDOO9-RHMJKadKACA2KBGskZwoP-1ZwAhDEfVA@mail.gmail.com>
 <CAFLxGvxfBt7OvW=a2Kz08GLHSEiiOZsN-vB19CXnQiwqFxqMsA@mail.gmail.com>
 <CANGgnMYVoP-Z0Bv-VDEkJnvfa7Fi4-zY2F4A0PhMewGvwo3VVw@mail.gmail.com>
 <alpine.DEB.2.10.1406270027300.5170@nanos> <CANGgnMa+qtgJ3wwg_h5Rynw5vEvZpQZ6PvaUfXNQ8+Y3Yu5U0g@mail.gmail.com>
 <alpine.DEB.2.10.1406271249510.5170@nanos> <CANGgnMZ8qemTgzoiq96=YvTnz-h945b8zSw1VtmDMSrbY3kcUg@mail.gmail.com>
 <CANGgnMZBXbBnr1J+HDtDTo3TD-KgjerLA7BH9x6tmsdDfrNWbA@mail.gmail.com>
From: Austin Schuh <austin@peloton-tech.com>
Date: Thu, 3 Jul 2014 16:08:11 -0700
Message-ID: <CANGgnMYq+QHaic1pRugDbudDAd8985KxSoUKRTbfnhwrZ5zSBQ@mail.gmail.com>
Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2014 at 12:32 PM, Austin Schuh <austin@peloton-tech.com> wrote:
> On Mon, Jun 30, 2014 at 8:01 PM, Austin Schuh <austin@peloton-tech.com> wrote:
>> On Fri, Jun 27, 2014 at 7:24 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>>> Completely untested patch below.

I've tested it and looked it over now, and feel pretty confident in
the patch.  Thanks Thomas!

I've been running this fix with my extra lock steps for a couple days
now on 3 machines, and haven't seen any issues.  On each of the
machines, I've got a CAN card generating about 1 CPU worth of load
from interrupts, and the rest of the cores are tied up putting work on
the work queues with the killer_module.

What next?

Austin
