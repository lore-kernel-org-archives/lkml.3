Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab3H1GiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:38:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709Ab3H1GiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:38:16 -0400
Date: Wed, 28 Aug 2013 09:38:03 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        Alexander Graf <agraf@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8] KVM: PPC: reserve a capability and ioctl numbers for
 realmode VFIO
Message-ID: <20130828063802.GK22899@redhat.com>
References: <1376552966-8529-1-git-send-email-aik@ozlabs.ru>
 <20130827075600.GE22899@redhat.com>
 <521C666A.3020508@ozlabs.ru>
 <20130827105832.GH22899@redhat.com>
 <521D4977.7060803@ozlabs.ru>
 <1377653191.3819.146.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377653191.3819.146.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 11:26:31AM +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2013-08-28 at 10:51 +1000, Alexey Kardashevskiy wrote:
> > The ioctl I made up is basically a copy of KVM_CREATE_SPAPR_TCE which does
> > the same thing for emulated devices and it is there for quite a while but
> > it is not really extensible. And these two ioctls share some bits of code.
> > Now we will have 2 pieces of code which do almost the same thing but in a
> > different way. Kinda sucks :(
> 
> Right. Thus the question, Gleb, we can either:
> 
>  - Keep Alexey patch as-is allowing us to *finally* merge that stuff
> that's been around for monthes
> 
>  - Convert *both* existing TCE objects to the new 
> KVM_CREATE_DEVICE, and have some backward compat code for the old one.
> 
> I don't think it makes sense to have the "emulated TCE" and "IOMMU TCE"
> objects use a fundamentally different API and infrastructure.
> 
As a general rule we are not going to mandate converting old devices to
new API, but if it make sense to do here I would much prefer that over
adding another special ioctl

> > >> So my stuff is not going to upstream again. Heh. Ok. I'll implement it.
> > >>
> > > Thanks! Should I keep KVM_CAP_SPAPR_MULTITCE capability patch or can I
> > > drop it for now?
> > 
> > Please keep it, it is unrelated to the IOMMU-VFIO thing.
> 

--
			Gleb.
