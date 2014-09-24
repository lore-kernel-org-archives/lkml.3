Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaIXODt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:03:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbaIXODr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:03:47 -0400
Message-ID: <5422CF41.9000803@suse.com>
Date: Wed, 24 Sep 2014 16:03:45 +0200
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

Not yet. I did a code review and was pretty sure the memory above 512GB
would be ignored - seems as if I was wrong.

I'll have access to a machine with 1TB RAM soon, so I'll try to test a
patch which really does what I thought should be done: ignoring the
memory above 512GB.

Thanks for testing!


Juergen
