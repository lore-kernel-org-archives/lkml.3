Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbaAGO0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:26:37 -0500
Received: from 8bytes.org ([85.214.48.195]:36182 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbaAGO03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:26:29 -0500
Date: Tue, 7 Jan 2014 15:26:25 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: akpm@linux-foundation.org, alexander.h.duyck@intel.com,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH v2] dma-debug: enhance dma_debug_device_change() to check
 for mapping errors
Message-ID: <20140107142625.GC2742@8bytes.org>
References: <1384376168-2148-1-git-send-email-shuah.kh@samsung.com>
 <20131230141511.GC2799@8bytes.org>
 <52C700BC.1010200@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C700BC.1010200@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Jan  7 15:26:27 2014
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 52cc0e9320861528115512
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 11:26:04AM -0700, Shuah Khan wrote:
> On 12/30/2013 07:15 AM, Joerg Roedel wrote:
> >I think it is better to check for this in a seperate function and use
> >err_printk instead of dev_warn in the end to print the errors.
> >The new function can then be called in the dma_debug_device_change
> >callback like device_dma_allocations is.
> >
> 
> I did explore separate function option and backed off from it since
> the new routine will have to duplicate what device_dma_allocations()
> does except that it checks for entry->map_err_type.
> 
> I still have the patch that does that saved away. If you still
> prefer that approach, I can rework the patch and send it.

You can get rid of the code duplication by defining for_each macros for
the list traversals. So I would still prefer to have this check in a
seperate function.


	Joerg


