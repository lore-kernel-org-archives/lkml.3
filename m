Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab3CUTdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:33:21 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:58413
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750979Ab3CUTdT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:33:19 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
Date: Thu, 21 Mar 2013 14:33:13 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH] KVM: allow host header to be included even for
 !CONFIG_KVM
To: Gleb Natapov <gleb@redhat.com>
CC: Kevin Hilman <khilman@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        <linaro-kernel@lists.linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "open list:KERNEL VIRTUAL MA..." <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1363306426-27209-1-git-send-email-khilman@linaro.org>
	<1363823921.25034.35@snotra> <20130321072955.GO3889@redhat.com>
	<87ppyshlq5.fsf@linaro.org> <1363891354.31522.17@snotra>
	<20130321191600.GG9382@redhat.com>
In-Reply-To: <20130321191600.GG9382@redhat.com> (from gleb@redhat.com on Thu
	Mar 21 14:16:00 2013)
X-Mailer: Balsa 2.4.11
Message-ID: <1363894393.31522.20@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 02:16:00 PM, Gleb Natapov wrote:
> On Thu, Mar 21, 2013 at 01:42:34PM -0500, Scott Wood wrote:
> > On 03/21/2013 09:27:14 AM, Kevin Hilman wrote:
> > >Gleb Natapov <gleb@redhat.com> writes:
> > >
> > >> On Wed, Mar 20, 2013 at 06:58:41PM -0500, Scott Wood wrote:
> > >>> Why can't the entirety kvm_host.h be included regardless of
> > >>> CONFIG_KVM, just like most other feature-specific headers?  Why
> > >>> can't the if/else just go around the functions that you want to
> > >stub
> > >>> out for non-KVM builds?
> > >>>
> > >> Kevin,
> > >>
> > >>  What compilation failure this patch fixes? I presume something  
> ARM
> > >> related.
> > >
> > >Not specficially ARM related, but more context tracking related  
> since
> > >kernel/context_tracking.c pulls in kvm_host.h, which attempts to
> > >pull in
> > ><asm/kvm*.h> which may not exist on some platforms.
> > >
> > >At least for ARM, KVM support was added in v3.9 so this patch can
> > >probably be dropped since the non-KVM builds on ARM now work.  But  
> any
> > >platform without the <asm/kvm*.h> will still be broken when trying  
> to
> > >build the context tracker.
> >
> > Maybe other platforms should get empty asm/kvm*.h files.  Is there
> > anything from those files that the linux/kvm*.h headers need to
> > build?
> >
> arch things. kvm_vcpu_arch, kvm_arch_memory_slot, kvm_arch etc.

Could define them as empty structs.

-Scott
