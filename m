Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934629AbaFSU6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:58:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:43454 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343AbaFSU6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:58:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,509,1400050800"; 
   d="scan'208";a="560374922"
Message-ID: <53A34EFC.5070809@intel.com>
Date: Thu, 19 Jun 2014 13:58:36 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com> <1403084656-27284-9-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1403084656-27284-9-git-send-email-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 02:44 AM, Qiaowei Ren wrote:
> +static __user void *task_get_bounds_dir(struct task_struct *tsk)
> +{
> +	struct xsave_struct *xsave_buf;
> +
> +	fpu_xsave(&tsk->thread.fpu);
> +	xsave_buf = &(tsk->thread.fpu.state->xsave);
> +	if (!(xsave_buf->bndcsr.cfg_reg_u & MPX_BNDCFG_ENABLE_FLAG))
> +		return NULL;
> +
> +	return (void __user *)(xsave_buf->bndcsr.cfg_reg_u &
> +			MPX_BNDCFG_ADDR_MASK);
> +}

This spits out a warning on 32-bit:

arch/x86/kernel/mpx.c: In function ‘task_get_bounds_dir’:
arch/x86/kernel/mpx.c:21:9: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]



