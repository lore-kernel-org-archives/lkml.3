Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab3I3Poo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:44:44 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:45815 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab3I3Pom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:44:42 -0400
MIME-Version: 1.0
Date: Mon, 30 Sep 2013 17:44:41 +0200
Message-ID: <CABPqkBQrTzMKnL-f5iCe4jhM1mHXNE6aZ=OwVmpsezOLaRLntA@mail.gmail.com>
Subject: [RFC] perf: mmap2 not covering VM_CLONE regions
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was alerted by people trying to use the PERF_RECORD_MMAP2
record to disambiguate virtual address mappings that there is a case
where the record does not contain enough information.

As you know, the MMAP2 record adds the major, minor, ino number,
inode generation numbers to a mapping. But it does that only for
file or pseudo -file backed mappings. That covers file mmaps and also
SYSV shared memory segments.

However there is a another kind of situation that arises in some
multi-process benchmarks where a region of memory is cloned
using VM_CLONE. As such, the virtual addresses match between
the processes but the major, minor, inode, inode generation  fields
are all zeroes because there is no inode associated with the mapping.
Yet, it is important for the tool to know the mappings between the
processes are pointing to the same physical data.

We need to cover this case and I am seeking for advice on how to
best address this need given that we discarded using the plain physical
address for disambiguation.

Thanks.
