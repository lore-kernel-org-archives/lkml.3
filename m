Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3IEEFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 00:05:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:37190 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab3IEEFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 00:05:41 -0400
Message-ID: <1378353909.4321.126.camel@pasglop>
Subject: Re: [PATCH v9 12/13] KVM: PPC: Add support for IOMMU in-kernel
 handling
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-mm@kvack.org
Date: Thu, 05 Sep 2013 14:05:09 +1000
In-Reply-To: <20130903105315.GY22899@redhat.com>
References: <1377679070-3515-1-git-send-email-aik@ozlabs.ru>
	 <1377679841-3822-1-git-send-email-aik@ozlabs.ru>
	 <20130901120609.GJ22899@redhat.com> <52240295.7050608@ozlabs.ru>
	 <20130903105315.GY22899@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-03 at 13:53 +0300, Gleb Natapov wrote:
> > Or supporting all IOMMU links (and leaving emulated stuff as is) in on
> > "device" is the last thing I have to do and then you'll ack the patch?
> > 
> I am concerned more about API here. Internal implementation details I
> leave to powerpc experts :)

So Gleb, I want to step in for a bit here.

While I understand that the new KVM device API is all nice and shiny and that this
whole thing should probably have been KVM devices in the first place (had they
existed or had we been told back then), the point is, the API for handling
HW IOMMUs that Alexey is trying to add is an extension of an existing mechanism
used for emulated IOMMUs.

The internal data structure is shared, and fundamentally, by forcing him to
use that new KVM device for the "new stuff", we create a oddball API with
an ioctl for one type of iommu and a KVM device for the other, which makes
the implementation a complete mess in the kernel (and you should care :-)

So for something completely new, I would tend to agree with you. However, I
still think that for this specific case, we should just plonk-in the original
ioctl proposed by Alexey and be done with it.

Cheers,
Ben.


