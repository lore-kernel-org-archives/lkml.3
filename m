Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbaIZHyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:54:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58446 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbaIZHyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:54:17 -0400
Message-ID: <54251BA6.6080907@suse.com>
Date: Fri, 26 Sep 2014 09:54:14 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, jbeulich@suse.com
Subject: Re: [PATCH V3] xen: eliminate scalability issues from initial mapping
 setup
References: <1410965981-15444-1-git-send-email-jgross@suse.com> <1410965981-15444-2-git-send-email-jgross@suse.com> <5422C512.1010602@citrix.com>
In-Reply-To: <5422C512.1010602@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 03:20 PM, David Vrabel wrote:
> On 17/09/14 15:59, Juergen Gross wrote:
>> Direct Xen to place the initial P->M table outside of the initial
>> mapping, as otherwise the 1G (implementation) / 2G (theoretical)
>> restriction on the size of the initial mapping limits the amount
>> of memory a domain can be handed initially.
>>
>> As the initial P->M table is copied rather early during boot to
>> domain private memory and it's initial virtual mapping is dropped,
>> the easiest way to avoid virtual address conflicts with other
>> addresses in the kernel is to use a user address area for the
>> virtual address of the initial P->M table. This allows us to just
>> throw away the page tables of the initial mapping after the copy
>> without having to care about address invalidation.
>>
>> It should be noted that this patch won't enable a pv-domain to USE
>> more than 512 GB of RAM. It just enables it to be started with a
>> P->M table covering more memory. This is especially important for
>> being able to boot a Dom0 on a system with more than 512 GB memory.
>
> This doesn't seem to work.  It crashes when attempting to construct
> the page tables.  Have these patches been tested on a host with > 512 GiB?

After some tests on a machine with 1 TB memory I think this patch makes
sense only if the booted domain will be capable of using all the memory.
Ignoring everything above 512 GB will not work as the hypervisor is
putting vital information in this region (mfn_list, initrd, ...).

So please ignore this patch. I'm trying to setup a solution using a
virtually mapped linear p2m list.


Juergen

