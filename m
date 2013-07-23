Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab3GWJHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:07:54 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:35422 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826Ab3GWJHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:07:50 -0400
Message-ID: <51EE47DE.5020002@ozlabs.ru>
Date: Tue, 23 Jul 2013 19:07:42 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Alex Williamson <alex.williamson@redhat.com>,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 03/10] vfio: add external user support
References: <1373936045-22653-1-git-send-email-aik@ozlabs.ru>  <1373936045-22653-4-git-send-email-aik@ozlabs.ru> <1374546224.15429.8.camel@ul30vt.home>
In-Reply-To: <1374546224.15429.8.camel@ul30vt.home>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 12:23 PM, Alex Williamson wrote:
> On Tue, 2013-07-16 at 10:53 +1000, Alexey Kardashevskiy wrote:
>> VFIO is designed to be used via ioctls on file descriptors
>> returned by VFIO.
>>
>> However in some situations support for an external user is required.
>> The first user is KVM on PPC64 (SPAPR TCE protocol) which is going to
>> use the existing VFIO groups for exclusive access in real/virtual mode
>> on a host to avoid passing map/unmap requests to the user space which
>> would made things pretty slow.
>>
>> The protocol includes:
>>
>> 1. do normal VFIO init operation:
>> 	- opening a new container;
>> 	- attaching group(s) to it;
>> 	- setting an IOMMU driver for a container.
>> When IOMMU is set for a container, all groups in it are
>> considered ready to use by an external user.
>>
>> 2. User space passes a group fd to an external user.
>> The external user calls vfio_group_get_external_user()
>> to verify that:
>> 	- the group is initialized;
>> 	- IOMMU is set for it.
>> If both checks passed, vfio_group_get_external_user()
>> increments the container user counter to prevent
>> the VFIO group from disposal before KVM exits.
>>
>> 3. The external user calls vfio_external_user_iommu_id()
>> to know an IOMMU ID. PPC64 KVM uses it to link logical bus
>> number (LIOBN) with IOMMU ID.
>>
>> 4. When the external KVM finishes, it calls
>> vfio_group_put_external_user() to release the VFIO group.
>> This call decrements the container user counter.
>> Everything gets released.
>>
>> The "vfio: Limit group opens" patch is also required for the consistency.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> 
> This looks fine to me.  Is the plan to add this through the ppc tree
> again?  Thanks,


Nope, better to add this through your tree. And faster for sure :) Thanks!



-- 
Alexey
