Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbaDHSoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:44:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756314AbaDHSoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:44:11 -0400
Message-ID: <53444330.2030606@redhat.com>
Date: Tue, 08 Apr 2014 14:42:56 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Bill Sumner <bill.sumner@hp.com>, indou.takao@jp.fujitsu.com,
        bhe@redhat.com, joro@8bytes.org, iommu@lists.linux-foundation.org,
        kexec@lists.infradead.org, alex.williamson@redhat.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, doug.hatch@hp.com,
        zhenhua@hp.com
Subject: Re: [PATCHv3 0/6] Crashdump Accepting Active IOMMU
References: <1389391652-52422-1-git-send-email-bill.sumner@hp.com>  <53430DE9.9080303@redhat.com> <1396973686.25235.36.camel@i7.infradead.org>
In-Reply-To: <1396973686.25235.36.camel@i7.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 12:14 PM, David Woodhouse wrote:
> On Mon, 2014-04-07 at 16:43 -0400, Don Dutile wrote:
>>
>> Additionally, a tidbit of information like "some servers force NMI's
>> on DMAR faults,
>> and cause a system reset, thereby, preventing a kdump to occur"
>> should have been included as one reason to stop DMAR faults from
>> occurring on kexec-boot,
>> in addition to the fact that a flood of them can lock up a system.
>
> How about allocating a physical scratch page, and setting up a mapping
> for each device such that *every* virtual address (apart from those
> listed in RMRRs, perhaps) is mapped to that same scratch page?
>
> That way you avoid the faults, but you also avoid stray DMA to parts of
> the system that you don't want to get corrupted.
>
+1... more isolation as second kernel booting sounds good.

