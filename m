Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab3AVWVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 17:21:45 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18241 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab3AVWVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 17:21:43 -0500
Date: Tue, 22 Jan 2013 17:20:56 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "Jan Beulich (JBeulich@suse.com)" <JBeulich@suse.com>
Subject: Re: [PATCH 1/1] X86: Handle Hyper-V vmbus interrupts as special
 hypervisor interrupts
Message-ID: <20130122222056.GC14503@phenom.dumpdata.com>
References: <1358469577-8794-1-git-send-email-kys@microsoft.com>
 <20130118131056.GA14550@pd.tnic>
 <794a590acf1a47408a87e95f095e6b1b@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <794a590acf1a47408a87e95f095e6b1b@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 03:27:33PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Borislav Petkov [mailto:bp@alien8.de]
> > Sent: Friday, January 18, 2013 8:11 AM
> > To: KY Srinivasan
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > jasowang@redhat.com; tglx@linutronix.de; H. Peter Anvin; Ingo Molnar
> > Subject: Re: [PATCH 1/1] X86: Handle Hyper-V vmbus interrupts as special
> > hypervisor interrupts
> > 
> > On Thu, Jan 17, 2013 at 04:39:37PM -0800, K. Y. Srinivasan wrote:
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > ---
> > >  arch/x86/include/asm/irq_vectors.h |    2 +
> > >  arch/x86/include/asm/mshyperv.h    |    4 +++
> > >  arch/x86/kernel/cpu/mshyperv.c     |   39
> > ++++++++++++++++++++++++++++++++++++
> > >  arch/x86/kernel/entry_32.S         |    7 ++++++
> > >  arch/x86/kernel/entry_64.S         |    5 ++++
> > >  5 files changed, 57 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/arch/x86/include/asm/irq_vectors.h
> > b/arch/x86/include/asm/irq_vectors.h
> > > index 1508e51..c2ff239 100644
> > > --- a/arch/x86/include/asm/irq_vectors.h
> > > +++ b/arch/x86/include/asm/irq_vectors.h
> > > @@ -112,6 +112,8 @@
> > >  /* Xen vector callback to receive events in a HVM domain */
> > >  #define XEN_HVM_EVTCHN_CALLBACK		0xf3
> > >
> > > +/* Hyper-V vector callback to receive vmbus interrupts*/
> > > +#define HYPER_V_CALLBACK_VECTOR		0xf2
> > 
> > Btw, could those hypervisor vectors be merged into one VIRT_INTR_VECTOR
> > and be shared between the hypervisors? I mean, you can't have a xen and
> > hyperv hypervisor running next to each other and fihgting over that
> > vector, right?
> 
> You are right; we could just have one vector for this. Let me wait for other comments and
> input from Xen maintainers before I make this change.
> 
> Regards,
> 

Looks OK to me.

> K. Y
> > 
> > --
> > Regards/Gruss,
> >     Boris.
> > 
> > Sent from a fat crate under my desk. Formatting is fine.
> > --
> > 
> 
