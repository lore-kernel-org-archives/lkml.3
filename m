Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab3DYLcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:32:01 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:34253 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab3DYLcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:32:00 -0400
Message-ID: <5179140B.3060002@huawei.com>
Date: Thu, 25 Apr 2013 19:31:23 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Anurup m <anurup.m@huawei.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        shyju pv <shyju.pv@huawei.com>, Sanil kumar <sanil.kumar@huawei.com>,
        Nataraj m <nataraj.m@huawei.com>
Subject: Re: [ PATCH ] Memory leak fix for bug 57101.
References: <D2393EB95A9993478029A6FE6A290A9F15F504C9@szxeml510-mbx.china.huawei.com>
In-Reply-To: <D2393EB95A9993478029A6FE6A290A9F15F504C9@szxeml510-mbx.china.huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/25 18:05, Anurup m wrote:
> Hi All,
> 
> There is a kernel memory leak observed when the proc file /proc/fs/fscache/stats is read.
> The reason is that in fscache_stats_open, single_open is called and respective release function is not called during release.
> Hence fix with correct release function - single_release. The patch is as below
> 

The fix is obviously corect, but the patch is mangled so you should configure your
email client properly. Read Documention/email-clients.txt.

And when you've done that, remember Cc maintainers when you resend this patch, i.e.
David Howells <dhowells@redhat.com> and Andrew Morton <akpm@linux-foundation.org>
in this case.

> diff -uprN -X linux-3.9-rc8-vanilla/Documentation/dontdiff linux-3.9-rc8-vanilla/fs/fscache/stats.c linux-3.9-rc8.mod/fs/fscache/stats.c 
> --- linux-3.9-rc8-vanilla/fs/fscache/stats.c        2013-04-22 03:08:45.000000000 +0530 
> +++ linux-3.9-rc8.mod/fs/fscache/stats.c        2013-04-24 23:03:31.531296160 +0530 
> @@ -287,5 +287,5 @@ const struct file_operations fscache_sta 
>          .open                = fscache_stats_open, 
>          .read                = seq_read, 
>          .llseek                = seq_lseek, 
> -        .release        = seq_release, 
> +        .release        = single_release, 

Look the tab was replaced with spaces.

