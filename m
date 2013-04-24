Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941Ab3DXITp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 04:19:45 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:59946 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab3DXITn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 04:19:43 -0400
Message-ID: <51779593.3060703@linux.vnet.ibm.com>
Date: Wed, 24 Apr 2013 16:19:31 +0800
From: Runzhen Wang <runzhen@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: acme@redhat.com
CC: mingo@kernel.org, linux-kernel@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [PATCH] perf tool: fix the perf --version bug
References: <516CDAF5.3020909@linux.vnet.ibm.com>
In-Reply-To: <516CDAF5.3020909@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042408-9574-0000-0000-000007967702
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping~  :)
On 04/16/2013 01:00 PM, Runzhen Wang wrote:
>
> The perf --version can't print the right version
> information when reset it to an earlier commit.
>
> For example, at present the version is:
> # ./perf --version
> perf version 3.9.rc6.gf8378f
>
> then, I reset it to an earlier version tag, say v3.8-rc7
> # git reset --hard v3.8-rc7
> # make
>
> However, the ./perf --version prints a wrong result:
> # ./perf --version
> perf version 3.9.rc6.g836dc9
>
> Using 'git describe' instead of 'git tag' can fix this problem.
>
> Signed-off-by: Runzhen Wang <runzhen@linux.vnet.ibm.com>
> ---
>   tools/perf/util/PERF-VERSION-GEN |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/PERF-VERSION-GEN
> b/tools/perf/util/PERF-VERSION-GEN
> index 055fef3..ec3dd86 100755
> --- a/tools/perf/util/PERF-VERSION-GEN
> +++ b/tools/perf/util/PERF-VERSION-GEN
> @@ -14,9 +14,8 @@ LF='
>   # otherwise try to get the version from the kernel Makefile
>   #
>   if test -d ../../.git -o -f ../../.git &&
> -    VN=$(git tag 2>/dev/null | tail -1 | grep -E "v[0-9].[0-9]*")
> +    VN=$(git describe --match 'v[0-9].[0-9]*' --abbrev=4 HEAD 2>/dev/null)
>   then
> -    VN=$(echo $VN"-g"$(git log -1 --abbrev=4 --pretty=format:"%h" HEAD))
>       VN=$(echo "$VN" | sed -e 's/-/./g');
>   else
>       VN=$(MAKEFLAGS= make -sC ../.. kernelversion)

