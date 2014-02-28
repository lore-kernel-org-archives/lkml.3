Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaB1JjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 04:39:05 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:55523 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaB1JjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 04:39:01 -0500
Message-ID: <53105940.8010203@linux.vnet.ibm.com>
Date: Fri, 28 Feb 2014 10:39:12 +0100
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org
CC: josh@joshtriplett.org
Subject: Re: [PATCH 11/46] kernel: Add prototype declaration in kernel/gcov/base.c
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com> <6fc7e35882693c30f7f7adad20838a123fac29c3.1393493276.git.rashika.kheria@gmail.com>
In-Reply-To: <6fc7e35882693c30f7f7adad20838a123fac29c3.1393493276.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022809-0542-0000-0000-0000082C1210
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.02.2014 12:39, Rashika Kheria wrote:
> Add prototype declarations of functions in kernel/gcov/base.c. These
> functions are required by GCC builtins and hence can not be removed
> despite of their unreferenced appearance in kernel source.
> 
> This eliminates the following warning in kernel/gcov/base.c:
> kernel/gcov/base.c:30:6: warning: no previous prototype for ‘__gcov_init’ [-Wmissing-prototypes]
> kernel/gcov/base.c:58:6: warning: no previous prototype for ‘__gcov_flush’ [-Wmissing-prototypes]
> kernel/gcov/base.c:64:6: warning: no previous prototype for ‘__gcov_merge_add’ [-Wmissing-prototypes]
> kernel/gcov/base.c:70:6: warning: no previous prototype for ‘__gcov_merge_single’ [-Wmissing-prototypes]
> kernel/gcov/base.c:76:6: warning: no previous prototype for‘__gcov_merge_delta’ [-Wmissing-prototypes]
> kernel/gcov/base.c:82:6: warning: no previous prototype for ‘__gcov_merge_ior’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Acked-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

> ---
>  kernel/gcov/base.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/kernel/gcov/base.c b/kernel/gcov/base.c
> index f45b75b..c0cb53a 100644
> --- a/kernel/gcov/base.c
> +++ b/kernel/gcov/base.c
> @@ -27,6 +27,7 @@ static DEFINE_MUTEX(gcov_lock);
>   * __gcov_init is called by gcc-generated constructor code for each object
>   * file compiled with -fprofile-arcs.
>   */
> +void __gcov_init(struct gcov_info *info);
>  void __gcov_init(struct gcov_info *info)
>  {
>  	static unsigned int gcov_version;
> @@ -55,30 +56,35 @@ EXPORT_SYMBOL(__gcov_init);
>   * These functions may be referenced by gcc-generated profiling code but serve
>   * no function for kernel profiling.
>   */
> +void __gcov_flush(void);
>  void __gcov_flush(void)
>  {
>  	/* Unused. */
>  }
>  EXPORT_SYMBOL(__gcov_flush);
> 
> +void __gcov_merge_add(gcov_type *counters, unsigned int n_counters);
>  void __gcov_merge_add(gcov_type *counters, unsigned int n_counters)
>  {
>  	/* Unused. */
>  }
>  EXPORT_SYMBOL(__gcov_merge_add);
> 
> +void __gcov_merge_single(gcov_type *counters, unsigned int n_counters);
>  void __gcov_merge_single(gcov_type *counters, unsigned int n_counters)
>  {
>  	/* Unused. */
>  }
>  EXPORT_SYMBOL(__gcov_merge_single);
> 
> +void __gcov_merge_delta(gcov_type *counters, unsigned int n_counters);
>  void __gcov_merge_delta(gcov_type *counters, unsigned int n_counters)
>  {
>  	/* Unused. */
>  }
>  EXPORT_SYMBOL(__gcov_merge_delta);
> 
> +void __gcov_merge_ior(gcov_type *counters, unsigned int n_counters);
>  void __gcov_merge_ior(gcov_type *counters, unsigned int n_counters)
>  {
>  	/* Unused. */
> 

-- 
Peter Oberparleiter
Linux on System z Development - IBM Germany

