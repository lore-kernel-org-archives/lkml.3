Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423270Ab3FUPa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 11:30:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41601 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161367Ab3FUPa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:30:26 -0400
Message-ID: <51C4717D.4090002@infradead.org>
Date: Fri, 21 Jun 2013 08:30:05 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Marciniszyn <infinipath@intel.com>, linux-rdma@vger.kernel.org
Subject: Re: linux-next: Tree for Jun 21 (infiniband: qib)
References: <20130621181721.11783d80583444868725b62c@canb.auug.org.au>
In-Reply-To: <20130621181721.11783d80583444868725b62c@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/13 01:17, Stephen Rothwell wrote:
> Hi all,
> 
> Happy solstice!
> 
> Changes since 20130620:
> 


on x86_64:

when CONFIG_SMP is not enabled:

(from qib.h:)

#ifdef CONFIG_INFINIBAND_QIB_DCA
struct qib_irq_notify {
	int rcv;
	void *arg;
	struct irq_affinity_notify notify;
};
#endif

struct irq_affinity_notify is only defined for CONFIG_SMP or GENERIC_HARDIRQS.
Build error happens when one of those is not enabled.


In file included from drivers/infiniband/hw/qib/qib_cq.c:41:0:
drivers/infiniband/hw/qib/qib.h:447:29: error: field 'notify' has incomplete type
make[4]: *** [drivers/infiniband/hw/qib/qib_cq.o] Error 1




-- 
~Randy
