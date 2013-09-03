Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab3ICJC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 05:02:27 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53156 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602Ab3ICJCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 05:02:25 -0400
X-AuditID: 9c930197-b7b44ae00000347f-90-5225a5a0ed08
From: Namhyung Kim <namhyung@kernel.org>
To: Chenggang Qin <chenggang.qin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chenggang Qin <chenggang.qcg@taobao.com>,
        David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] perf core: Fix a mmap & munmap mismatches bug in dso__load
References: <1378049385-4466-1-git-send-email-chenggang.qin@gmail.com>
	<1378049385-4466-2-git-send-email-chenggang.qin@gmail.com>
Date: Tue, 03 Sep 2013 18:02:24 +0900
In-Reply-To: <1378049385-4466-2-git-send-email-chenggang.qin@gmail.com>
	(Chenggang Qin's message of "Sun, 1 Sep 2013 23:29:44 +0800")
Message-ID: <87vc2ith0f.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  1 Sep 2013 23:29:44 +0800, Chenggang Qin wrote:
> From: Chenggang Qin <chenggang.qcg@taobao.com>
>
> Some dsos' symsrc is neither syms_ss or runtime_ss. In this situation, the
> corresponding ELF file is opened and mmapped in symsrc__init(), but they will
> be not closed and munmapped in any place.
> This bug can lead to mmap & munmap mismatched, the mmap areas will exist during
> the life of perf. We can think this is a memory leak.
> This patch fixed the bug. symsrc__destroy() is called while the opened and
> mmaped ELF file has neither symtlb section nor dynsym section, and opdsec
> section.
> Thanks.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
