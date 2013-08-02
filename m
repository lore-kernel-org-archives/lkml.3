Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab3HBDPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 23:15:55 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:42294 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab3HBDPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 23:15:53 -0400
Message-ID: <51FB25DF.5000203@linux.vnet.ibm.com>
Date: Fri, 02 Aug 2013 08:52:07 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>, mingo@redhat.com
CC: x86@kernel.org, tglx@linutronix.de, jeremy@goop.org,
        konrad.wilk@oracle.com, hpa@zytor.com, pbonzini@redhat.com,
        linux-doc@vger.kernel.org, habanero@linux.vnet.ibm.com,
        xen-devel@lists.xensource.com, peterz@infradead.org,
        mtosatti@redhat.com, stefano.stabellini@eu.citrix.com,
        andi@firstfloor.org, attilio.rao@citrix.com, ouyang@cs.pitt.edu,
        gregkh@suse.de, agraf@suse.de, chegu_vinod@hp.com,
        torvalds@linux-foundation.org, avi.kivity@gmail.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, riel@redhat.com,
        drjones@redhat.com, virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V11 15/18] kvm : Paravirtual ticketlocks support for
 linux guests running on KVM hypervisor
References: <20130724103907.GF16400@redhat.com> <51EFC1D4.9060800@linux.vnet.ibm.com> <20130724120647.GG16400@redhat.com> <51EFCA42.5020009@linux.vnet.ibm.com> <51F0ED31.3040200@linux.vnet.ibm.com> <20130725091509.GA22735@redhat.com> <51F0F202.5090001@linux.vnet.ibm.com> <51F7ED20.80202@linux.vnet.ibm.com> <20130731062440.GK28372@redhat.com> <51FA1087.9080908@linux.vnet.ibm.com> <20130801074529.GO7484@redhat.com> <51FA2486.20507@linux.vnet.ibm.com>
In-Reply-To: <51FA2486.20507@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080203-9574-0000-0000-000008FFB9A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 02:34 PM, Raghavendra K T wrote:
> On 08/01/2013 01:15 PM, Gleb Natapov wrote:
>>> Shall I consider this as an ack for kvm part?
>>>
>> For everything except 18/18. For that I still want to see numbers. But
>> 18/18 is pretty independent from the reset of the series so it should
>> not stop the reset from going in.
>
> Yes. agreed.
> I am going to evaluate patch 18 separately and come with results for
> that. Now we can consider only 1-17 patches.
>

Gleb,

32 core machine with HT off 32 vcpu guests.
base = 3.11-rc + patch 1 -17 pvspinlock_v11
patched = base + patch 18

+-----------+-----------+-----------+------------+-----------+
                   dbench  (Throughput in MB/sec higher is better)
+-----------+-----------+-----------+------------+-----------+
       base      stdev       patched    stdev       %improvement
+-----------+-----------+-----------+------------+-----------+
1x 14584.3800   146.9074   14705.1000   163.1060     0.82773
2x  1713.7300    32.8750    1717.3200    45.5979     0.20948
3x   967.8212    42.0257     971.8855    18.8532     0.41994
4x   685.2764    25.7150     694.5881     8.3907     1.35882
+-----------+-----------+-----------+------------+-----------+

I saw -0.78% - .84% changes in ebizzy and 1-2% improvement in
hackbench.

