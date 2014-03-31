Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaCaRIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:08:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbaCaRId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:08:33 -0400
Message-ID: <5339A0F8.70606@redhat.com>
Date: Mon, 31 Mar 2014 19:08:08 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Jacob Shin <jacob.shin@amd.com>, Jeff Layton <jlayton@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: microcode: report if CPU has up-to-date microcode
References: <1396188574-2067-1-git-send-email-dvlasenk@redhat.com> <20140331162340.GB16144@pd.tnic>
In-Reply-To: <20140331162340.GB16144@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 06:23 PM, Borislav Petkov wrote:
> On Sun, Mar 30, 2014 at 04:09:32PM +0200, Denys Vlasenko wrote:
>> Before this change, successful microcode uploads clearly
>> indicate that it was done:
>>
>> microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x1a
>> microcode: CPU1 updated to revision 0x29, date = 2013-06-12
>>
>> whereas if microcode was not uploaded, it is not clear why:
>>
>> microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x29
>> (nothing more)
>>
>> So, what was it? No microcode file? No microcode for this sig/pf?
>> CPU already has microcode with this (or newer) revision?
>>
>> In practice, it means that I need to ask people to provide me
>> with more information ("do you have microcode package installed?
>> which version is it?" etc).
> 
> First of all, microcode version is in /proc/cpuinfo.

What prompted me to create this patch is a bunch of vmcores
from people having mysterious crashes.

Basically, I am in a real-world scenario where I have only vmcore
from somebody else. I have no /proc/cpuinfo.

Every bit of information I don't have at a minimum incurs email
round-trip delay.

Eventually I did manage to figure out what version of microcode
my users had (they did have old one), but it took some time.

> Issuing the reason
> why microcode wasn't loaded in dmesg and then the dmesg ring buffer
> wraps around doesn't make a lot of sense, in my not really too humble
> opinion.

You are correct, the lack of boot-time dmesg is a problem for
post-mortem vmcore analysis in general.

I contemplate creating a patch to optionally save it.

> Besides, experience shows that dmesg messages like those tend to spook
> users and we don't want that :-)

That is not a bad thing: if my users would have been spooked that way,
maybe they'd install a newer microcode. Or newer BIOS with new microcode
- they did not do that either, despite it being available
from the manufacturer for two years already.

-- 
vda

