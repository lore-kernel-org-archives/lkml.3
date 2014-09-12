Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaILW6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 18:58:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:60001 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbaILW6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 18:58:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,515,1406617200"; 
   d="scan'208";a="572534363"
Message-ID: <54137A79.6060602@intel.com>
Date: Fri, 12 Sep 2014 15:58:01 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 04/10] x86, mpx: hook #BR exception handler to allocate
 bound tables
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-5-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1410425210-24789-5-git-send-email-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 01:46 AM, Qiaowei Ren wrote:
> +static int allocate_bt(long __user *bd_entry)
> +{
> +	unsigned long bt_addr, old_val = 0;
> +	int ret = 0;
> +
> +	bt_addr = mpx_mmap(MPX_BT_SIZE_BYTES);
> +	if (IS_ERR((void *)bt_addr))
> +		return bt_addr;
> +	bt_addr = (bt_addr & MPX_BT_ADDR_MASK) | MPX_BD_ENTRY_VALID_FLAG;

Qiaowei, why do we need the "& MPX_BT_ADDR_MASK" here?

