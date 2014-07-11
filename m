Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaGKQXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:23:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:31649 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbaGKQXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:23:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,644,1400050800"; 
   d="scan'208";a="542098617"
Message-ID: <53C00F69.7070705@intel.com>
Date: Fri, 11 Jul 2014 09:23:05 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 04/10] x86, mpx: hook #BR exception handler to allocate
 bound tables
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com> <1403084656-27284-5-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1403084656-27284-5-git-send-email-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 02:44 AM, Qiaowei Ren wrote:
> +	bt_addr = mpx_mmap(MPX_BT_SIZE_BYTES);
> +	if (IS_ERR((void *)bt_addr)) {
> +		pr_err("Bounds table allocation failed at entry addr %p\n",
> +				bd_entry);
> +		return bt_addr;
> +	}

Don't forget to remove the unnecessary pr_*() calls for the next version.
