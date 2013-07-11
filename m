Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab3GKMuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 08:50:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754538Ab3GKMuK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 08:50:10 -0400
Subject: Re: [PATCH 8/8] KVM: PPC: Add hugepage support for IOMMU in-kernel handling
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1373546233.19894.85.camel@pasglop>
Date: Thu, 11 Jul 2013 14:50:04 +0200
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B526C260-1ADB-4B9F-B80A-46E5A9E53FF6@suse.de>
References: <1373123227-22969-1-git-send-email-aik@ozlabs.ru> <1373123227-22969-9-git-send-email-aik@ozlabs.ru> <51DC4923.5010501@suse.de> <51DE7377.1060503@ozlabs.ru> <902F79B9-BB81-40A0-865D-94E7108DAC5E@suse.de> <1373546233.19894.85.camel@pasglop>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11.07.2013, at 14:37, Benjamin Herrenschmidt wrote:

> On Thu, 2013-07-11 at 11:52 +0200, Alexander Graf wrote:
>>> Where exactly (it is rather SPAPR_TCE_IOMMU but does not really
>> matter)?
>>> Select it on KVM_BOOK3S_64? CONFIG_KVM_BOOK3S_64_HV?
>>> CONFIG_KVM_BOOK3S_64_PR? PPC_BOOK3S_64?
>> 
>> I'd say the most logical choice would be to check the Makefile and see
>> when it gets compiled. For those cases we want it enabled.
> 
> What *what* gets compiled ? You know our Makefile, it's crap :-)
> 
> We enable built-in things when CONFIG_KVM=m (which means you cannot take
> a kernel build with CONFIG_KVM not set, enable CONFIG_KVM=m, and just
> build the module, it won't work).
> 
> We could use KVM_BOOK3S_64 maybe ?

If either a =m or a =y option selects a =y option, it gets selected regardless, no? So it shouldn't really matter where we attach it FWIW.

> 
>>> I am trying to imagine a configuration where we really do not want
>>> IOMMU_API. Ben mentioned PPC32 and embedded PPC64 and that's it so
>> any of
>>> BOOK3S (KVM_BOOK3S_64 is the best) should be fine, no?
>> 
>> book3s_32 doesn't want this, but any book3s_64 implementation could
>> potentially use it, yes. That's pretty much what the Makefile tells
>> you too :).
> 
> Not really no. But that would do. You could have give a more useful
> answer in the first place though rather than stringing him along.

Sorry, I figured it was obvious.


Alex

