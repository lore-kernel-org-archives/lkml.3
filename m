Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbbAMBaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 20:30:07 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:58418 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbbAMBaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 20:30:06 -0500
Message-ID: <54B474D5.8090500@hp.com>
Date: Tue, 13 Jan 2015 09:28:53 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        vgoyal@redhat.com, dyoung@redhat.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kexec@lists.infradead.org, alex.williamson@redhat.com,
        ddutile@redhat.com, ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com,
        doug.hatch@hp.com, jerry.hoemann@hp.com, tom.vaden@hp.com,
        li.zhang6@hp.com, lisa.mitchell@hp.com, billsumnerlinux@gmail.com,
        rwright@hp.com, "Li, ZhenHua" <zhen-hual@hp.com>
Subject: Re: [PATCH v8 01/10] iommu/vt-d: Update iommu_attach_domain() and
 its callers
References: <1421046388-27925-1-git-send-email-zhen-hual@hp.com> <1421046388-27925-2-git-send-email-zhen-hual@hp.com> <20150112151855.GB6343@8bytes.org>
In-Reply-To: <20150112151855.GB6343@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 11:18 PM, Joerg Roedel wrote:
> On Mon, Jan 12, 2015 at 03:06:19PM +0800, Li, Zhen-Hua wrote:
>> Allow specification of the domain-id for the new domain.
>> This patch only adds the 'did' parameter to iommu_attach_domain()
>> and modifies all of its callers to specify the default value of -1
>> which says "no did specified, allocate a new one".
>
> I think its better to keep the old iommu_attach_domain() interface in
> place and introduce a new function (like iommu_attach_domain_with_id()
> or something) which has the additional parameter. Then you can rewrite
> iommu_attach_domain():
>
> 	iommu_attach_domai(...)
> 	{
> 		return iommu_attach_domain_with_id(..., -1);
> 	}
>
> This way you don't have to update all the callers of
> iommu_attach_domain() and the interface is more readable.
>
>
> 	Joerg
>

That's a good way. I will do this in next version.

Thanks
Zhenhua


