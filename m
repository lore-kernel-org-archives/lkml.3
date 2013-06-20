Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935442Ab3FTIsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:48:25 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64721 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab3FTIsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:48:22 -0400
Message-ID: <51C2C1CC.9000003@ozlabs.ru>
Date: Thu, 20 Jun 2013 18:48:12 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: David Gibson <david@gibson.dropbear.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Graf <agraf@suse.de>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        "kvm@vger.kernel.org mailing list" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
References: <1371422343.21896.143.camel@pasglop>  <1371438800.22681.38.camel@ul30vt.home>  <1371441361.21896.152.camel@pasglop>  <1371522772.22681.140.camel@ul30vt.home> <87txkun568.fsf@rustcorp.com.au>  <1371617970.21896.232.camel@pasglop>  <E63966E3-336F-4CB8-96EC-24D2C1644E62@suse.de>  <1371653443.21896.291.camel@pasglop>  <1371656989.22659.98.camel@ul30vt.home> <51C28BEA.8050501@ozlabs.ru>  <20130620052822.GB3140@voom.redhat.com> <1371714449.3944.14.camel@pasglop>
In-Reply-To: <1371714449.3944.14.camel@pasglop>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 05:47 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2013-06-20 at 15:28 +1000, David Gibson wrote:
>>> Just out of curiosity - would not get_file() and fput_atomic() on a
>> group's
>>> file* do the right job instead of vfio_group_add_external_user() and
>>> vfio_group_del_external_user()?
>>
>> I was thinking that too.  Grabbing a file reference would certainly be
>> the usual way of handling this sort of thing.
> 
> But that wouldn't prevent the group ownership to be returned to
> the kernel or another user would it ?


Holding the file pointer does not let the group->container_users counter go
to zero and this is exactly what vfio_group_add_external_user() and
vfio_group_del_external_user() do. The difference is only in absolute value
- 2 vs. 3.

No change in behaviour whether I use new vfio API or simply hold file* till
KVM closes fd created when IOMMU was connected to LIOBN.

And while this counter is not zero, QEMU cannot take ownership over the group.

I am definitely still missing the bigger picture...


-- 
Alexey
