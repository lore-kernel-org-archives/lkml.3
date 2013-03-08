Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab3CHThw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 14:37:52 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:31253 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3CHThv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 14:37:51 -0500
X-IronPort-AV: E=Sophos;i="4.84,809,1355097600"; 
   d="scan'208";a="11522354"
Message-ID: <513A3E0C.4030703@citrix.com>
Date: Fri, 8 Mar 2013 19:37:48 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86,mm: fix init_mem_mapping() when the first memory
 chunk is small
References: <1362768434-30525-1-git-send-email-david.vrabel@citrix.com>  <CAE9FiQX38v_3-zMebjbUPum+Tt1z1jrDAzAfXo4o1j4X-xbHSg@mail.gmail.com>
In-Reply-To: <CAE9FiQX38v_3-zMebjbUPum+Tt1z1jrDAzAfXo4o1j4X-xbHSg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/13 19:01, Yinghai Lu wrote:
> On Fri, Mar 8, 2013 at 10:47 AM, David Vrabel <david.vrabel@citrix.com> wrote:
>> In init_mem_mapping(), if the first chunk of memory that is mapped is
>> small, there will not be enough mapped pages to allocate page table
>> pages for the next (larger) chunk.
>>
>> Estimate how many pages are used for the mappings so far and how many
>> are needed for a larger chunk, and only increase step_size if there
>> are enough free pages.
>>
>> This fixes a boot failure on a system where the first chunk of memory
>> mapped only had 3 pages in it.
>>
>> init_memory_mapping: [mem 0x00000000-0x000fffff]
>> init_memory_mapping: [mem 0x20d000000-0x20d002fff]
>> init_memory_mapping: [mem 0x20c000000-0x20cffffff]
>> Kernel panic - not syncing: alloc_low_page: can not alloc memory
> 
> Can you check current linus tree?
> 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=98e7a989979b185f49e86ddaed2ad6890299d9f0
> 
> should fix the problem with your system.

Yes, that fixes it thanks.

David
