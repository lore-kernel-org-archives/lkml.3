Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbbAMJBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:01:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:43333 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbbAMJBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:01:53 -0500
Date: Tue, 13 Jan 2015 10:01:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sander Eikelenboom <linux@eikelenboom.it>
cc: David Vrabel <david.vrabel@citrix.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Grant Likely <grant.likely@linaro.org>,
        Yinghai Lu <yinghai@kernel.org>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH v2] [Bugfix] x86/apic: Fix xen IRQ allocation
 failure caused by commit b81975eade8c
In-Reply-To: <1686507423.20150113001814@eikelenboom.it>
Message-ID: <alpine.DEB.2.11.1501131000410.17382@nanos>
References: <1767175032.20150110201202@eikelenboom.it> <1421069966-19729-1-git-send-email-jiang.liu@linux.intel.com> <54B3E1AC.6080902@citrix.com> <1686507423.20150113001814@eikelenboom.it>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015, Sander Eikelenboom wrote:

> 
> Monday, January 12, 2015, 4:01:00 PM, you wrote:
> 
> > On 12/01/15 13:39, Jiang Liu wrote:
> >> Commit b81975eade8c ("x86, irq: Clean up irqdomain transition code")
> >> breaks xen IRQ allocation because xen_smp_prepare_cpus() doesn't invoke
> >> setup_IO_APIC(), so no irqdomains created for IOAPICs and
> >> mp_map_pin_to_irq() fails at the very beginning.
> >> 
> >> Enhance xen_smp_prepare_cpus() to call setup_IO_APIC() to initialize
> >> irqdomain for IOAPICs.
> 
> > Having Xen call setup_IO_APIC() to initialize the irq domains then having to
> > add special cases to it is just wrong.
> 
> > The bits of init deferred by mp_register_apic() are also deferred to
> > two different places which looks odd.
> 
> > What about something like the following (untested) patch?
> 
> Hi David / Gerry,
> 
> David's patch (after fixing a few compile issues) fixes the problem.
> 
> The power button now works for me on:
> - intel baremetal
> - intel xen
> - amd baremetal (no issues with the override anymore)
> - amd xen       (no freeze issues anymore)

Can someone please send a proper patch with changelog?

Thanks,

	tglx
