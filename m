Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaEMUWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 16:22:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaEMUWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 16:22:08 -0400
Date: Tue, 13 May 2014 13:22:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yuan Pengfei" <yuanpf12@sei.pku.edu.cn>
Cc: "'Peter Oberparleiter'" <oberpar@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] gcov: add support for GCC 4.9
Message-Id: <20140513132207.36882e1ac7691110c1143660@linux-foundation.org>
In-Reply-To: <000d01cf6e42$b2fac6f0$18f054d0$@sei.pku.edu.cn>
References: <000d01cf6e42$b2fac6f0$18f054d0$@sei.pku.edu.cn>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014 08:31:36 +0800 "Yuan Pengfei" <yuanpf12@sei.pku.edu.cn> wrote:

> From: Yuan Pengfei <coolypf@qq.com>
> 
> This patch handles the gcov-related changes in GCC 4.9:
>   A new counter (time profile) is added.
> See http://gcc.gnu.org/gcc-4.9/changes.html

That link doesn't describe __gcov_merge_time_profile() and a quick web
search didn't turn up anything terribly useful.

> --- a/kernel/gcov/base.c
> +++ b/kernel/gcov/base.c
> @@ -85,6 +85,12 @@ void __gcov_merge_ior(gcov_type *counters, unsigned int
> n_counters)
>  }
>  EXPORT_SYMBOL(__gcov_merge_ior);
>  
> +void __gcov_merge_time_profile(gcov_type *counters, unsigned int
> n_counters)
> +{
> +	/* Unused. */
> +}
> +EXPORT_SYMBOL(__gcov_merge_time_profile);

So it would be useful for you to describe this change within the patch
changelog so that others can understand and review it.

