Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbaEVM3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:29:23 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:51077 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbaEVM3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:29:18 -0400
Date: Thu, 22 May 2014 14:29:09 +0200
From: Michael Mueller <mimu@linux.vnet.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexander Graf <agraf@suse.de>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        qemu-devel@nongnu.org, linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Jason J. Herne" <jjherne@linux.vnet.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Andreas Faerber <afaerber@suse.de>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v1 RFC 6/6] KVM: s390: add cpu model
 support
Message-ID: <20140522142909.13fcd583@bee>
In-Reply-To: <537DBB12.6070108@redhat.com>
References: <1399993114-15333-1-git-send-email-mimu@linux.vnet.ibm.com>
	<1399993114-15333-7-git-send-email-mimu@linux.vnet.ibm.com>
	<5375FFB8.90504@suse.de>
	<20140516173907.3b1c4efa@bee>
	<53767590.2090605@suse.de>
	<20140519125339.09840b9e@bee>
	<5379EF78.9040209@suse.de>
	<20140519161811.5a17bc66@bee>
	<537A19F8.4060209@suse.de>
	<20140519190318.6f92c1bd@bee>
	<537A6608.8000608@suse.de>
	<20140520120218.38eb7181@bee>
	<537B2A0F.1030706@suse.de>
	<20140521145652.197bff21@bee>
	<537CA89B.6050803@suse.de>
	<20140522102316.653f34ba@bee>
	<537DBB12.6070108@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052212-2966-0000-0000-00000B5E5E1E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014 10:53:38 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Il 22/05/2014 10:23, Michael Mueller ha scritto:
> > On Wed, 21 May 2014 15:22:35 +0200
> > Alexander Graf <agraf@suse.de> wrote:
> >
> > I have seen the slides from Eduardo which he presented during this years
> > DevConf in Brno and made my comments according the s390x implementation
> > on that. Is you will see, this is mostly overlapping except for the model
> > definition authority that I clearly see on qemu's side.
> >
> > See pdf attachment.
> 
> More comments:
> 
> - "Only one machine type in s390 case which is -machine s390-virtio-ccw"
> 
> This probably should change sooner or later, as soon as the 
> implementation becomes stable enough.  Versioning is necessary for live 
> migration across different QEMU version.  Perhaps start versioning in 
> 2.2, i.e. start making s390-virtio-ccw-2.1 an alias for s390-virtio-ccw now?

Absolutely right, we did not do it yet.

> 
> Note that new virtio device features can appear at any time outside the 
> s390 code, and will take part in versioning as well.

These changes are then as well included in the machine version I guess. 

> 
> - "No enforce option"
> 
> Strongly suggest making enforce the only possible behavior.

Right that's the plan.

> 
> - "Not in the s390x case, because the KVM facility mask limits the cpu 
> model specific facilities"
> 
> What if the KVM facility mask changes?  For x86, nowadays new CPUID bits 
> are only introduced in KVM when a new processors comes out.  But if we 
> introduced an older CPUID bit, it would be a huge complication for 
> backwards compatibility.  Is it different for s390?
> 

I'm thinking about this one currently. The ABI itself will not change
because all facilities of the architecture will be defined in QEMU for the
respective CPU model even though some of them are masked out upon request
by KVM, but the mask is part of the interface itself and can be applied by
QEMU already.  

Michael 

> Paolo
> 

