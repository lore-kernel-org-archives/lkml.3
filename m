Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbaLVRBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 12:01:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818AbaLVRBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 12:01:15 -0500
Date: Mon, 22 Dec 2014 18:01:03 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, acme@kernel.org, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tools lib traceevent: Add support for IP address formats
Message-ID: <20141222170103.GG29096@krava.brq.redhat.com>
References: <1418915443-45707-1-git-send-email-dsahern@gmail.com>
 <17321.1418939104@turing-police.cc.vt.edu>
 <549351A7.9040408@gmail.com>
 <54938266.9090007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54938266.9090007@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 06:41:58PM -0700, David Ahern wrote:
> On 12/18/14 3:13 PM, David Ahern wrote:
> >Are you seeing something different?
> 
> I put a tracepoint in the ipv4/ipv6 add/del address code. The IPv4 one
> prints the address using pi4 and pI4 and the IPv6 using pi6, pI6 and pI6c.

apart from your tracepoints, is there another tracepoint using this?
I couldn't find any.. I dont think it's a problem.. just wanted to
try it ;-)

thanks,
jirka

> 
> Using ifconfig eth1 1.2.3.4/24
> 
> I get this for trace_pipe which uses the in-kernel printf code:
> 
> root@localhost:/sys/kernel/debug/tracing/events# cat ../trace_pipe
>         ifconfig-601   [000] ....   710.660611: ipv4_del_addr: pI4=1.2.3.4
> pi4=001.002.003.004
>         ifconfig-602   [000] ....   720.833559: ipv4_add_addr: pI4=1.2.3.4
> pi4=001.002.003.004
>         ifconfig-602   [000] .Ns.   720.833966: ipv6_add_addr:
> pi6=fe80000000000000000202fffe020211
> pI6=fe80:0000:0000:0000:0002:02ff:fe02:0211 pI6c=fe80::2:2ff:fe02:211
>         ifconfig-602   [000] ....   720.835413: ipv4_del_addr: pI4=1.2.3.4
> pi4=001.002.003.004
>         ifconfig-602   [000] .N..   720.835451: ipv4_add_addr: pI4=1.2.3.4
> pi4=001.002.003.004
> 
> 
> And this using perf:
> root@localhost:~# perf record -a -e  ipv4:* -e ipv6:* --no-buffering | perf
> --no-pager script
> 
>        ifconfig   601 [000]   710.912862: ipv4:ipv4_del_addr: pI4=1.2.3.4
> pi4=001.002.003.004
>         ifconfig   602 [000]   721.090776: ipv4:ipv4_add_addr: pI4=1.2.3.4
> pi4=001.002.003.004
>         ifconfig   602 [000]   721.091177: ipv6:ipv6_add_addr:
> pi6=fe80000000000000000202fffe020211
> pI6=fe80:0000:0000:0000:0002:02ff:fe02:0211 pI6c=fe80::2:2ff:fe02:211
>         ifconfig   602 [000]   721.092626: ipv4:ipv4_del_addr: pI4=1.2.3.4
> pi4=001.002.003.004
>         ifconfig   602 [000]   721.092648: ipv4:ipv4_add_addr: pI4=1.2.3.4
> pi4=001.002.003.004
> 
> (Don't be fooled by the differing timestamps; data collected from both using
> the same exact command. timestamp differences are perf vs tracing.)
> 
> which suggest with the patch perf output matches tracing.
> 
> David
> 
