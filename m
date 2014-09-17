Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbaIQOsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:48:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363AbaIQOsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:48:10 -0400
Message-ID: <54199F29.1050507@suse.com>
Date: Wed, 17 Sep 2014 16:48:09 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, jbeulich@suse.com
Subject: Re: [PATCH V2 0/3] xen: remove some memory limits from pv-domains
References: <1410927157-15069-1-git-send-email-jgross@suse.com> <54199E23.7090403@citrix.com>
In-Reply-To: <54199E23.7090403@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 04:43 PM, David Vrabel wrote:
> On 17/09/14 05:12, Juergen Gross wrote:
>> When a Xen pv-domain is booted the initial memory map contains multiple
>> objects in the top 2 GB including the initrd and the p2m list. This
>> limits the supported maximum size of the initrd and the maximum
>> memory size the p2m list can span is limited to about 500 GB.
>>
>> Xen however supports loading the initrd without mapping it and the
>> initial p2m list can be mapped by Xen to an arbitrary selected virtual
>> address. The following patches activate those options and thus remove
>> the limitations.
>>
>> It should be noted that the p2m list limitation isn't only affecting
>> the amount of memory a pv domain can use, but it also hinders Dom0 to
>> be started on physical systems with larger memory without reducing it's
>> memory via a Xen boot parameter. By mapping the initial p2m list to
>> an area not in the top 2 GB it is now possible to boot Dom0 on such
>> systems.
>>
>> It would be desirable to be able to use more than 512 GB in a pv
>> domain, but this would require a reorganization of the p2m tree built
>> by the kernel at boot time. As this reorganization would affect the
>> Xen tools and kexec, too, it is not included in this patch set. This
>> topic can be addressed later.
>>
>> Juergen Gross (3):
>>    xen: sync some headers with xen tree
>>    xen: eliminate scalability issues from initrd handling
>
> I've applied these two to devel/for-linus-3.18.
>
> Thanks.

Thanks, too. :-)


Juergen

