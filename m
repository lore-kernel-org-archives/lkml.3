Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413Ab3GTHfF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 03:35:05 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:53952 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3GTHfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 03:35:04 -0400
Date: Sat, 20 Jul 2013 09:34:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Gang Wei <gang.wei@intel.com>
Subject: Re: [PATCH] x86, tboot: iomem fixes
Message-ID: <20130720073459.GA5555@gmail.com>
References: <1374282787-30327-1-git-send-email-qiaowei.ren@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374282787-30327-1-git-send-email-qiaowei.ren@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Qiaowei Ren <qiaowei.ren@intel.com> wrote:

> +#define SINIT_MLE_DATA_VTD_DMAR_OFF	140

>  	/* get addr of DMAR table */
> +	dmar_tbl_off = readl(heap_ptr + SINIT_MLE_DATA_VTD_DMAR_OFF);
>  	dmar_tbl = (struct acpi_table_header *)(heap_ptr +
> -		   ((struct sinit_mle_data *)heap_ptr)->vtd_dmars_off -
> -		   sizeof(u64));
> +			dmar_tbl_off - sizeof(u64));

So the offset of ->vtd_dmars_off within struct sinit_mle_data is 140?

The new code is less readable: what's wrong with getting the offset 
automatically via C, instead of hardcoding it manually? You can use 
offsetof() primitive for increased readability.

Thanks,

	Ingo
