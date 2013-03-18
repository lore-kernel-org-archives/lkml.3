Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab3CRMtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 08:49:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab3CRMtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 08:49:01 -0400
Date: Mon, 18 Mar 2013 14:48:54 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/5] KVM: MMU: store generation-number into mmio spte
Message-ID: <20130318124854.GI4020@redhat.com>
References: <51433D98.4050605@linux.vnet.ibm.com>
 <51433E43.60900@linux.vnet.ibm.com>
 <5146F830.1070602@redhat.com>
 <51470BA1.3060601@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51470BA1.3060601@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 08:42:09PM +0800, Xiao Guangrong wrote:
> On 03/18/2013 07:19 PM, Paolo Bonzini wrote:
> > Il 15/03/2013 16:29, Xiao Guangrong ha scritto:
> >> +/*
> >> + * spte bits of bit 3 ~ bit 11 are used as low 9 bits of
> >> + * generation, the bits of bits 52 ~ bit 61 are used as
> >> + * high 12 bits of generation.
> >> + */
> > 
> > High 10 bits.
> 
> Yes, i forgot to update the comments! Thank you, Paolo!
> 
> > 
> > How often does the generation number change?  Especially with Takuya's
> > patches, using just 10 bits for the generation might be enough and
> > simplifies the code.
> 
> I guess it's only updated when guest is initializing and doing hotplug.
> In my origin thought, if the number is big enough that it could not
> round on all most case of hotplug, the things introduced by Takuya is
> not necessary. But, if you guys want to keep the things, 10 bits should
> be enough. :)
I think you encapsulated the 19bit generation number handling good enough, so
I personally do not mind making it as big as we can.

--
			Gleb.
