Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750869Ab3GAPH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 11:07:57 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:55776 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab3GAPHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 11:07:55 -0400
Message-ID: <51D19B3F.3060405@linux.vnet.ibm.com>
Date: Mon, 01 Jul 2013 20:37:43 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: Borislav Petkov <bp@alien8.de>, ananth@in.ibm.com,
        masbock@linux.vnet.ibm.com, lcm@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH v2 2/2] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
References: <20130621072725.GB22006@pd.tnic> <20130628120224.7781.45438.stgit@localhost.localdomain> <CA+8MBbJNY7G+q=kBgOA=+jVtugrfteoMvwLtfwvCno5xg+dm-Q@mail.gmail.com>
In-Reply-To: <CA+8MBbJNY7G+q=kBgOA=+jVtugrfteoMvwLtfwvCno5xg+dm-Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070115-7014-0000-0000-00000341BF8F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2013 11:01 PM, Tony Luck wrote:
>> +                       if (sec_sev == GHES_SEV_CORRECTED &&
>> +                           (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED) &&
>> +                           (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS)) {
>> +                               unsigned long pfn;
>> +                               pfn = mem_err->physical_addr >> PAGE_SHIFT;
>
> As Reagan said "Trust ... but verify" ... we should make sure BIOS
> gave us a good pfn
>                                      if (pfn_valid(pfn))
>                                           soft_memory_failure_queue(pfn, 0, 0);
>                                      else
>                                           printk( ...something about
> BIOS giving us bad pfn = %lu\n", pfn);

Ah, nice catch - I thought soft_offline_page() takes care of this, but 
it sure is good to point a finger at the firmware.

Thanks!
- Naveen

>> +                       }
>

