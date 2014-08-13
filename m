Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaHMHaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 03:30:12 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:36937 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaHMHaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 03:30:09 -0400
Message-ID: <53EB13D9.5050501@linux.vnet.ibm.com>
Date: Wed, 13 Aug 2014 12:59:29 +0530
From: Vishal Mansur <vmansur@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: gwshan@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: non-GPL export for eeh_dev_check_failure
References: <53E0ED41.8030804@linux.vnet.ibm.com> <20140805155140.2b200061@alan.etchedpixels.co.uk> <1407726995.4508.64.camel@pasglop>
In-Reply-To: <1407726995.4508.64.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081307-5028-0000-0000-0000002692C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/11/2014 8:46 AM, Benjamin Herrenschmidt wrote:
> On Tue, 2014-08-05 at 15:51 +0100, One Thousand Gnomes wrote:
>> On Tue, 05 Aug 2014 20:12:09 +0530
>> Vishal Mansur <vmansur@linux.vnet.ibm.com> wrote:
>>
>>> EEH kernel services are inconsistently exported by the 
>>> kernel. eeh_check_failure is exported for any use, but 
>>> eeh_dev_check_failure is exported only for GPL use. 
>>> While eeh_check_failure is implemented for a specific 
>>> purpose to be used by services such as readl, it is 
>>> not suited for a purpose where caller needs eeh status. 
>>> This functionality is provided by eeh_dev_check_failure.
>>>
>>> This patch relaxes the export for eeh_dev_check_failure
>>> to make it consistent with eeh_check_failure() and 
>>> usable by non-GPL modules.
>>
>> The GPL covers all derivative works. Tweaking this doesn't magically
>> allow you to use the feature in non GPL code. Your legal department can I
>> am sure explain in detail further.
> 
> This is an interesting case... I assume this has to do with a well known
> GPU manufacturer...
> 
> The PCI APIs are generally exported in such a way that a non-GPL driver
> can use them (regardless of whether one considers a non-GPL driver to be
> legal here or not, this is besides the point).
> 
> eeh_dev_check_failure() can be considered as powerpc specific extension
> of the PCI API for use by PCI drivers and as such, it *could* be
> construed that we should be consistent (and consistent with
> eeh_check_failure()) and expose it as an EXPORT_SYMBOL without the GPL
> suffix.
> 
> So I'm somewhat tempted to take this patch, but Vishal, the driver in
> question could, I suppose, as a workaround, use a readl to some scratch
> register of some description, no ?

Ben, calling readl to some scratch register will be same as calling 
eeh_check_failure, caller will not be able to get eeh status.

Hence for the purpose where caller wants to know eeh status during
a bad register read, it can not be worked around using readl.

Thanks,
Vishal

> 
> Cheers,
> Ben.
> 
>> Alan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


