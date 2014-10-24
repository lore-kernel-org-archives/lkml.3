Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbaJXMI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:08:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:47375 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203AbaJXMIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:08:25 -0400
Date: Fri, 24 Oct 2014 14:08:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Qiaowei Ren <qiaowei.ren@intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH v9 05/12] x86, mpx: on-demand kernel allocation of bounds
 tables
In-Reply-To: <1413088915-13428-6-git-send-email-qiaowei.ren@intel.com>
Message-ID: <alpine.DEB.2.11.1410241257300.5308@nanos>
References: <1413088915-13428-1-git-send-email-qiaowei.ren@intel.com> <1413088915-13428-6-git-send-email-qiaowei.ren@intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Oct 2014, Qiaowei Ren wrote:
> +	/*
> +	 * Go poke the address of the new bounds table in to the
> +	 * bounds directory entry out in userspace memory.  Note:
> +	 * we may race with another CPU instantiating the same table.
> +	 * In that case the cmpxchg will see an unexpected
> +	 * 'actual_old_val'.
> +	 */
> +	ret = user_atomic_cmpxchg_inatomic(&actual_old_val, bd_entry,
> +					   expected_old_val, bt_addr);

This is fully preemptible non-atomic context, right?

So this wants a proper comment, why using
user_atomic_cmpxchg_inatomic() is the right thing to do here.

Thanks,

	tglx
