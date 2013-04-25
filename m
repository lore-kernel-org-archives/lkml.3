Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab3DYNtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:49:35 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:12506 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab3DYNtd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:49:33 -0400
From: Anurup m <anurup.m@huawei.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
CC: "'David Howells'" <dhowells@redhat.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        Lizefan <lizefan@huawei.com>, shyju pv <shyju.pv@huawei.com>,
        Sanil kumar <sanil.kumar@huawei.com>, Nataraj m <nataraj.m@huawei.com>
Subject: RE: [ PATCH ] Memory leak fix for bug 57101.
Thread-Topic: [ PATCH ] Memory leak fix for bug 57101.
Thread-Index: AQHOQahxzqL9KVVou0O8Lql76ItKRZjm8y9Q
Date: Thu, 25 Apr 2013 13:49:12 +0000
Message-ID: <D2393EB95A9993478029A6FE6A290A9F15F50787@szxeml510-mbx.china.huawei.com>
References: <D2393EB95A9993478029A6FE6A290A9F15F504C9@szxeml510-mbx.china.huawei.com>
 <5179140B.3060002@huawei.com>
In-Reply-To: <5179140B.3060002@huawei.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.18.96.95]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Resending the patch as Plain text, with no mangled tabs.

The patch is as below

diff -uprN -X linux-3.9-rc8-vanilla/Documentation/dontdiff linux-3.9-rc8-vanilla/fs/fscache/stats.c linux-3.9-rc8.mod/fs/fscache/stats.c
--- linux-3.9-rc8-vanilla/fs/fscache/stats.c	2013-04-22 03:08:45.000000000 +0530
+++ linux-3.9-rc8.mod/fs/fscache/stats.c	2013-04-24 23:03:31.531296160 +0530
@@ -287,5 +287,5 @@ const struct file_operations fscache_sta
 	.open		= fscache_stats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release		= seq_release,
+	.release		= single_release,
 };

Regards,
Anurup M

-----Original Message-----
From: Lizefan 
Sent: 2013年4月25日 17:01
To: Anurup m
Cc: 'linux-kernel@vger.kernel.org'; shyju pv; Sanil kumar; Nataraj m
Subject: Re: [ PATCH ] Memory leak fix for bug 57101.

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

