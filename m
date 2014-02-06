Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbaBFHsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 02:48:08 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52623 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaBFHsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 02:48:06 -0500
X-AuditID: 9c93016f-b7b0cae0000024a7-4b-52f33e32e0f3
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt \(Red Hat\)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip ] [BUGFIX/URGENT] perf-probe: Do not add offset to uprobe address
In-Reply-To: <20140205051858.6519.27314.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
	(Masami Hiramatsu's message of "Wed, 05 Feb 2014 05:18:58 +0000")
References: <20140205051858.6519.27314.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Thu, 06 Feb 2014 16:48:02 +0900
Message-ID: <871tzg1y31.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Wed, 05 Feb 2014 05:18:58 +0000, Masami Hiramatsu wrote:
> Fix perf-probe not to add offset value to uprobe probe
> address when post processing.
> tevs[i].point.address is the address of symbol+offset,
> but current perf-probe adjusts the point.address by
> adding the offset. As a result, the probe address becomes
> symbol+offset+offset. This may cause unexpected
> code corruption. Urgent fix is needed.
>
> Without this fix
>   ---
>   # ./perf probe -x ./perf dso__load_vmlinux+4
>   # ./perf probe -l
>     probe_perf:dso__load_vmlinux (on 0x000000000006d2b8)
>   # nm ./perf.orig | grep dso__load_vmlinux\$
>   000000000046d0a0 T dso__load_vmlinux

Shouldn't the original symbol address be

    000000000046d2b0

?

>   ---
> You can see the given offset is 3 but the actual probed

s/3/4/ ?

Thanks,
Namhyung


> address is dso__load_vmlinux+8.
>
> With this fix
>   ---
>   # ./perf probe -x ./perf dso__load_vmlinux+4
>   # ./perf probe -l
>     probe_perf:dso__load_vmlinux (on 0x000000000006d2b4)
>   ---
> Now the problem is fixed.
