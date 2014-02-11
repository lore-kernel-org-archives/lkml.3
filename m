Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaBKHGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 02:06:32 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:57055 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbaBKHG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 02:06:29 -0500
Message-ID: <52F9CAAE.4020308@linux.vnet.ibm.com>
Date: Tue, 11 Feb 2014 12:31:02 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: ego@linux.vnet.ibm.com
CC: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, Robert Richter <rric@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH 26/51] x86, oprofile, nmi: Fix CPU hotplug callback registration
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205220921.19080.94715.stgit@srivatsabhat.in.ibm.com> <20140210190737.GD3416@in.ibm.com> <20140210192747.GE3416@in.ibm.com>
In-Reply-To: <20140210192747.GE3416@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021107-1618-0000-0000-0000056C1B85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 12:57 AM, Gautham R Shenoy wrote:
> On Tue, Feb 11, 2014 at 12:37:37AM +0530, Gautham R Shenoy wrote:
>> Hi,
>>
>> On Thu, Feb 06, 2014 at 03:39:22AM +0530, Srivatsa S. Bhat wrote:
>>> Fix the oprofile code in x86 by using this latter form of callback
>>> registration. But retain the calls to get/put_online_cpus(), since they
>>> also protect the variables 'nmi_enabled' and 'ctr_running'.
>>
>> get/put_online_cpus() protect us against cpu_hotplug_begin/end(). The
>> latter is always nested inside cpu_maps_update_begin/end(), which we
>> are already using here. 
>>
>> So what additional protection are we getting by retaining
>> get/put_online_cpus() ?
> 
> Probably you mean to say that there are other places which access
> 'nmi_enabled' and 'ctr_running' with the cpu-hotplug protection
> provided only by get/put_online_cpus() and you are retaining the calls
> in this patch to be consistent with those other places.

Yep, exactly!

> If so, could
> you reword the changelog to reflect this instead of saying "they also
> protect the variables ..." ?
>

Ok, will do! Thanks a lot!
 
Regards,
Srivatsa S. Bhat

