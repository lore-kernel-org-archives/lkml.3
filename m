Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802Ab3LIOQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 09:16:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788Ab3LIOQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:16:32 -0500
Date: Mon, 9 Dec 2013 15:16:24 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tool: Ensure forward progress unwinding frames
Message-ID: <20131209141624.GC30360@krava.brq.redhat.com>
References: <1385942509-11445-1-git-send-email-dsahern@gmail.com>
 <52A4B065.9080804@gmail.com>
 <20131209100205.GA1242@krava.brq.redhat.com>
 <52A5CE1B.3030007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A5CE1B.3030007@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 07:05:15AM -0700, David Ahern wrote:
> On 12/9/13, 3:02 AM, Jiri Olsa wrote:
> >>On 12/1/13, 5:01 PM, David Ahern wrote:
> >>>The dwarf option for callstacks is getting stuck on the unwind and showing
> >>>repeated frames. For example,
> >>>
> >>>qemu-system-x86 13759 [001] 287663.084957: syscalls:sys_enter_futex: uaddr: 0x7f770a958700, op: 0x00000081, val: 0x00000001, utime: 0x7f75ea
> >>>             7f7705fd23ea __lll_unlock_wake (/lib64/libpthread-2.14.90.so)
> >>>             7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
> >>>             7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
> >>>             7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
> >>>             7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
> >>>             7f7705fcf045 _L_unlock_649 (/lib64/libpthread-2.14.90.so)
> >>>             ...
> >
> >I wonder this is us or libunwind bug (or cfi code) ;-)
> >
> >looks like you can reproduce..? are you using the latest libunwind?
> 
> $ rpm -q libunwind
> libunwind-0.99-2.20110424git1e10c293.fc16.x86_64

[jolsa@krava libunwind]$ rpm -q libunwind
libunwind-1.1-2.fc19.x86_64

;-)
