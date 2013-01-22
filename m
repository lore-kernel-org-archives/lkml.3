Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab3AVXWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:22:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38034 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab3AVXWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:22:21 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20130122222056.GC14503@phenom.dumpdata.com>
References: <1358469577-8794-1-git-send-email-kys@microsoft.com> <20130118131056.GA14550@pd.tnic> <794a590acf1a47408a87e95f095e6b1b@SN2PR03MB061.namprd03.prod.outlook.com> <20130122222056.GC14503@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] X86: Handle Hyper-V vmbus interrupts as special hypervisor interrupts
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 22 Jan 2013 17:19:37 -0600
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KY Srinivasan <kys@microsoft.com>
CC: Borislav Petkov <bp@alien8.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "jeremy@goop.org" <jeremy@goop.org>,
        "Jan Beulich (JBeulich@suse.com)" <JBeulich@suse.com>
Message-ID: <2bd8c994-3e70-413b-85de-caec46428b1e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, how about we rename this the hypervisor vector...

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

>On Fri, Jan 18, 2013 at 03:27:33PM +0000, KY Srinivasan wrote:
>> 
>> 
>> > -----Original Message-----
>> > From: Borislav Petkov [mailto:bp@alien8.de]
>> > Sent: Friday, January 18, 2013 8:11 AM
>> > To: KY Srinivasan
>> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
>> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
>> > jasowang@redhat.com; tglx@linutronix.de; H. Peter Anvin; Ingo
>Molnar
>> > Subject: Re: [PATCH 1/1] X86: Handle Hyper-V vmbus interrupts as
>special
>> > hypervisor interrupts
>> > 
>> > On Thu, Jan 17, 2013 at 04:39:37PM -0800, K. Y. Srinivasan wrote:
>> > >
>> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
>> > > ---
>> > >  arch/x86/include/asm/irq_vectors.h |    2 +
>> > >  arch/x86/include/asm/mshyperv.h    |    4 +++
>> > >  arch/x86/kernel/cpu/mshyperv.c     |   39
>> > ++++++++++++++++++++++++++++++++++++
>> > >  arch/x86/kernel/entry_32.S         |    7 ++++++
>> > >  arch/x86/kernel/entry_64.S         |    5 ++++
>> > >  5 files changed, 57 insertions(+), 0 deletions(-)
>> > >
>> > > diff --git a/arch/x86/include/asm/irq_vectors.h
>> > b/arch/x86/include/asm/irq_vectors.h
>> > > index 1508e51..c2ff239 100644
>> > > --- a/arch/x86/include/asm/irq_vectors.h
>> > > +++ b/arch/x86/include/asm/irq_vectors.h
>> > > @@ -112,6 +112,8 @@
>> > >  /* Xen vector callback to receive events in a HVM domain */
>> > >  #define XEN_HVM_EVTCHN_CALLBACK		0xf3
>> > >
>> > > +/* Hyper-V vector callback to receive vmbus interrupts*/
>> > > +#define HYPER_V_CALLBACK_VECTOR		0xf2
>> > 
>> > Btw, could those hypervisor vectors be merged into one
>VIRT_INTR_VECTOR
>> > and be shared between the hypervisors? I mean, you can't have a xen
>and
>> > hyperv hypervisor running next to each other and fihgting over that
>> > vector, right?
>> 
>> You are right; we could just have one vector for this. Let me wait
>for other comments and
>> input from Xen maintainers before I make this change.
>> 
>> Regards,
>> 
>
>Looks OK to me.
>
>> K. Y
>> > 
>> > --
>> > Regards/Gruss,
>> >     Boris.
>> > 
>> > Sent from a fat crate under my desk. Formatting is fine.
>> > --
>> > 
>> 

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
