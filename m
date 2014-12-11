Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635AbaLKBsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:48:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932948AbaLKBsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:48:23 -0500
Date: Wed, 10 Dec 2014 20:00:53 -0500
From: Dave Jones <davej@redhat.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>, dborkman@redhat.com
Subject: Re: [net: sock] BUG: unable to handle kernel NULL pointer
 dereference at 0000000000000007
Message-ID: <20141211010053.GA23742@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alexei Starovoitov <ast@plumgrid.com>,
	Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>, dborkman@redhat.com
References: <20141210232911.GE24163@wfg-t540p.sh.intel.com>
 <CAMEtUuxexMXtvK_R7YZEvx_iyK9mAx_zrqr1bkj3PsUwoq0p5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMEtUuxexMXtvK_R7YZEvx_iyK9mAx_zrqr1bkj3PsUwoq0p5A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 03:51:33PM -0800, Alexei Starovoitov wrote:
 > On Wed, Dec 10, 2014 at 3:29 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
 > > Greetings,
 > >
 > > 0day kernel testing robot got the below dmesg and the first bad commit is
 > >
 > >     net: sock: allow eBPF programs to be attached to sockets
 > 
 > > [init] Kernel was tainted on startup. Will ignore flags that are already set.
 > > [init] Started watchdog process, PID is 9354
 > > [main] Main thread is alive.
 > > [   21.233581] BUG: unable to handle kernel NULL pointer dereference at 0000000000000007
 > > [   21.234709] IP: [<ffffffff8156ebda>] sk_attach_bpf+0x39/0xc2
 > 
 > thanks for the report! syscall fuzzer is great.
 > I missed an extra check. Working on a fix.

This might be the first time I've seen it trip up the bpf code iirc.
Daniel wrote some pretty nifty bpf generator code in trinity,
(net/bpf.c) that you might want to see if you can think of enhancing.

Though it might be the case that we're not even needing to do anything
that complicated to hit this particular bug..

	Dave

