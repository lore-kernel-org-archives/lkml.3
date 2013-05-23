Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111Ab3EWNge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 09:36:34 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:60861 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759049Ab3EWNgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 09:36:33 -0400
MIME-Version: 1.0
In-Reply-To: <1369203761-12649-2-git-send-email-khandual@linux.vnet.ibm.com>
References: <1369203761-12649-1-git-send-email-khandual@linux.vnet.ibm.com>
	<1369203761-12649-2-git-send-email-khandual@linux.vnet.ibm.com>
Date: Thu, 23 May 2013 15:36:32 +0200
Message-ID: <CABPqkBQqH7vz9Qgom=heL6N3JniFeZKciGbQfR0PjuK-NVA0-A@mail.gmail.com>
Subject: Re: [PATCH 1/5] perf: New conditional branch filter criteria in
 branch stack sampling
From: Stephane Eranian <eranian@google.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Linux PPC dev <linuxppc-dev@ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 8:22 AM, Anshuman Khandual
<khandual@linux.vnet.ibm.com> wrote:
> POWER8 PMU based BHRB supports filtering for conditional branches.
> This patch introduces new branch filter PERF_SAMPLE_BRANCH_COND which
> will extend the existing perf ABI. Other architectures can provide
> this functionality with either HW filtering support (if present) or
> with SW filtering of instructions.
>
Reviewed-by: Stephane Eranian <eranian@google.com>

> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> ---
>  include/uapi/linux/perf_event.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index fb104e5..cb0de86 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -157,8 +157,9 @@ enum perf_branch_sample_type {
>         PERF_SAMPLE_BRANCH_ANY_CALL     = 1U << 4, /* any call branch */
>         PERF_SAMPLE_BRANCH_ANY_RETURN   = 1U << 5, /* any return branch */
>         PERF_SAMPLE_BRANCH_IND_CALL     = 1U << 6, /* indirect calls */
> +       PERF_SAMPLE_BRANCH_COND         = 1U << 7, /* conditional branches */
>
> -       PERF_SAMPLE_BRANCH_MAX          = 1U << 7, /* non-ABI */
> +       PERF_SAMPLE_BRANCH_MAX          = 1U << 8, /* non-ABI */
>  };
>
>  #define PERF_SAMPLE_BRANCH_PLM_ALL \
> --
> 1.7.11.7
>
