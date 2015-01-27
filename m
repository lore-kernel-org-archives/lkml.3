Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbbA0F5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 00:57:04 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:52088 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbbA0F5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 00:57:01 -0500
MIME-Version: 1.0
From: Alexei Starovoitov <ast@plumgrid.com>
Date: Mon, 26 Jan 2015 21:56:40 -0800
Message-ID: <CAMEtUuyfQF2eh+YszkmQa9g8kkZ0QZOTHbowa-npRyrV_mnJQQ@mail.gmail.com>
Subject: BPF backend has landed in LLVM
To: Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Brendan Gregg <brendan.d.gregg@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Jesse Gross <jesse@nicira.com>, Thomas Graf <tgraf@suug.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

llvm trunk now has BPF backend:
https://twitter.com/llvmweekly/status/559076464973594625
It's the one used to build samples/bpf/*_kern.c examples.

Compiler just emits extended BPF instructions. It's not
aware whether they are used for tracing or networking,
or how they're loaded into the kernel.

the backend has 'experimental' status,
meaning that it doesn't get configured by default and
one needs to use --enable-experimental-targets=bpf
to build it.

todo list:
- promote it from 'experimental' status by
  the time llvm 3.7 is released :)
- write front-end for tracing via mcjit api
  llvm will be used as a library: parsing of some
  tracing language, codegen, loading of bpf via
  syscall will be done from one process
- tighten accepted IR and improve error reporting
  (currently it can compile too much of C that
   kernel will later reject, so need to make strict)
- test/fix what it emits on arm and other archs
  (all little endian should work as-is, big-endian
   might need some fixes)
- support 32-bit subregisters

If anyone has spare cycles to help out, it
would be great.

Thanks
