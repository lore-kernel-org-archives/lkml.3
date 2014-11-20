Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750973AbaKTFIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 00:08:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbaKTFIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 00:08:35 -0500
Message-ID: <546D7751.6060707@suse.com>
Date: Thu, 20 Nov 2014 06:08:33 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH V3 0/8] xen: Switch to virtual mapped linear p2m list
References: <1415684626-18590-1-git-send-email-jgross@suse.com> <20141119204131.GD18495@laptop.dumpdata.com>
In-Reply-To: <20141119204131.GD18495@laptop.dumpdata.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2014 09:41 PM, Konrad Rzeszutek Wilk wrote:
> On Tue, Nov 11, 2014 at 06:43:38AM +0100, Juergen Gross wrote:
>> Paravirtualized kernels running on Xen use a three level tree for
>> translation of guest specific physical addresses to machine global
>> addresses. This p2m tree is used for construction of page table
>> entries, so the p2m tree walk is performance critical.
>>
>> By using a linear virtual mapped p2m list accesses to p2m elements
>> can be sped up while even simplifying code. To achieve this goal
>> some p2m related initializations have to be performed later in the
>> boot process, as the final p2m list can be set up only after basic
>> memory management functions are available.
>>
>
> Hey Juergen,
>
> I finially finished looking at the patchset. Had some comments,
> some questions that I hope can make it in the patch so that in
> six months or so when somebody looks at the code they can
> understand the subtle pieces.

Yep.

OTOH: What was hard to write should be hard to read ;-)

> Looking forward to the v4! (Thought keep in mind that next week
> is Thanksgiving week so won't be able to look much after Wednesday)

Let's see how testing is going. Setting up the test system wasn't
very smooth due to some unrelated issues.

>
>>   arch/x86/include/asm/pgtable_types.h |    1 +
>>   arch/x86/include/asm/xen/page.h      |   49 +-
>>   arch/x86/mm/pageattr.c               |   20 +
>>   arch/x86/xen/mmu.c                   |   38 +-
>>   arch/x86/xen/p2m.c                   | 1315 ++++++++++++++--------------------
>>   arch/x86/xen/setup.c                 |  460 ++++++------
>>   arch/x86/xen/xen-ops.h               |    6 +-
>>   7 files changed, 854 insertions(+), 1035 deletions(-)
>
> And best of - we are deleting more code!

Indeed. But it's a shame the beautiful ASCII-art in p2m.c is part of the
deletions.


Juergen
