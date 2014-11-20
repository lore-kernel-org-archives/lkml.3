Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbaKTXmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 18:42:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52072 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756879AbaKTXmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 18:42:04 -0500
Message-ID: <546E7C2D.4040301@zytor.com>
Date: Thu, 20 Nov 2014 15:41:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: nick <xerofoify@gmail.com>, tglx@linutronix.de
CC: mingo@redhat.com, x86@kernel.org, luto@amacapital.net,
        rafael.j.wysocki@intel.com, michael.opdenacker@free-electrons.com,
        feng.tang@intel.com, srivatsa.bhat@linux.vnet.ibm.com,
        stefani@seibold.ne, linux-kernel@vger.kernel.org
Subject: Re: Fix Me in hpet.c
References: <546D58BD.801@gmail.com>
In-Reply-To: <546D58BD.801@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2014 06:58 PM, nick wrote:
> Greeting Thomas and other kernel coders,
> I am wondering about the fix in the code below and whether this is still valid as reading it seems to may no sense as 
> we are using completion variables and therefore the delayed version of schedule_work_on seems much better in this
> case. Further more I am pasting the code below from vim in order to make it easier for you.
> Cheers Nick 
> static int hpet_cpuhp_notify(struct notifier_block *n,
>                 unsigned long action, void *hcpu)
> {
>         unsigned long cpu = (unsigned long)hcpu;
>         struct hpet_work_struct work;
>         struct hpet_dev *hdev = per_cpu(cpu_hpet_dev, cpu);
> 
>         switch (action & 0xf) {
>         case CPU_ONLINE:
>                INIT_DELAYED_WORK_ONSTACK(&work.work, hpet_work);
>                init_completion(&work.complete);
>                  /* FIXME: add schedule_work_on() */
>                  schedule_delayed_work_on(cpu, &work.work, 0);
>                 wait_for_completion(&work.complete);
>                 destroy_delayed_work_on_stack(&work.work);
>                 break;
>         case CPU_DEAD:
>                  if (hdev) {
>                        free_irq(hdev->irq, hdev);
>                         hdev->flags &= ~HPET_DEV_USED;
>                         per_cpu(cpu_hpet_dev, cpu) = NULL;
>                }
>                 break;
>          }
>          return NOTIFY_OK;
> }
> 

Looks obsolete to me.  It might be interesting to look at the "git
blame" output for this code.

	-hpa

