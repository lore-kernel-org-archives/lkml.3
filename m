Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaKFO4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:56:31 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55415 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaKFO4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:56:30 -0500
Message-ID: <545B8C16.4010400@hitachi.com>
Date: Thu, 06 Nov 2014 23:56:22 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: Re: [PATCH v4 5/5] perf/sdt: Add support to perf record to
 trace SDT events
References: <20141102105006.21708.28734.stgit@hemant-fedora> <20141102105557.21708.19032.stgit@hemant-fedora> <87lhnr5sbl.fsf@sejong.aot.lge.com> <54588905.7040002@linux.vnet.ibm.com> <5458CD15.4010101@hitachi.com> <874muew2hk.fsf@sejong.aot.lge.com> <5459E865.6050207@hitachi.com> <545B1DDE.9000202@linux.vnet.ibm.com>
In-Reply-To: <545B1DDE.9000202@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/06 16:06), Hemant Kumar wrote:
> So, what should be our way forward here in case of SDT patchset wrt
> event_cache patchset? Shall we wait for event_cache patchset to be
> merged and then redesign the sdt_cache patchset according to new
> event_cache?
> Or, we can go ahead with the current sdt patchset (implementing the
> latest review comments) and we can change the sdt_cache according to the
> new event_cache design as and when required?
> 
> What do you think?

Good question :)
In my opinion, we'd better consolidate sdt_cache to new cache subcommand
at first, since it is a user-visible change. If we consolidate it after
introducing sdt-cache, users will see that option is also banished.

And also, the cache-format may be a problem, since that involves a backward
compatibility issue. For now, I'm considering Namhyung's idea of merging
SDT and probe caches. If we can use SDT as a kind of probe cache, why do we
need to have both SDT cache and probe cache? SDT cache is currently have its
own format, but it also could be written as a probe format, as below.

In ~/.debug/probe/bu/ild-id:

%<PROVIDER>:<EVENT> _text+<OFFSET>

This lucks a semaphore location, but who cares? Anyway we can't change
the semaphore. We already have reader of this format and also this can
have arguments if you get it from sdt.note. :)
Moreover, we can share the cache file with perf-probe! :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


