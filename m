Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144AbaLTFKN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 00:10:13 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:31623 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750750AbaLTFKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 00:10:11 -0500
Date: Sat, 20 Dec 2014 00:10:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Divya Vyas <edivya.vyas@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: Merge ftrace data of host and guest
Message-ID: <20141220051008.GE5474@home.goodmis.org>
References: <CAGfiMvCLgdaACWuUJAWecaLP9cSZRLFzzWgNGoiZTidT9m60cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGfiMvCLgdaACWuUJAWecaLP9cSZRLFzzWgNGoiZTidT9m60cg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 05:52:52PM +0530, Divya Vyas wrote:
> Hi,

Hi, it would be  helpful if you Cc'd me. I would have responded quicker. Luckily,
someone noticed this email and told me about it.

> 
> I think it is not desired output . Ths script is written for diffrent
> format .ftrace format is ( trace-cmd report command generates) :

I'm actually working on trace-cmd this week and hopefully I'll be able to release
2.5 by x-mas.

I believe that Masami is going to start continuing work on the virt guest
tracer for trace-cmd.

Also, for now, for a crud way of merging, if both the gettimeofday clocks
of the host and guest are synced, you could do:

guest> trace-cmd record -o guest.dat --date  ...

host> trace-cmd record -o host.dat --date ...

and then run:

trace-cmd report -i guest.dat -i host.dat

and trace-cmd will merge the two. The --date will add a way to sync the trace
timestamps to a wall clock and that will be used to try to interleave the
events of both the data files.

-- Steve

