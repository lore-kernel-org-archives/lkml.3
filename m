Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaIXWFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 18:05:06 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:59305 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbaIXWFE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 18:05:04 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jens Axboe <axboe@kernel.dk> (axboe@kernel.dk)" <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>
Subject: RE: ftrace function-graph and interprocessor interrupts
Thread-Topic: ftrace function-graph and interprocessor interrupts
Thread-Index: Ac/YBflZEtKWFiuHSyShYTcBfCN35AAO34MrAAAGC2A=
Date: Wed, 24 Sep 2014 22:02:51 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C9BF52@G9W0745.americas.hpqcorp.net>
References: <94D0CD8314A33A4D9D801C0FE68B402958C9BE4D@G9W0745.americas.hpqcorp.net>
 <87mw9oelje.fsf@tassilo.jf.intel.com>
In-Reply-To: <87mw9oelje.fsf@tassilo.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.193.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andi Kleen [mailto:andi@firstfloor.org]
> Sent: Wednesday, 24 September, 2014 4:50 PM
> To: Elliott, Robert (Server Storage)
> Cc: Steven Rostedt; linux-kernel@vger.kernel.org; Jens Axboe
> <axboe@kernel.dk> (axboe@kernel.dk); Christoph Hellwig
> Subject: Re: ftrace function-graph and interprocessor interrupts
> 
> "Elliott, Robert (Server Storage)" <Elliott@hp.com> writes:
> 
> > The function-graph tracer marks some interrupt handler functions
> > with ==========>  and <========== labels.
> 
> I'm not sure the marking is really that useful. Isn't it always obvious
> from the function names where an interrupt starts/end?
> 
> -Andi

Although the do_IRQ name stands out pretty well, some of the
others don't, and blk-mq calling them directly makes it hard
to tell.  They show up clearly in the function trace, just
not the function_graph trace.

Also, the IPI function can end up nested inside { } but 
without indents, depending on when it occurs.

 10)               |                                    sd_setup_read_write_cmnd [sd_mod]() {
 10)               |                                    smp_call_function_single_interrupt() {
 10)               |                                      irq_enter() {
...
 10) + 36.788 us   |                                    } /* smp_call_function_single_interrupt */
 10)               |                                      scsi_init_io() {

The ==> labels also add an indent level.

I'd like to add an option to exclude the time taken by interrupts
in the cumulative times, but that first requires that function_graph
understand what times to exclude.

