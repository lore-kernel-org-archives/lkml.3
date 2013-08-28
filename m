Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab3H1B1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 21:27:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:44615 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab3H1B1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 21:27:04 -0400
Message-ID: <1377653191.3819.146.camel@pasglop>
Subject: Re: [PATCH v8] KVM: PPC: reserve a capability and ioctl numbers for
 realmode VFIO
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Gleb Natapov <gleb@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        Alexander Graf <agraf@suse.de>, linux-kernel@vger.kernel.org
Date: Wed, 28 Aug 2013 11:26:31 +1000
In-Reply-To: <521D4977.7060803@ozlabs.ru>
References: <1376552966-8529-1-git-send-email-aik@ozlabs.ru>
	 <20130827075600.GE22899@redhat.com> <521C666A.3020508@ozlabs.ru>
	 <20130827105832.GH22899@redhat.com> <521D4977.7060803@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-28 at 10:51 +1000, Alexey Kardashevskiy wrote:
> The ioctl I made up is basically a copy of KVM_CREATE_SPAPR_TCE which does
> the same thing for emulated devices and it is there for quite a while but
> it is not really extensible. And these two ioctls share some bits of code.
> Now we will have 2 pieces of code which do almost the same thing but in a
> different way. Kinda sucks :(

Right. Thus the question, Gleb, we can either:

 - Keep Alexey patch as-is allowing us to *finally* merge that stuff
that's been around for monthes

 - Convert *both* existing TCE objects to the new 
KVM_CREATE_DEVICE, and have some backward compat code for the old one.

I don't think it makes sense to have the "emulated TCE" and "IOMMU TCE"
objects use a fundamentally different API and infrastructure.

> >> So my stuff is not going to upstream again. Heh. Ok. I'll implement it.
> >>
> > Thanks! Should I keep KVM_CAP_SPAPR_MULTITCE capability patch or can I
> > drop it for now?
> 
> Please keep it, it is unrelated to the IOMMU-VFIO thing.


