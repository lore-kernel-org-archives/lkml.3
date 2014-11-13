Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbaKMJVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:21:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932116AbaKMJVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:21:03 -0500
Message-ID: <546477FD.9050800@suse.com>
Date: Thu, 13 Nov 2014 10:21:01 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [Xen-devel] [PATCH V3 7/8] xen: switch to linear virtual mapped
 sparse p2m list
References: <1415684626-18590-1-git-send-email-jgross@suse.com> <1415684626-18590-8-git-send-email-jgross@suse.com> <54624BCB.9040300@citrix.com>
In-Reply-To: <54624BCB.9040300@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2014 06:47 PM, David Vrabel wrote:
> On 11/11/14 05:43, Juergen Gross wrote:
>> At start of the day the Xen hypervisor presents a contiguous mfn list
>> to a pv-domain. In order to support sparse memory this mfn list is
>> accessed via a three level p2m tree built early in the boot process.
>> Whenever the system needs the mfn associated with a pfn this tree is
>> used to find the mfn.
>>
>> Instead of using a software walked tree for accessing a specific mfn
>> list entry this patch is creating a virtual address area for the
>> entire possible mfn list including memory holes. The holes are
>> covered by mapping a pre-defined  page consisting only of "invalid
>> mfn" entries. Access to a mfn entry is possible by just using the
>> virtual base address of the mfn list and the pfn as index into that
>> list. This speeds up the (hot) path of determining the mfn of a
>> pfn.
>>
>> Kernel build on a Dell Latitude E6440 (2 cores, HT) in 64 bit Dom0
>> showed following improvements:
>>
>> Elapsed time: 32:50 ->  32:35
>> System:       18:07 ->  17:47
>> User:        104:00 -> 103:30
>>
>> Tested on 64 bit dom0 and 32 bit domU.
>
> Reviewed-by: David Vrabel <david.vrabel@citrix.com>
>
> Can you please test this with the following guests/scenarios.
>
> * 64 bit dom0 with PCI devices with high MMIO BARs.

I'm not sure I have a machine available with this configuration.

> * 32 bit domU with PCI devices assigned.
> * 32 bit domU with 64 GiB of memory.
> * domU that starts pre-ballooned and is subsequently ballooned up.
> * 64 bit domU that is saved and restored (or local host migration)
> * 32 bit domU that is saved and restored (or local host migration)

I'll try.


Juergen
