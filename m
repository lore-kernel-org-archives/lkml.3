Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab3GJKun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 06:50:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974Ab3GJKum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 06:50:42 -0400
Date: Wed, 10 Jul 2013 13:48:43 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Alexander Graf <agraf@suse.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] PF: Provide additional direct page notification
Message-ID: <20130710104843.GS24941@redhat.com>
References: <1373378207-10451-1-git-send-email-dingel@linux.vnet.ibm.com>
 <1373378207-10451-4-git-send-email-dingel@linux.vnet.ibm.com>
 <51DC33E7.1030404@de.ibm.com>
 <282EB214-206B-4A04-9830-D97679C9F4EC@suse.de>
 <20130710104253.GQ24941@redhat.com>
 <13B3500B-18A9-4B97-8C85-597BEAFC9250@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13B3500B-18A9-4B97-8C85-597BEAFC9250@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 12:45:59PM +0200, Alexander Graf wrote:
> 
> On 10.07.2013, at 12:42, Gleb Natapov wrote:
> 
> > On Wed, Jul 10, 2013 at 12:39:01PM +0200, Alexander Graf wrote:
> >> 
> >> On 09.07.2013, at 18:01, Christian Borntraeger wrote:
> >> 
> >>> On 09/07/13 15:56, Dominik Dingel wrote:
> >>>> By setting a Kconfig option, the architecture can control when
> >>>> guest notifications will be presented by the apf backend.
> >>>> So there is the default batch mechanism, working as before, where the vcpu thread
> >>>> should pull in this information. On the other hand there is now the direct
> >>>> mechanism, this will directly push the information to the guest.
> >>>> 
> >>>> Still the vcpu thread should call check_completion to cleanup leftovers,
> >>>> that leaves most of the common code untouched.
> >>>> 
> >>>> Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
> >>> 
> >>> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com> 
> >>> for the "why". We want to use the existing architectured interface.
> >> 
> >> Shouldn't this be a runtime option?
> >> 
> > Why? What is the advantage of using sync delivery when HW can do it
> > async?
> 
> What's the advantage of having an option at all then? Who selects it?
> 
x86 is stupid and cannot deliver the even asynchronously. Platform that
can do it select the option.

--
			Gleb.
