Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab3LWMc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 07:32:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232Ab3LWMcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 07:32:55 -0500
Message-ID: <52B82D68.4030502@redhat.com>
Date: Mon, 23 Dec 2013 07:32:40 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Michel Lespinasse <walken@google.com>,
        Andi Kleen <ak@linux.intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, janet.morgan@Intel.com,
        tony.luck@Intel.com, ruiv.wang@gmail.com
Subject: Re: [PATCH] x86: Add check for number of available vectors before
 CPU down [v3]
References: <1387554609-9823-1-git-send-email-prarit@redhat.com> <20131223071240.GA18274@gchen.bj.intel.com>
In-Reply-To: <20131223071240.GA18274@gchen.bj.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/23/2013 02:12 AM, Chen, Gong wrote:
> On Fri, Dec 20, 2013 at 10:50:09AM -0500, Prarit Bhargava wrote:
>> +int check_vectors(void)
>> +{
>> +	int irq, cpu;
>> +	unsigned int vector, this_count, count;
>> +	struct irq_desc *desc;
>> +	struct irq_data *data;
>> +	struct cpumask *affinity;
>> +
>> +	this_count = 0;
>> +	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
>> +		irq = __this_cpu_read(vector_irq[vector]);
>> +		if (irq >= 0) {
>> +			desc = irq_to_desc(irq);
>> +			data = irq_desc_get_irq_data(desc);
>> +			affinity = data->affinity;
>> +			if (irq_has_action(irq) || !irqd_is_per_cpu(data) ||
> This line looks weird. Why counter will be increased once the irq has
> action? Do you mean
> 
> if (irq_has_action(irq) && !irqd_is_per_cpu(data) &&
>     !cpumask_subset(affinity, cpu_online_mask))
> 
> 

Yes, you're absolutely right.  I mixed up the and and or's on this line of code.
 I will send out a patch against tip shortly.

P.
