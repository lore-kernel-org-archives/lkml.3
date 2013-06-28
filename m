Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3F1RcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 13:32:01 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:39518 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3F1Rb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 13:31:58 -0400
MIME-Version: 1.0
In-Reply-To: <20130628120224.7781.45438.stgit@localhost.localdomain>
References: <20130621072725.GB22006@pd.tnic>
	<20130628120224.7781.45438.stgit@localhost.localdomain>
Date: Fri, 28 Jun 2013 10:31:57 -0700
Message-ID: <CA+8MBbJNY7G+q=kBgOA=+jVtugrfteoMvwLtfwvCno5xg+dm-Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
From: Tony Luck <tony.luck@gmail.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>, ananth@in.ibm.com,
        masbock@linux.vnet.ibm.com, lcm@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Huang Ying <ying.huang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +                       if (sec_sev == GHES_SEV_CORRECTED &&
> +                           (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED) &&
> +                           (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS)) {
> +                               unsigned long pfn;
> +                               pfn = mem_err->physical_addr >> PAGE_SHIFT;

As Reagan said "Trust ... but verify" ... we should make sure BIOS
gave us a good pfn
                                    if (pfn_valid(pfn))
                                         soft_memory_failure_queue(pfn, 0, 0);
                                    else
                                         printk( ...something about
BIOS giving us bad pfn = %lu\n", pfn);
> +                       }
