Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532Ab3GaKb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:31:56 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:47915 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab3GaKby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:31:54 -0400
Date: Wed, 31 Jul 2013 06:31:52 -0400 (EDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, cornelia huck <cornelia.huck@de.ibm.com>,
        kvm@vger.kernel.org
Message-ID: <1740231204.7441078.1375266712603.JavaMail.root@redhat.com>
In-Reply-To: <20130731090457.GB7484@redhat.com>
References: <1375196737-2264-1-git-send-email-pbonzini@redhat.com> <20130731090457.GB7484@redhat.com>
Subject: Re: [PATCH] KVM: introduce __kvm_io_bus_sort_cmp
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (zclient/8.0.3_GA_5664)
Thread-Topic: introduce __kvm_io_bus_sort_cmp
Thread-Index: 0Oh7jDslzWSJmmEjEnEB5CmdIJvw+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Gleb Natapov <gleb@redhat.com> wrote:
> On Tue, Jul 30, 2013 at 05:05:37PM +0200, Paolo Bonzini wrote:
> > kvm_io_bus_sort_cmp is used also directly, not just as a callback for
> > sort and bsearch.  In these cases, it is handy to have a type-safe
> > variant.  This patch introduces such a variant, __kvm_io_bus_sort_cmp,
> > and uses it throughout kvm_main.c.
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  virt/kvm/kvm_main.c | 21 ++++++++++++---------
> >  1 file changed, 12 insertions(+), 9 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index b2a2bb9..e0d127d 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2812,11 +2812,9 @@ static void kvm_io_bus_destroy(struct kvm_io_bus *bus)
> >  	kfree(bus);
> >  }
> >  
> > -static int kvm_io_bus_sort_cmp(const void *p1, const void *p2)
> > +static inline int __kvm_io_bus_sort_cmp(const struct kvm_io_range *r1,
> > +                                        const struct kvm_io_range *r2)
> IMO calling this one kvm_io_bus_sort_cmp and another one
> kvm_io_bus_cmp will be better naming.

Ok.

Paolo
