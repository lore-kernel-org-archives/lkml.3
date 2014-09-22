Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaIVHbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 03:31:53 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:53124 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaIVHbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 03:31:51 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3] perf tools: Fix build-id matching on vmlinux
References: <1411353945-16576-1-git-send-email-namhyung@kernel.org>
	<20140922051630.GA18588@gmail.com>
Date: Mon, 22 Sep 2014 16:31:49 +0900
In-Reply-To: <20140922051630.GA18588@gmail.com> (Ingo Molnar's message of
	"Mon, 22 Sep 2014 07:16:30 +0200")
Message-ID: <87ppeokt5m.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Mon, 22 Sep 2014 07:16:30 +0200, Ingo Molnar wrote:
> * Namhyung Kim <namhyung@kernel.org> wrote:
>> +		list_for_each_entry(dso, &machine->kernel_dsos, node) {
>> +			const char *suffix;
>> +
>> +			suffix = dso->long_name + strlen(dso->long_name) - 3;
>> +			if (strcmp(suffix, ".ko")) {
>> +				kernel = dso;
>> +				break;
>> +			}
>
> Is strlen(dso->long_name) guaranteed to be >= 3? If not then you 
> should probably check for it, otherwise we might strcmp into 
> invalid memory.

I *think* they are all valid kernel modules so length should be greater
than 3.  But I also think that adding such an extra check won't cause
any harm.  So I'll change to check it in v4. :)

Thanks for your review!
Namhyung
