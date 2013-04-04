Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762378Ab3DDSgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 14:36:05 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36037 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762049Ab3DDSgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 14:36:03 -0400
Date: Thu, 4 Apr 2013 11:35:55 -0700
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 07/20] x86, ACPI: Make acpi_initrd_override_find work
 with 32bit flat mode
Message-ID: <20130404183555.GW9425@htj.dyndns.org>
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
 <1362897887-30808-8-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362897887-30808-8-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Mar 09, 2013 at 10:44:34PM -0800, Yinghai Lu wrote:
> For finding with 32bit, it would be easy to access initrd in 32bit
> flat mode, as we don't need to set page table.
> 
> That is from head_32.S, and microcode updating already use this trick.
> 
> Need to change acpi_initrd_override_find to use phys to access global
> variables.
> 
> Pass is_phys in the function, as we can not use address to decide if it
> is phys or virtual address on 32 bit. Boot loader could load initrd above
> max_low_pfn.
> 
> Don't call printk as it uses global variables, so delay print later
> during copying.
> 
> Change table_sigs to use stack instead, otherwise it is too messy to change
> string array to phys and still keep offset calculating correct.
> That size is about 36x4 bytes, and it is small to settle in stack.
> 
> Also remove "continue" in MARCO to make code more readable.

It'd be nice if the error message can be stored somewhere and then
printed out after the system is in proper address mode if that isn't
too complex to achieve.  If it gets too messy, no need to bother.

Thanks.

-- 
tejun
