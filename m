Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbaBTObL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:31:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727AbaBTObJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:31:09 -0500
Date: Thu, 20 Feb 2014 15:31:03 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: WARNING at kernel/workqueue.c:829
 wq_worker_waking_up+0x53/0x70()
Message-ID: <20140220143102.GA12948@krava.brq.redhat.com>
References: <20140213124059.GA2908@krava.brq.redhat.com>
 <20140217171900.GB29173@redhat.com>
 <20140218224907.GG31892@mtj.dyndns.org>
 <530602FA.1020103@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530602FA.1020103@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 09:28:26PM +0800, Lan Tianyu wrote:
> On 02/19/2014 06:49 AM, Tejun Heo wrote:
> >Hello,
> >
> >On Mon, Feb 17, 2014 at 06:19:00PM +0100, Oleg Nesterov wrote:
> >>acpi_processor_set_throttling() plays with set_cpus_allowed_ptr(current),
> >>this is obviously wrong, and the worker is bound.
> >
> >Umm... yeah, anything running on workqueues shouldn't be diddling with
> >cpu affinity.  The function even has /* FIXME: use work_on_cpu() */ in
> >it.  I suppose it's about time to actually implement that?
> >
> >Thanks.
> >
> 
> Hi Jiri:
> 	Could you try this patch which reworks ACPI processor throttling
> with work_on_cpu()?

hum, I've got difficulties to apply it..

[jolsa@krava2 linux-perf]$ git am /tmp/wq/
Applying: WARNING at kernel/workqueue.c:829 wq_worker_waking_up+0x53/0x70()
fatal: corrupt patch at line 8
Patch failed at 0001 WARNING at kernel/workqueue.c:829 wq_worker_waking_up+0x53/0x70()

jirka
