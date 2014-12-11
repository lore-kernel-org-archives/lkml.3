Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933747AbaLKNcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 08:32:00 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:49008 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaLKNb7 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:15:1>);
	Thu, 11 Dec 2014 08:31:59 -0500
Message-Id: <5489AADA020000780004EFB9@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Thu, 11 Dec 2014 13:31:54 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: <luto@amacapital.net>, <david.vrabel@citrix.com>, <rostedt@goodmis.org>,
        <masami.hiramatsu.pt@hitachi.com>, <peterz@infradead.org>,
        <x86@kernel.org>, <tglx@linutronix.de>,
        <xen-devel@lists.xenproject.org>, <konrad.wilk@oracle.com>,
        <mingo@redhat.com>, "Juergen Gross" <JGross@suse.com>,
        "Luis Rodriguez" <Mcgrof@suse.com>, "Borislav Petkov" <bp@suse.de>,
        <bpoirier@suse.de>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH v2 1/2] sched: add cond_resched_irq()
References: <1418254487-9988-1-git-send-email-mcgrof@do-not-panic.com>
 <1418254487-9988-2-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1418254487-9988-2-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 11.12.14 at 00:34, <mcgrof@do-not-panic.com> wrote:
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4239,6 +4239,16 @@ int __sched _cond_resched(void)
>  }
>  EXPORT_SYMBOL(_cond_resched);
>  
> +int __sched cond_resched_irq(void)
> +{
> +	if (should_resched()) {
> +		preempt_schedule_irq();
> +		return 1;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(cond_resched_irq);

Do you really want to export to modules a symbol like this?

Jan

