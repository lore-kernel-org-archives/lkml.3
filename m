Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3C3Kbi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 06:31:38 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:11955 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab3C3Kbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 06:31:36 -0400
Message-ID: <5156BECE.9070701@huawei.com>
Date: Sat, 30 Mar 2013 18:30:38 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: do not exit in main process subroutine
References: <5153BC45.807@huawei.com>
In-Reply-To: <5153BC45.807@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/28 11:43, zhangwei(Jovi) wrote:
> Currently checkpatch program exit when process empty file,
> This will cause issue when @ARGV include many files ready to check.
> 
> For example, there may have Module.symvers empty file in kernel directory.
> 
> [root@jovi ~]# scripts/checkpatch.pl -f kernel/*
> 
> then many file "after" empty file will not be check by script.
> so disallow exit in main process subroutine.
> 
> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Joe, Ping?

> ---
>  scripts/checkpatch.pl |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index b28cc38..6924733 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3634,19 +3634,19 @@ sub process {
>  	# If we have no input at all, then there is nothing to report on
>  	# so just keep quiet.
>  	if ($#rawlines == -1) {
> -		exit(0);
> +		return $clean;
>  	}
> 
>  	# In mailback mode only produce a report in the negative, for
>  	# things that appear to be patches.
>  	if ($mailback && ($clean == 1 || !$is_patch)) {
> -		exit(0);
> +		return $clean;
>  	}
> 
>  	# This is not a patch, and we are are in 'no-patch' mode so
>  	# just keep quiet.
>  	if (!$chk_patch && !$is_patch) {
> -		exit(0);
> +		return $clean;
>  	}
> 
>  	if (!$is_patch) {
> 


