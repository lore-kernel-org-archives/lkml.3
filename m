Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab3EVGQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 02:16:33 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:36881 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab3EVGQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 02:16:32 -0400
Message-ID: <519C62B3.7070500@linux.vnet.ibm.com>
Date: Wed, 22 May 2013 14:16:19 +0800
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Alexander Gordeev <agordeev@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [PATCH 0/3] Enable multiple MSI feature in pSeries
References: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com> <20130521144548.GB21632@dhcp-26-207.brq.redhat.com> <1369181713.6387.79.camel@pasglop>
In-Reply-To: <1369181713.6387.79.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052206-2674-0000-0000-00000910BAD6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/5/22 8:15, Benjamin Herrenschmidt 写道:
> On Tue, 2013-05-21 at 16:45 +0200, Alexander Gordeev wrote:
>> On Tue, Jan 15, 2013 at 03:38:53PM +0800, Mike Qiu wrote:
>>> The test results is shown by 'cat /proc/interrups':
>>>            CPU0       CPU1       CPU2       CPU3
>>> 16:     240458     261601     226310     200425      XICS Level     IPI
>>> 17:          0          0          0          0      XICS Level     RAS_EPOW
>>> 18:         10          0          3          2      XICS Level     hvc_console
>>> 19:     122182      28481      28527      28864      XICS Level     ibmvscsi
>>> 20:        506    7388226        108        118      XICS Level     eth0
>>> 21:          6          5          5          5      XICS Level     host1-0
>>> 22:        817        814        816        813      XICS Level     host1-1
>> Hi Mike,
>>
>> I am curious if pSeries firmware allows changing affinity masks independently
>> for multiple MSIs? I.e. in your example, would it be possible to assign IRQ21
>> and IRQ22 to different CPUs?
> Yes. Each interrupt has its own affinity, whether it's an MSI or not,
> the affinity is not driven by the address.
>
> Cheers,
> Ben.
Hi Ben,

May this patch be accepted? if so I will send out the 3.9 version.

As Michael Ellerman says, he want to see the performance data,

but this depends on the driver.

It is something like MSI, and the driver can use more than 1 MSI.

That is to say, the driver has more interrupt resource to use,
but whether the driver is full use of the resource, is out of
  this patch's control.

I test this patch use ipr driver, which add multiple MSI
  support by others. and it can work.

Thanks
Mike
>> Thanks!
>>
>>> LOC:     398077     316725     231882     203049   Local timer interrupts
>>> SPU:       1659        919        961        903   Spurious interrupts
>>> CNT:          0          0          0          0   Performance
>>> monitoring interrupts
>>> MCE:          0          0          0          0   Machine check exceptions
>
>

