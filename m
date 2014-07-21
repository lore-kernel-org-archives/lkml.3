Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbaGUGIC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:08:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:55174 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbaGUGIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:08:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="576279578"
From: Andi Kleen <andi@firstfloor.org>
To: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 07/10] x86, mpx: decode MPX instruction to get bound violation information
References: <1405921124-4230-1-git-send-email-qiaowei.ren@intel.com>
	<1405921124-4230-8-git-send-email-qiaowei.ren@intel.com>
Date: Sun, 20 Jul 2014 23:07:59 -0700
In-Reply-To: <1405921124-4230-8-git-send-email-qiaowei.ren@intel.com> (Qiaowei
	Ren's message of "Mon, 21 Jul 2014 13:38:41 +0800")
Message-ID: <87ppgz2qio.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Qiaowei Ren <qiaowei.ren@intel.com> writes:
> +	 */
> +#ifdef CONFIG_X86_64
> +	insn->x86_64 = 1;
> +	insn->addr_bytes = 8;
> +#else
> +	insn->x86_64 = 0;
> +	insn->addr_bytes = 4;
> +#endif

How would that handle compat mode on a 64bit kernel?
Should likely look at the code segment instead of ifdef.
> +	/* Note: the upper 32 bits are ignored in 32-bit mode. */

Again correct for compat mode? I believe the upper bits 
are undefined.


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
