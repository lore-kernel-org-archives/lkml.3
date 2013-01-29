Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3A2Ash (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 19:48:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab3A2Asg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 19:48:36 -0500
Date: Mon, 28 Jan 2013 22:07:15 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 06/12] KVM: MMU: introduce a static table to map guest
 access to spte access
Message-ID: <20130129000715.GA10814@amt.cnet>
References: <50FFB5A1.5090708@linux.vnet.ibm.com>
 <50FFB658.6040205@linux.vnet.ibm.com>
 <20130125001550.GB22875@amt.cnet>
 <5101F207.6040603@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5101F207.6040603@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 10:46:31AM +0800, Xiao Guangrong wrote:
> On 01/25/2013 08:15 AM, Marcelo Tosatti wrote:
> > On Wed, Jan 23, 2013 at 06:07:20PM +0800, Xiao Guangrong wrote:
> >> It makes set_spte more clean and reduces branch prediction
> >>
> >> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> >> ---
> >>  arch/x86/kvm/mmu.c |   37 ++++++++++++++++++++++++++-----------
> >>  1 files changed, 26 insertions(+), 11 deletions(-)
> > 
> > Don't see set_spte as being a performance problem?
> > IMO the current code is quite simple.
> 
> Yes, this is not a performance problem.
> 
> I just dislike this many continuous "if"-s in the function:
> 
> if (xxx)
> 	xxx
> if (xxx)
> 	xxx
> ....
> 
> Totally, it has 7 "if"-s before this patch.
> 
> Okay, if you think this is unnecessary, i will drop this patch. :)

Yes, please (unless you can show set_spte is a performance problem).


