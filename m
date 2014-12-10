Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbaLJN5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:57:19 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:61292 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972AbaLJN5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:57:16 -0500
Message-ID: <54885139.5090901@gmail.com>
Date: Wed, 10 Dec 2014 06:57:13 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
CC: linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: Re: [PATCH] perf kvm stat live: mark events as (x86 only) in help
 output
References: <1418218090-20718-1-git-send-email-borntraeger@de.ibm.com>
In-Reply-To: <1418218090-20718-1-git-send-email-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/14 6:28 AM, Christian Borntraeger wrote:
> From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
>
> The mmio and ioport events are useful only on x86.
>
> Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>   tools/perf/builtin-kvm.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
> index b65eb050..612e8f9 100644
> --- a/tools/perf/builtin-kvm.c
> +++ b/tools/perf/builtin-kvm.c
> @@ -1268,7 +1268,8 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
>   		OPT_UINTEGER('d', "display", &kvm->display_time,
>   			"time in seconds between display updates"),
>   		OPT_STRING(0, "event", &kvm->report_event, "report event",
> -			"event for reporting: vmexit, mmio, ioport"),
> +			"event for reporting: "
> +			"vmexit, mmio (x86 only), ioport (x86 only)"),
>   		OPT_INTEGER(0, "vcpu", &kvm->trace_vcpu,
>   			"vcpu id to report"),
>   		OPT_STRING('k', "key", &kvm->sort_key, "sort-key",
>

Acked-by: David Ahern <dsahern@gmail.com>
