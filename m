Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab3DAMlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 08:41:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26141 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab3DAMlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 08:41:22 -0400
Date: Mon, 1 Apr 2013 08:41:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Feng Jin <joe.jin@oracle.com>, Tamon Shiose <tamon.shiose@oracle.com>
Subject: Re: [PATCH] xen: Don't call arch_trigger_all_cpu_backtrace in
 dom0(pvm)
Message-ID: <20130401124118.GB11995@phenom.dumpdata.com>
References: <5155413E.6090002@oracle.com>
 <20130329134640.GG31356@phenom.dumpdata.com>
 <51591A8A.1060904@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51591A8A.1060904@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 01:26:34PM +0800, Zhenzhong Duan wrote:
> 
> On 2013-03-29 21:46, Konrad Rzeszutek Wilk wrote:
> >On Fri, Mar 29, 2013 at 03:22:38PM +0800, Zhenzhong Duan wrote:
> >>nmi isn't supported in dom0, fallback to general all cpu backtrace code.
> >>
> >>Without fix, on xapic system, sysrq+l, no backtrace is showed.
> >>On x2apic enabled system, got NULL pointer dereference as below.
> >Why would the x2APIC or xAPIC make a difference here? The Linux dom0
> >is not fiddling with the APIC - that is the hypervisor job.
> In x2apic enabled system, dom0 kernel set apic pointer to
> apic_x2apic_cluster or apic_x2apic_phys.


> When sending nmi, apic->send_IPI_all copy cpumask which isn't initialized.
> For xapic system, apic->send_IPI_all=xen_send_IPI_all apic, this
> func does nothing for nmi, so no backtrace.
> >Can you explain to me why x2apic_send_IPI_mask is even set? Wouldn't
> >the Xen version of send_IPI be present? (See xen_smp_ops)
> It's overwrited by x2apic initialization.

That explanation needs to be part of the git commit.
> The problem is even without overwrite, like xapic system,
> xen_send_IPI_all doesn't work for nmi vector.

Can you tweak the x2apic_mode = 0 in enligthen.c for example?
Or clear the X86_FEATURE_X2APIC in the enlighten.c ? (Similar
to how the other features are cleared) Wouldn't
that stop x2apic_enabled from detecting x2APIC?


Sure.
> zduan
