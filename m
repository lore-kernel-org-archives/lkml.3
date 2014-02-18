Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbaBRWtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:49:16 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:46375 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaBRWtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:49:12 -0500
Date: Tue, 18 Feb 2014 17:49:07 -0500
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: WARNING at kernel/workqueue.c:829 wq_worker_waking_up+0x53/0x70()
Message-ID: <20140218224907.GG31892@mtj.dyndns.org>
References: <20140213124059.GA2908@krava.brq.redhat.com>
 <20140217171900.GB29173@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140217171900.GB29173@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 17, 2014 at 06:19:00PM +0100, Oleg Nesterov wrote:
> acpi_processor_set_throttling() plays with set_cpus_allowed_ptr(current),
> this is obviously wrong, and the worker is bound.

Umm... yeah, anything running on workqueues shouldn't be diddling with
cpu affinity.  The function even has /* FIXME: use work_on_cpu() */ in
it.  I suppose it's about time to actually implement that?

Thanks.

-- 
tejun
