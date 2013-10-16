Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761548Ab3JPR3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:29:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47786 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761246Ab3JPR3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:29:35 -0400
Date: Wed, 16 Oct 2013 19:29:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, joe@perches.com, naveen.n.rao@linux.vnet.ibm.com,
        m.chehab@samsung.com, arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 9/9] ACPI / trace: Add trace interface for eMCA driver
Message-ID: <20131016172920.GN13608@pd.tnic>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
 <1381935366-11731-10-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1381935366-11731-10-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 10:56:06AM -0400, Chen, Gong wrote:
> Use trace interface to elaborate all H/W error related
> information.
> 
> v2 -> v1: move trace interface into ras_event.h
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> ---

Just a nitpick below. Other than that:

Acked-by: Borislav Petkov <bp@suse.de>

> diff --git a/drivers/acpi/extlog_trace.h b/drivers/acpi/extlog_trace.h
> new file mode 100644
> index 0000000..67bb2c5
> --- /dev/null
> +++ b/drivers/acpi/extlog_trace.h
> @@ -0,0 +1,16 @@
> +#ifndef __DEBUG_EXTLOG_H
> +#define __DEBUG_EXTLOG_H
> +
> +#include <linux/cper.h>
> +
> +#ifdef CONFIG_EXTLOG_TRACE
> +extern void trace_mem_error(const uuid_le *fru_id, char *fru_text,
> +		u64 err_count, u32 severity, struct cper_sec_mem_err *mem);

Applying: ACPI / trace: Add trace interface for eMCA driver
CHECK: extern prototypes should be avoided in .h files
#265: FILE: drivers/acpi/extlog_trace.h:7:
+extern void trace_mem_error(const uuid_le *fru_id, char *fru_text,

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
