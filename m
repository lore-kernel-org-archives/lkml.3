Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbaI3C13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 22:27:29 -0400
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:45547 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861AbaI3C11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 22:27:27 -0400
Message-ID: <542A150E.5070406@nexus-software.ie>
Date: Tue, 30 Sep 2014 03:27:26 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Reply-To: pure.logic@nexus-software.ie
Organization: Nexus Software
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "davej@redhat.com" <davej@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] x86: Quark: Add if/else to setup_arch for Quark TLB
 bug
References: <1411754118-11665-1-git-send-email-pure.logic@nexus-software.ie> <20140926205955.GA22407@khazad-dum.debian.net> <5425DA8A.1030500@nexus-software.ie> <AF233D1473C1364ABD51D28909A1B1B73259A4FF@pgsmsx105.gar.corp.intel.com>
In-Reply-To: <AF233D1473C1364ABD51D28909A1B1B73259A4FF@pgsmsx105.gar.corp.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/09/14 02:46, Ong, Boon Leong wrote:
>>
>> My view is that the CR3 load should have flushed the TLB in it's entirety.
>>
>> Ong Boong Leong said that a discussion he had which included HPA concluded
>> with a flush of the TLB being required after the CR3 reload.
>
> The proposed patch was discussed in April and after much thought into this,
> I will suggest that as long as the commentary properly captured down why
> __flush_tlb() is **NOT** needed because load_cr3() will have the same effect.

Agree.

>>
>> The current code
>>
>> My preference is
>>
>> 1. Just comment the code as is to explain why it works for Quark.
>>
>> If that's not good enough for people then
>>
>> 2. if/else the flow so that Quark does __flush_tlb() and the rest of the world
>> does a __flush_tlb_all()
> Bryan, just drop this proposal from my submission even though __flush_tlb() is
> more obvious in what is supposed to do and does not consume any significant cpu-time.

Very good. I've a new patchset ready to report cache size based on the 
callbacks that Ingo and Dave suggested - found a bug too - so I'll 
submit those changes as one.

1. Comment
2. Reporting of cache size
3. Bugfix to the code path for legacy_cache_size => currently broken for 
{PIII Tualatin, a bunch of AMDs, and some VIAs too by the looks of it}


