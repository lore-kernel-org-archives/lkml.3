Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab3K1IxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:53:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53629 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab3K1IxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:53:19 -0500
X-IronPort-AV: E=Sophos;i="4.93,789,1378828800"; 
   d="scan'208";a="9145356"
Message-ID: <5297BAE4.6060805@cn.fujitsu.com>
Date: Thu, 28 Nov 2013 16:51:32 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, eranian@google.com, dsahern@gmail.com,
        adrian.hunter@intel.com, acme@ghostprotocols.net, mingo@redhat.com,
        paulus@samba.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH] perf machine: Remove condition in machine__get_kernel_start_addr.
References: <1385675245-2224-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1385675245-2224-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/28 16:53:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/28 16:53:19,
	Serialize complete at 2013/11/28 16:53:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry for the error patch :(, Please ignore it.

On 11/28/2013 04:47 PM, Dongsheng Yang wrote:
> In machine__get_kernel_start_addr, the code, which is
> using machine->root_dir to build filename, works for both
> host and guests initialized from guestmount. So this patch
> remove the branch for machine__is_host.
>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>   tools/perf/util/machine.c | 16 ++++++----------
>   1 file changed, 6 insertions(+), 10 deletions(-)
>
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index 84cdb07..52d9161 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -502,15 +502,11 @@ static u64 machine__get_kernel_start_addr(struct machine *machine)
>   	char path[PATH_MAX];
>   	struct process_args args;
>   
> -	if (machine__is_host(machine)) {
> -		filename = "/proc/kallsyms";
> -	} else {
> -		if (machine__is_default_guest(machine))
> -			filename = (char *)symbol_conf.default_guest_kallsyms;
> -		else {
> -			sprintf(path, "%s/proc/kallsyms", machine->root_dir);
> -			filename = path;
> -		}
> +	if (machine__is_default_guest(machine))
> +		filename = (char *)symbol_conf.default_guest_kallsyms;
> +	else {
> +		sprintf(path, "%s/proc/kallsyms", machine->root_dir);
> +		filename = path;
>   	}
>   
>   	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
> @@ -589,7 +585,7 @@ int machines__create_guest_kernel_maps(struct machines *machines)
>   	if (symbol_conf.default_guest_vmlinux_name ||
>   	    symbol_conf.default_guest_modules ||
>   	    symbol_conf.default_guest_kallsyms) {
> -		machines__create_kernel_maps(machines, DEFAULT_GUEST_KERNEL_ID);
> +		machines__create_kernel_maps(machines, 20315);
>   	}
>   
>   	if (symbol_conf.guestmount) {

