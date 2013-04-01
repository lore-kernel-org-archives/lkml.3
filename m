Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab3DAF0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 01:26:12 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34836 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab3DAF0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 01:26:10 -0400
Message-ID: <51591A8A.1060904@oracle.com>
Date: Mon, 01 Apr 2013 13:26:34 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Feng Jin <joe.jin@oracle.com>, Tamon Shiose <tamon.shiose@oracle.com>
Subject: Re: [PATCH] xen: Don't call arch_trigger_all_cpu_backtrace in dom0(pvm)
References: <5155413E.6090002@oracle.com> <20130329134640.GG31356@phenom.dumpdata.com>
In-Reply-To: <20130329134640.GG31356@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013-03-29 21:46, Konrad Rzeszutek Wilk wrote:
> On Fri, Mar 29, 2013 at 03:22:38PM +0800, Zhenzhong Duan wrote:
>> nmi isn't supported in dom0, fallback to general all cpu backtrace code.
>>
>> Without fix, on xapic system, sysrq+l, no backtrace is showed.
>> On x2apic enabled system, got NULL pointer dereference as below.
> Why would the x2APIC or xAPIC make a difference here? The Linux dom0
> is not fiddling with the APIC - that is the hypervisor job.
In x2apic enabled system, dom0 kernel set apic pointer to 
apic_x2apic_cluster or apic_x2apic_phys.
When sending nmi, apic->send_IPI_all copy cpumask which isn't initialized.
For xapic system, apic->send_IPI_all=xen_send_IPI_all apic, this func 
does nothing for nmi, so no backtrace.
> Can you explain to me why x2apic_send_IPI_mask is even set? Wouldn't
> the Xen version of send_IPI be present? (See xen_smp_ops)
It's overwrited by x2apic initialization.
The problem is even without overwrite, like xapic system, 
xen_send_IPI_all doesn't work for nmi vector.
zduan
