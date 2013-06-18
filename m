Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab3FRJQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:16:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:27964 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332Ab3FRJQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:16:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,887,1363158000"; 
   d="scan'208";a="355378759"
Message-ID: <51C02571.3090100@intel.com>
Date: Tue, 18 Jun 2013 17:16:33 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Matthew Garrett <mjg@redhat.com>, Liu Jiang <liuj97@gmail.com>,
        Liu Jiang <liu97@gmail.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liu Jiang <jiang.liu@huawei.com>
Subject: Re: [PATCH] libata: remove dead code from libata-acpi.c
References: <1371265368-7334-1-git-send-email-liuj97@gmail.com> <51BE6B5C.70803@intel.com> <20130617180151.GG32663@mtj.dyndns.org>
In-Reply-To: <20130617180151.GG32663@mtj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 02:01 AM, Tejun Heo wrote:
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

A user just reported a bug for this:
https://bugzilla.kernel.org/show_bug.cgi?id=59871

And bisected to commit 30dcf76acc69. I proposed a fix patch there, let's
see what the user's test result.

Thanks,
Aaron
