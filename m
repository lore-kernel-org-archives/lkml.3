Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438AbaKUMej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:34:39 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36566 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758415AbaKUMeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:34:37 -0500
Date: Fri, 21 Nov 2014 12:35:26 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "kamalesh@linux.vnet.ibm.com" <kamalesh@linux.vnet.ibm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v9 03/10] sched: remove frequency scaling from
 cpu_capacity
Message-ID: <20141121123526.GD23177@e105550-lin.cambridge.arm.com>
References: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
 <1415033687-23294-4-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415033687-23294-4-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 04:54:40PM +0000, Vincent Guittot wrote:
> Now that arch_scale_cpu_capacity has been introduced to scale the original
> capacity, the arch_scale_freq_capacity is no longer used (it was
> previously used by ARM arch). Remove arch_scale_freq_capacity from the
> computation of cpu_capacity. The frequency invariance will be handled in the
> load tracking and not in the CPU capacity. 

Just a note:

Yes, we are scaling the load tracking of each task to compensate for
frequency scaling. I think that is all fine. Later we will have to feed
the current frequency into the energy model as well to figure out if
putting more tasks on a cpu will/should cause the frequency to increase
or not. We don't need it for now and don't need to add it in the commit
message. It is just a reminder that we may actually want to use
arch_scale_freq_capacity() combined with cpu_capacity to provide this
input to the energy model later.
