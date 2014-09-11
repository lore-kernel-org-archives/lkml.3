Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbaIKRKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:10:40 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:60754 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbaIKRKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:10:36 -0400
Date: Thu, 11 Sep 2014 19:10:33 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org,
        will.deacon@arm.com, a.motakis@virtualopensystems.com,
        a.rigo@virtualopensystems.com, john.liuli@huawei.com
Subject: Re: [RFC v2 8/9] KVM: KVM-VFIO: generic KVM_DEV_VFIO_DEVICE command
 and IRQ forwarding control
Message-ID: <20140911171033.GD5535@lvm>
References: <1409575968-5329-1-git-send-email-eric.auger@linaro.org>
 <1409575968-5329-9-git-send-email-eric.auger@linaro.org>
 <20140911031026.GI2784@lvm>
 <1410411949.2982.284.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410411949.2982.284.camel@ul30vt.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 11:05:49PM -0600, Alex Williamson wrote:
> On Thu, 2014-09-11 at 05:10 +0200, Christoffer Dall wrote:
> > On Mon, Sep 01, 2014 at 02:52:47PM +0200, Eric Auger wrote:

[...]

> > >  
> > > +#ifdef __KVM_HAVE_ARCH_KVM_VFIO_FORWARD
> > > +int kvm_arch_set_fwd_state(struct kvm_fwd_irq *pfwd,
> > 
> > what's the 'p' in pfwd?
> 
> p is for pointer?
> 

shouldn't the type declation spell out quite clearly to me that I'm
dealing with a pointer?

[...]

> > 
> > need some spaceing here, also, I would turn this around, first check if
> > the strcmp fails, and then error out, then do you next check etc., to
> > avoid so many nested statements.
> > 
> > > +	/* is a ref to this device already owned by the KVM-VFIO device? */
> > 
> > this comment is not particularly helpful in its current form, it would
> > be helpful if you specified that we're checking whether that particular
> > device/irq combo is already registered.
> > 
> > > +	*kvm_vdev = kvm_vfio_find_device(kv, vdev);
> > > +	if (*kvm_vdev) {
> > > +		if (kvm_vfio_find_irq(*kvm_vdev, fwd_irq->index)) {
> > > +			kvm_err("%s irq %d already forwarded\n",
> > > +				__func__, *hwirq);
> 
> Why didn't we do this first?
> 
huh?

-Christoffer
