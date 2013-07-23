Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095Ab3GWTQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:16:25 -0400
Received: from mail-gh0-f176.google.com ([209.85.160.176]:59972 "EHLO
	mail-gh0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934044Ab3GWTQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:16:02 -0400
Date: Tue, 23 Jul 2013 15:15:55 -0400
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 04/21] acpi: Remove "continue" in macro INVALID_TABLE().
Message-ID: <20130723191555.GJ21100@mtj.dyndns.org>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
 <1374220774-29974-5-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374220774-29974-5-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 03:59:17PM +0800, Tang Chen wrote:
> The macro INVALID_TABLE() is defined like this:
> 
>  #define INVALID_TABLE(x, path, name)                                    \
>          { pr_err("ACPI OVERRIDE: " x " [%s%s]\n", path, name); continue; }
> 
> And it is used like this:
> 
> 	for (...) {
> 		...
> 		if (...)
> 			INVALID_TABLE()
> 		...
> 	}
> 
> The "continue" in the macro makes the code hard to understand.
> Change it to the style like other macros:
> 
>  #define INVALID_TABLE(x, path, name)                                    \
>          do { pr_err("ACPI OVERRIDE: " x " [%s%s]\n", path, name); } while (0)
> 
> So after this patch, this macro should be used like this:
> 
> 	for (...) {
> 		...
> 		if (...) {
> 			INVALID_TABLE()
> 			continue;
> 		}
> 		...
> 	}
> 
> Add the "continue" wherever the macro is called.
> (For now, it is only called in acpi_initrd_override().)
> 
> The idea is from Yinghai Lu <yinghai@kernel.org>.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
