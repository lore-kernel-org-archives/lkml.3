Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaGaOYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:24:08 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:52796 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaGaOYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:24:06 -0400
Message-ID: <53DA5183.9000305@gmail.com>
Date: Thu, 31 Jul 2014 08:24:03 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>,
        Jiri Olsa <jolsa@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: Re: [PATCH/RFC] KVM: perf/stat: Properly show submicrosecond times
References: <1406805231-10675-1-git-send-email-borntraeger@de.ibm.com> <1406805231-10675-2-git-send-email-borntraeger@de.ibm.com>
In-Reply-To: <1406805231-10675-2-git-send-email-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/14, 5:13 AM, Christian Borntraeger wrote:
> For lots of exits the min time (and sometimes max) is 0 or 1. Lets
> increase the accurancy similar to what the average field alread does.

Seems reasonable to me.

Acked-by: David Ahern <dsahern@gmail.com>


>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>   tools/perf/builtin-kvm.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
> index 43367eb..fe92dfd 100644
> --- a/tools/perf/builtin-kvm.c
> +++ b/tools/perf/builtin-kvm.c
> @@ -592,8 +592,8 @@ static void print_result(struct perf_kvm_stat *kvm)
>   	pr_info("%9s ", "Samples%");
>
>   	pr_info("%9s ", "Time%");
> -	pr_info("%10s ", "Min Time");
> -	pr_info("%10s ", "Max Time");
> +	pr_info("%11s ", "Min Time");
> +	pr_info("%11s ", "Max Time");
>   	pr_info("%16s ", "Avg time");
>   	pr_info("\n\n");
>
> @@ -610,8 +610,8 @@ static void print_result(struct perf_kvm_stat *kvm)
>   		pr_info("%10llu ", (unsigned long long)ecount);
>   		pr_info("%8.2f%% ", (double)ecount / kvm->total_count * 100);
>   		pr_info("%8.2f%% ", (double)etime / kvm->total_time * 100);
> -		pr_info("%8" PRIu64 "us ", min / 1000);
> -		pr_info("%8" PRIu64 "us ", max / 1000);
> +		pr_info("%9.2fus ", (double)min / 1e3);
> +		pr_info("%9.2fus ", (double)max / 1e3);
>   		pr_info("%9.2fus ( +-%7.2f%% )", (double)etime / ecount/1e3,
>   			kvm_event_rel_stddev(vcpu, event));
>   		pr_info("\n");
>

