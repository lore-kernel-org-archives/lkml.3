Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab3FRBPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 21:15:21 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:53568 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab3FRBPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 21:15:18 -0400
Message-ID: <51BFB499.9050302@huawei.com>
Date: Tue, 18 Jun 2013 09:15:05 +0800
From: "Jiang Liu (Gerry)" <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Matthew Garrett <mjg@redhat.com>, Aaron Lu <aaron.lu@intel.com>,
        Liu Jiang <liuj97@gmail.com>, Liu Jiang <liu97@gmail.com>,
        <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata: remove dead code from libata-acpi.c
References: <1371265368-7334-1-git-send-email-liuj97@gmail.com> <51BE6B5C.70803@intel.com> <20130617180151.GG32663@mtj.dyndns.org>
In-Reply-To: <20130617180151.GG32663@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.77.35]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/18 2:01, Tejun Heo wrote:
> On Mon, Jun 17, 2013 at 09:50:20AM +0800, Aaron Lu wrote:
>> On 06/15/2013 11:02 AM, Liu Jiang wrote:
>>> From: Liu Jiang <liu97@gmail.com>
>>>
>>> Commit 30dcf76acc69 "libata: migrate ACPI code over to new bindings"
>>> removed ACPI dock notification related code, but there's some dead
>>> code left, so clean up it.
>>
>> I never noticed this, but it looks to be the case...
>>
>> I'm not sure the dock notification code is removed intentionally or
>> mistakenly though, if it is a mistake, then instead of removing the left
>> code here, we probably should add the dock notification code back.
>>
>> But I have no test system or any knowledge about how ata dock works, so
>> I may be wrong :-)
>
> Looks like a regression to me.  We're probably locking up on some
> older laptops which connects optical drives with hotpluggable PATA.
> Matthew, can you please fix it?
>
> Thanks.
>
Yeah, Aaron is right. We should restore the dock notification
handler to support ATA hotplug on some IBM laptops.
Regards!
Gerry

