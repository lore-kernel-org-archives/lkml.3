Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaLRFOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 00:14:04 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:53991 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaLRFOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 00:14:03 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
Date: Thu, 18 Dec 2014 14:14:20 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, ak@linux.intel.com, lizefan@huawei.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] perf: fix building warning on ARM 32.
Message-ID: <20141218051420.GE20215@sejong>
References: <1418710746-35943-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1418710746-35943-1-git-send-email-wangnan0@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wang,

On Tue, Dec 16, 2014 at 02:19:06PM +0800, Wang Nan wrote:
> Commit 85c116a6c introduces asprintf() call and matches '%ld' to a u64
> argument, which is incorrect on ARM:
> 
>    CC       /home/wn/util/srcline.o
>  util/srcline.c: In function 'get_srcline':
>  util/srcline.c:297:6: error: format '%ld' expects argument of type 'long int', but argument 4 has type 'u64' [-Werror=format]
>  cc1: all warnings being treated as errors
>  make[1]: *** [/home/wn/util/srcline.o] Error 1
> 
> In addition, all users of get_srcline() use u64 addr, and libbfd
> also use 64 bit bfd_vma as address. This patch also fix prototype
> of get_srcline() and addr2line() to use u64 addr instead of
> unsigned long.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung

