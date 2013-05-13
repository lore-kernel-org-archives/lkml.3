Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab3EMUsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 16:48:01 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:33010 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3EMUr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 16:47:59 -0400
Message-ID: <5191515F.8020406@linux.vnet.ibm.com>
Date: Mon, 13 May 2013 13:47:27 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND v3 00/11] mm: fixup changers of per cpu pageset's
 ->high and ->batch
References: <1368472103-3427-1-git-send-email-cody@linux.vnet.ibm.com> <CAOJsxLF7xCiJmNn71zuNPGx1WzSj2BKeMVGXctfzvZODqVVU-A@mail.gmail.com>
In-Reply-To: <CAOJsxLF7xCiJmNn71zuNPGx1WzSj2BKeMVGXctfzvZODqVVU-A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051320-5406-0000-0000-0000086B5BC4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 12:20 PM, Pekka Enberg wrote:
> Hi Cody,
>
> On Mon, May 13, 2013 at 10:08 PM, Cody P Schafer
> <cody@linux.vnet.ibm.com> wrote:
>> "Problems" with the current code:
>>   1. there is a lack of synchronization in setting ->high and ->batch in
>>      percpu_pagelist_fraction_sysctl_handler()
>>   2. stop_machine() in zone_pcp_update() is unnecissary.
>>   3. zone_pcp_update() does not consider the case where percpu_pagelist_fraction is non-zero
>
> Maybe it's just me but I find the above problem description confusing.
> How does the problem manifest itself?

1. I've not reproduced this causing issues.
2. Calling zone_pcp_update() is slow.
3. Not reproduced either, but would cause percpu_pagelist_fraction (set 
via sysctl) to be ignored after a call to zone_pcp_update() (for 
example, after a memory hotplug).

> How did you find about it?

I'm writing some code that resizes zones and thus uses 
zone_pcp_update(), and fixing broken things along the way.

> Why
> do we need to fix all three problems in the same patch set?

They all affect the same bit of code and fixing all of them means 
restructuring the both of the sites where ->high and ->batch are set.

Additionally, splitting it out (if possible) would make it less clear 
what the overall goal is, and would mean a few inter-patchset 
dependencies, which are undesirable.

