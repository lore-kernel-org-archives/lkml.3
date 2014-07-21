Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaGUCQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 22:16:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:39888 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbaGUCQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 22:16:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,697,1400050800"; 
   d="scan'208";a="572833103"
Message-ID: <53CC7787.2070302@intel.com>
Date: Mon, 21 Jul 2014 10:14:31 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [PATCH] ACPI/NVS: Not save NVS region for new machines to accelerate
 S3
References: <1405662922-23606-1-git-send-email-tianyu.lan@intel.com> <20140718080056.GA2037@gchen.bj.intel.com>
In-Reply-To: <20140718080056.GA2037@gchen.bj.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年07月18日 16:00, Chen, Gong wrote:
> On Fri, Jul 18, 2014 at 01:55:22PM +0800, Lan Tianyu wrote:
>> Date:	Fri, 18 Jul 2014 13:55:22 +0800
>> From: Lan Tianyu <tianyu.lan@intel.com>
>> To: rjw@rjwysocki.net, lenb@kernel.org
>> Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
>>  linux-kernel@vger.kernel.org
>> Subject: [PATCH] ACPI/NVS: Not save NVS region for new machines to
>>  accelerate S3
>> X-Mailer: git-send-email 1.7.9.5
>>
>> NVS region is saved and restored unconditionally for machines without
>> nvs_nosave quirk during S3. Tested some new machines and the operation
>> is not necessary. Saving NVS region also affects S2RAM speed. The time of
>> NVS saving and restoring depends on the size of NVS region and it consumes
>> 7~10ms normally.
>>
>> This patch is to make machines produced from 2012 to now not saving NVS region
>> to accelerate S3.
>>
> The year 2012 is a mandatory value in the spec?
> 

No, spec indicates that this is only required for S4 and commit 2a6b697
added this behavior because this can fix S3 bug on some machines. But
this isn't necessary for all machines and waster time for S3. So this
patch is to add time base quirk to change default behavior for new machines.

-- 
Best regards
Tianyu Lan
