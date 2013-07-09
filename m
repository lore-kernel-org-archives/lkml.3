Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3GIArT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 20:47:19 -0400
Received: from intranet.asianux.com ([58.214.24.6]:40423 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab3GIArS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 20:47:18 -0400
X-Spam-Score: -100.8
Message-ID: <51DB5D5F.4050501@asianux.com>
Date: Tue, 09 Jul 2013 08:46:23 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Wang YanQing <udknight@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, lig.fnst@cn.fujitsu.com,
        chuansheng.liu@intel.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel/smp.c: free related resources when failure
 occurs in hotplug_cfd()
References: <51DA7D50.8010209@asianux.com> <20130709002830.GA2071@udknight> <51DB5A22.9080307@asianux.com> <51DB5C99.50405@asianux.com> <20130709004617.GA3129@udknight>
In-Reply-To: <20130709004617.GA3129@udknight>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 08:46 AM, Wang YanQing wrote:
> On Tue, Jul 09, 2013 at 08:43:05AM +0800, Chen Gang wrote:
>> > When failure occurs in hotplug_cfd(), need release related resources,
>> > or will cause memory leak.
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> > ---
>> >  kernel/smp.c |    5 ++++-
>> >  1 files changed, 4 insertions(+), 1 deletions(-)
>> > 
>> > diff --git a/kernel/smp.c b/kernel/smp.c
>> > index 02a885d..2a3a017 100644
>> > --- a/kernel/smp.c
>> > +++ b/kernel/smp.c
>> > @@ -49,10 +49,13 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
>> >  				cpu_to_node(cpu)))
>> >  			return notifier_from_errno(-ENOMEM);
>> >  		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
>> > -				cpu_to_node(cpu)))
>> > +				cpu_to_node(cpu))) {
>> > +			free_cpumask_var(cfd->cpumask);
>> >  			return notifier_from_errno(-ENOMEM);
>> > +		}
>> >  		cfd->csd = alloc_percpu(struct call_single_data);
>> >  		if (!cfd->csd) {
>> > +			free_cpumask_var(cfd->cpumask_ipi);
>> >  			free_cpumask_var(cfd->cpumask);
>> >  			return notifier_from_errno(-ENOMEM);
>> >  		}
>> > -- 
>> > 1.7.7.6
> Acked-by: Wang YanQing <udknight@gmail.com>
> 
> 

Thanks  :-)

-- 
Chen Gang
