Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbaAHTDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:03:31 -0500
Received: from [65.55.88.15] ([65.55.88.15]:38012 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752515AbaAHTD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:03:28 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VPS-6(zzbb2dI98dI9371I1458K1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzdchd2iz1de098h8275bh1de097hz2dh839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h1155h)
X-WSS-ID: 0MZ3JFW-07-581-02
X-M-MSG: 
Message-ID: <52CDA054.4010700@amd.com>
Date: Wed, 8 Jan 2014 13:00:36 -0600
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <fweisbec@gmail.com>, <mingo@kernel.org>, <mingo@redhat.com>,
        <jacob.w.shin@gmail.com>
CC: <oleg@redhat.com>, <a.p.zijlstra@chello.nl>, <acme@ghostprotocols.net>,
        <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <sherry.hurwitz@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH V6 0/4] perf/x86/amd: AMD Family 16h Data Breakpoint Extensions
References: <1386764906-1681-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1386764906-1681-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.  Are there any other concerns regarding this patch?

Thank you,

Suravee

On 12/11/2013 6:28 AM, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>
> The following patchset enables hardware breakpoint bp_len greater than
> HW_BREAKPOINT_LEN_8 on AMD Family 16h and later.
>
>    $ perf stat -e mem:0x1000/16:w a.out
>                              ^^
>                              bp_len
>
> This will count writes to [0x1000 ~ 0x1010)
>
> V6:
> * Minor clean up in patch 1 and 2 based on comment from Frederic and Oleg.
> * Split out changes in patch1 into patch4 per Frederic request.
>
> V5:
> * Rebase onto 3.12.0-rc3.
> * Modify the tools/perf/util/parse-events.y due to change in
>    parse_events_add_breakpoint().
>
> V4:
> Even more per Oleg's suggestion:
> * Further simplify info->len and info->mask setting switch statement
>
> V3:
> More per Oleg's suggestion:
> * Use already existing bp_len instead of changing userland API and
>    in kernel turn bp_len into proper AMD hardware breakpoint address
>    mask.
>
> V2:
> Per Oleg's suggestions:
> * Moved testing of bp_addr_mask to validate_hw_breakpoint()
> * Changed perf tool syntax to mem:<addr>[/addr_mask][:access]
>
> Jacob Shin (4):
>    perf/x86/amd: AMD support for bp_len > HW_BREAKPOINT_LEN_8
>    perf tools: allow user to specify hardware breakpoint bp_len
>    perf tools: add hardware breakpoint bp_len test cases
>    perf/x86: Remove get_hbp_len and replace with bp_len
>
>   arch/x86/include/asm/cpufeature.h        |  2 ++
>   arch/x86/include/asm/debugreg.h          |  5 +++
>   arch/x86/include/asm/hw_breakpoint.h     |  1 +
>   arch/x86/include/uapi/asm/msr-index.h    |  4 +++
>   arch/x86/kernel/cpu/amd.c                | 19 +++++++++++
>   arch/x86/kernel/hw_breakpoint.c          | 45 ++++++++++----------------
>   tools/perf/Documentation/perf-record.txt |  7 ++--
>   tools/perf/tests/parse-events.c          | 55 ++++++++++++++++++++++++++++++++
>   tools/perf/util/parse-events.c           | 21 ++++++------
>   tools/perf/util/parse-events.h           |  2 +-
>   tools/perf/util/parse-events.l           |  1 +
>   tools/perf/util/parse-events.y           | 26 +++++++++++++--
>   12 files changed, 145 insertions(+), 43 deletions(-)
>


