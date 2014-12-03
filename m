Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaLCDVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 22:21:55 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:34657 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaLCDVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 22:21:54 -0500
Message-ID: <547e81ce.a1628c0a.4985.ffffb12a@mx.google.com>
Date: Wed, 3 Dec 2014 01:21:46 -0200
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <CA+55aFxdZjJprk8t9NxcZmewAAQ5Gf1XQWV=5i+Vfc5uTSfWFg@mail.gmail.com>
References: <20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<20141201230813.GE25340@linux.vnet.ibm.com>
	<547dec29.c71f8c0a.33d1.11d9@mx.google.com>
	<20141202170407.GK25340@linux.vnet.ibm.com>
	<547df364.236a8c0a.7b2d.ffffac67@mx.google.com>
	<20141202184202.GM25340@linux.vnet.ibm.com>
	<547e0947.c332e00a.23bf.ffffa8bd@mx.google.com>
	<20141202191143.GN25340@linux.vnet.ibm.com>
	<547e11fa.8778e00a.3439.ffffa88c@mx.google.com>
	<20141202205636.GQ25340@linux.vnet.ibm.com>
	<547e36d1.c54ae00a.2571.fffffd13@mx.google.com>
	<CA+55aFxdZjJprk8t9NxcZmewAAQ5Gf1XQWV=5i+Vfc5uTSfWFg@mail.gmail.com>
Organization: http://www.youtube.com/DanielFragaBR
X-Mailer: Claws Mail 3.11.1-9-g1f531c (GTK+ 2.24.25; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014 14:10:33 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> There's 13k+ commits in between 3.16 and 3.17, so a full bisect should
> be around 15 test-points. But judging by the timing of your emails,
> you can generally reproduce this relatively quickly..

	Ok Linus and Paul, it took me almost 5 hours to bisect it and
the result is:

c9b88e9581828bb8bba06c5e7ee8ed1761172b6e is the first bad commit

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=c9b88e9581828bb8bba06c5e7ee8ed1761172b6e

	I hope I didn't get any false positive/negative during 
bisect.

	And here's the complete bisect log (just in case):

git bisect start
# good: [19583ca584d6f574384e17fe7613dfaeadcdc4a6] Linux 3.16
git bisect good 19583ca584d6f574384e17fe7613dfaeadcdc4a6
# bad: [bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9] Linux 3.17
git bisect bad bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9
# bad: [f2d7e4d4398092d14fb039cb4d38e502d3f019ee] checkpatch: add fix_insert_line and fix_delete_line helpers
git bisect bad f2d7e4d4398092d14fb039cb4d38e502d3f019ee
# bad: [79eb238c76782a59d51adf8a3dd7f6444245b475] Merge tag 'tty-3.17-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
git bisect bad 79eb238c76782a59d51adf8a3dd7f6444245b475
# good: [3d582487beb83d650fbd25cb65688b0fbedc97f1] staging: vt6656: struct vnt_private pInterruptURB rename to interrupt_urb
git bisect good 3d582487beb83d650fbd25cb65688b0fbedc97f1
# bad: [e9c9eecabaa898ff3fedd98813ee4ac1a00d006a] Merge branch 'x86-cpufeature-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad e9c9eecabaa898ff3fedd98813ee4ac1a00d006a
# bad: [c9b88e9581828bb8bba06c5e7ee8ed1761172b6e] Merge tag 'trace-3.17-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
git bisect bad c9b88e9581828bb8bba06c5e7ee8ed1761172b6e
# good: [47dfe4037e37b2843055ea3feccf1c335ea23a9c] Merge branch 'for-3.17' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
git bisect good 47dfe4037e37b2843055ea3feccf1c335ea23a9c
# good: [b11a6face1b6d5518319f797a74e22bb4309daa9] clk: Add missing of_clk_set_defaults export
git bisect good b11a6face1b6d5518319f797a74e22bb4309daa9
# good: [3a636388bae8390d23f31e061c0c6fdc14525786] tracing: Remove function_trace_stop and HAVE_FUNCTION_TRACE_MCOUNT_TEST
git bisect good 3a636388bae8390d23f31e061c0c6fdc14525786
# good: [e17acfdc83b877794c119fac4627e80510ea3c09] Merge branch 'for-3.17' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata
git bisect good e17acfdc83b877794c119fac4627e80510ea3c09
# good: [c7ed326fa7cafb83ced5a8b02517a61672fe9e90] Merge tag 'ktest-v3.17' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest
git bisect good c7ed326fa7cafb83ced5a8b02517a61672fe9e90
# good: [dc6f03f26f570104a2bb03f9d1deb588026d7c75] ftrace: Add warning if tramp hash does not match nr_trampolines
git bisect good dc6f03f26f570104a2bb03f9d1deb588026d7c75
# good: [ede392a75090aab49b01ecd6f7694bb9130ad461] tracing/uprobes: Kill the dead TRACE_EVENT_FL_USE_CALL_FILTER logic
git bisect good ede392a75090aab49b01ecd6f7694bb9130ad461
# good: [bb9ef1cb7d8668d6b0038b6f9f783c849135e40d] tracing: Change apply_subsystem_event_filter() paths to check file->system == dir
git bisect good bb9ef1cb7d8668d6b0038b6f9f783c849135e40d
# good: [6355d54438bfc3b636cb6453cd091f782fb9b4d7] tracing: Kill "filter_string" arg of replace_preds()
git bisect good 6355d54438bfc3b636cb6453cd091f782fb9b4d7
# good: [b8c0aa46b3e86083721b57ed2eec6bd2c29ebfba] Merge tag 'trace-3.17' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
git bisect good b8c0aa46b3e86083721b57ed2eec6bd2c29ebfba
# first bad commit: [c9b88e9581828bb8bba06c5e7ee8ed1761172b6e] Merge tag 'trace-3.17-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace

-- 
Linux 3.16.0-00409-gb8c0aa4: Shuffling Zombie Juror
http://www.youtube.com/DanielFragaBR
http://exchangewar.info
Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL
