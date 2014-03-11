Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbaCKLMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:12:03 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:65504 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaCKLMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:12:01 -0400
Date: Tue, 11 Mar 2014 12:11:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Rui Wang <rui.y.wang@intel.com>,
        Liu Ping Fan <kernelfans@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Lv Zheng <lv.zheng@intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>, Andi Kleen <ak@linux.intel.com>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Li Fei <fei.li@intel.com>, gong.chen@linux.intel.com
Subject: Re: [PATCH] x86, fix x86 fixup_irqs() error handling [v2]
Message-ID: <20140311111156.GB27009@gmail.com>
References: <alpine.DEB.2.02.1403061122010.18573@ionos.tec.linutronix.de>
 <1394111467-3351-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394111467-3351-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Prarit Bhargava <prarit@redhat.com> wrote:

> fixup_irqs() calls chip->set_irq_affinity which eventually calls
> __assign_irq_vector().  Errors are not propogated back from this function call
> and this results in silent irq relocation failures.  This patch fixes this
> issue and prints out a warning if there is a relocation failure.
> 
> [v2]: modified WARN to pr_crit and changed message

Please fix the changelog to conform to the standard changelog style:

 - first describe the symptoms of the bug - how does a user notice? 

 - then describe how the code behaves today and how that is causing the bug

 - and then only describe how it's fixed.

The first item is the most important one - yet it's missing from this 
changelog.

Thanks,

	Ingo
