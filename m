Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbaBTPR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 10:17:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165AbaBTPR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 10:17:28 -0500
Date: Thu, 20 Feb 2014 16:17:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Tejun Heo <tj@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: WARNING at kernel/workqueue.c:829
	wq_worker_waking_up+0x53/0x70()
Message-ID: <20140220151721.GB32719@redhat.com>
References: <20140213124059.GA2908@krava.brq.redhat.com> <20140217171900.GB29173@redhat.com> <20140218224907.GG31892@mtj.dyndns.org> <530602FA.1020103@intel.com> <20140220143102.GA12948@krava.brq.redhat.com> <5306150C.4020202@intel.com> <20140220151317.GA32719@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220151317.GA32719@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20, Oleg Nesterov wrote:
>
> On 02/20, Lan Tianyu wrote:
> >
> > @@ -1096,7 +1112,6 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
> >  		return -ENODEV;
> >  	}
> >
> > -	cpumask_copy(saved_mask, &current->cpus_allowed);
>
> Yes, but the patch forgets to kill alloc_cpumask_var(&saved_mask)
> and saved_mask itself ;)

And it seems that acpi_processor_set_throttling() doesn't need
online_throttling_cpus at all. It could use
for_each_cpu_and(cpu_online_mask, p_throttling->shared_cpu_map).

Oleg.

