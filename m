Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab3EVAQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 20:16:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:45523 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab3EVAQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 20:16:11 -0400
Message-ID: <1369181713.6387.79.camel@pasglop>
Subject: Re: [PATCH 0/3] Enable multiple MSI feature in pSeries
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Mike Qiu <qiudayu@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Date: Wed, 22 May 2013 10:15:13 +1000
In-Reply-To: <20130521144548.GB21632@dhcp-26-207.brq.redhat.com>
References: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com>
	 <20130521144548.GB21632@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-21 at 16:45 +0200, Alexander Gordeev wrote:
> On Tue, Jan 15, 2013 at 03:38:53PM +0800, Mike Qiu wrote:
> > The test results is shown by 'cat /proc/interrups':
> >           CPU0       CPU1       CPU2       CPU3       
> > 16:     240458     261601     226310     200425      XICS Level     IPI
> > 17:          0          0          0          0      XICS Level     RAS_EPOW
> > 18:         10          0          3          2      XICS Level     hvc_console
> > 19:     122182      28481      28527      28864      XICS Level     ibmvscsi
> > 20:        506    7388226        108        118      XICS Level     eth0
> > 21:          6          5          5          5      XICS Level     host1-0
> > 22:        817        814        816        813      XICS Level     host1-1
> 
> Hi Mike,
> 
> I am curious if pSeries firmware allows changing affinity masks independently
> for multiple MSIs? I.e. in your example, would it be possible to assign IRQ21
> and IRQ22 to different CPUs?

Yes. Each interrupt has its own affinity, whether it's an MSI or not,
the affinity is not driven by the address.

Cheers,
Ben.

> Thanks!
> 
> > LOC:     398077     316725     231882     203049   Local timer interrupts
> > SPU:       1659        919        961        903   Spurious interrupts
> > CNT:          0          0          0          0   Performance
> > monitoring interrupts
> > MCE:          0          0          0          0   Machine check exceptions
> 


