Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbaGDKMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:12:55 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:44761 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaGDKMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:12:54 -0400
Date: Fri, 4 Jul 2014 03:13:02 -0700
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: KVM: export demux regids as KVM_REG_ARM64
Message-ID: <20140704101302.GD20451@cbox>
References: <1404229993-14522-1-git-send-email-alex.bennee@linaro.org>
 <53B2DA42.40604@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53B2DA42.40604@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 04:56:50PM +0100, Marc Zyngier wrote:
> On 01/07/14 16:53, Alex Bennée wrote:
> > I suspect this is a -ECUTPASTE fault from the initial implementation. If
> > we don't declare the register ID to be KVM_REG_ARM64 the KVM_GET_ONE_REG
> > implementation kvm_arm_get_reg() returns -EINVAL and hilarity ensues.
> > 
> > The kvm/api.txt document describes all arm64 registers as starting with
> > 0x60xx... (i.e KVM_REG_ARM64).
> > 
> > Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> > Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 0324458..5ee99e4 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -962,7 +962,7 @@ static unsigned int num_demux_regs(void)
> >  
> >  static int write_demux_regids(u64 __user *uindices)
> >  {
> > -	u64 val = KVM_REG_ARM | KVM_REG_SIZE_U32 | KVM_REG_ARM_DEMUX;
> > +	u64 val = KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_DEMUX;
> >  	unsigned int i;
> >  
> >  	val |= KVM_REG_ARM_DEMUX_ID_CCSIDR;
> > 
> 
> -EBROWNPAPERBAG.
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> 
Applied to kvmarm/master,

thanks.
