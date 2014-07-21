Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaGUHj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 03:39:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:7282 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbaGUHj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 03:39:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="459388818"
Message-ID: <53CCC336.4040302@intel.com>
Date: Mon, 21 Jul 2014 15:37:26 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [PATCH] ACPI/NVS: Not save NVS region for new machines to accelerate
 S3
References: <1405662922-23606-1-git-send-email-tianyu.lan@intel.com> <20140718080056.GA2037@gchen.bj.intel.com> <53CC7787.2070302@intel.com> <20140721050105.GA21503@gchen.bj.intel.com> <53CCAB30.405@intel.com> <20140721062556.GA23297@gchen.bj.intel.com>
In-Reply-To: <20140721062556.GA23297@gchen.bj.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年07月21日 14:25, Chen, Gong wrote:
> On Mon, Jul 21, 2014 at 01:54:56PM +0800, Lan Tianyu wrote:
>> Date: Mon, 21 Jul 2014 13:54:56 +0800
>> From: Lan Tianyu <tianyu.lan@intel.com>
>> To: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
>>  linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
>> Subject: Re: [PATCH] ACPI/NVS: Not save NVS region for new machines to
>>  accelerate S3
>> User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714
>>  Thunderbird/14.0
>>
>> On 2014年07月21日 13:01, Chen, Gong wrote:
>>> On Mon, Jul 21, 2014 at 10:14:31AM +0800, Lan Tianyu wrote:
>>>> Date: Mon, 21 Jul 2014 10:14:31 +0800
>>>> From: Lan Tianyu <tianyu.lan@intel.com>
>>>> To: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
>>>>  linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
>>>> Subject: Re: [PATCH] ACPI/NVS: Not save NVS region for new machines to
>>>>  accelerate S3
>>>> User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714
>>>>  Thunderbird/14.0
>>>>
>>>> On 2014年07月18日 16:00, Chen, Gong wrote:
>>>>> On Fri, Jul 18, 2014 at 01:55:22PM +0800, Lan Tianyu wrote:
>>>>>> Date:	Fri, 18 Jul 2014 13:55:22 +0800
>>>>>> From: Lan Tianyu <tianyu.lan@intel.com>
>>>>>> To: rjw@rjwysocki.net, lenb@kernel.org
>>>>>> Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
>>>>>>  linux-kernel@vger.kernel.org
>>>>>> Subject: [PATCH] ACPI/NVS: Not save NVS region for new machines to
>>>>>>  accelerate S3
>>>>>> X-Mailer: git-send-email 1.7.9.5
>>>>>>
>>>>>> NVS region is saved and restored unconditionally for machines without
>>>>>> nvs_nosave quirk during S3. Tested some new machines and the operation
>>>>>> is not necessary. Saving NVS region also affects S2RAM speed. The time of
>>>>>> NVS saving and restoring depends on the size of NVS region and it consumes
>>>>>> 7~10ms normally.
>>>>>>
>>>>>> This patch is to make machines produced from 2012 to now not saving NVS region
>>>>>> to accelerate S3.
>>>>>>
>>>>> The year 2012 is a mandatory value in the spec?
>>>>>
>>>>
>>>> No, spec indicates that this is only required for S4 and commit 2a6b697
>>>> added this behavior because this can fix S3 bug on some machines. But
>>>> this isn't necessary for all machines and waster time for S3. So this
>>>> patch is to add time base quirk to change default behavior for new machines.
>>>>
>>> If so, I don't think a hard-coded valud in the kernel is a good idea.
>>> Why not providing a quirk via a command line parameter or module parameter.
>>>
>>
>> There is already a kernel command "acpi_sleep=nonvs_s3" to do that. But
>> this needs to be set by user. Otherwise, saving/restoring NVS region
>> also breaks system suspend on some machines and we have added 14
>> nonvs quirks in the acpisleep_dmi_table.
>>
> 14 quriks! What a terrible BIOS, isn't it? It's time to cleanup so
> many hacks.

If change the default behavior for old machines, that may cause some
regressions and need to add new quirks to save/restore nvs region again.

> I'm not ACPI expert, but such yet another hack is not
> acceptable from my point of view.
> 


-- 
Best regards
Tianyu Lan
