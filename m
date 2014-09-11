Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbaIKRIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:08:18 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:53401 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbaIKRIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:08:15 -0400
Date: Thu, 11 Sep 2014 19:08:13 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org,
        will.deacon@arm.com, a.motakis@virtualopensystems.com,
        a.rigo@virtualopensystems.com, john.liuli@huawei.com
Subject: Re: [RFC v2 5/9] KVM: KVM-VFIO: update user API to program forwarded
 IRQ
Message-ID: <20140911170813.GC5535@lvm>
References: <1409575968-5329-1-git-send-email-eric.auger@linaro.org>
 <1409575968-5329-6-git-send-email-eric.auger@linaro.org>
 <20140911031005.GF2784@lvm>
 <54116204.6000403@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54116204.6000403@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 10:49:08AM +0200, Eric Auger wrote:
> On 09/11/2014 05:10 AM, Christoffer Dall wrote:
> > On Mon, Sep 01, 2014 at 02:52:44PM +0200, Eric Auger wrote:

[...]

> >> +
> >> +It is up to the caller of this API to make sure the IRQ is not
> >> +outstanding when the FORWARD/UNFORWARD is called. This could lead to
> > 
> > outstanding? can you be specific?
> active? and I should add *physical* IRQ
> > 
> > don't refer to FOWARD/UNFORWARD, either refer to these attributes by
> > their full name or use a clear reference in proper English.
> ok
> > 
> >> +some inconsistency on who is going to complete the IRQ.
> > 
> > This sounds like the whole thing is fragile and if userspace doesn't do
> > things right, IRQ handling of a piece of hardware is going to be
> > inconsistent?  Is this the case?  If so, we need some stronger
> > semantics.  If not, this should be rephrased.
> Actually the KVM-VFIO device rejects any attempt to change the
> forwarding mode if the physical IRQ is active. So I hope this is robust
> and will change the explanation.
> 
ok, so what is the proposed method if the IRQ is indeed active, should
user space loop around and try or can user space make sure somehow?  If
user space should simply retry for a number of times, we should probalby
return a proper error code for this case -EINTR?

-Christoffer
