Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421Ab3DYWzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:55:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33461 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759354Ab3DYWza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:55:30 -0400
Message-ID: <5179B435.1000404@zytor.com>
Date: Thu, 25 Apr 2013 15:54:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@elte.hu>, Josh Boyer <jwboyer@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Paul Bolle <pebolle@tiscali.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86 fixes for 3.9
References: <201304252144.r3PLihDe025383@terminus.zytor.com> <CA+55aFxxWXrQU4oZUbHOBBkvtF=pSxMvyF6sYU9xpSDarWV-=Q@mail.gmail.com> <1366928604.9976.3.camel@x230> <CANN689EH-VyDefawtKdY=cVQNdZP1xN7cV4bDgXvYeniSCkvqA@mail.gmail.com>
In-Reply-To: <CANN689EH-VyDefawtKdY=cVQNdZP1xN7cV4bDgXvYeniSCkvqA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 03:53 PM, Michel Lespinasse wrote:
> On Thu, Apr 25, 2013 at 3:23 PM, Matthew Garrett
> <matthew.garrett@nebula.com> wrote:
>> On Thu, 2013-04-25 at 15:20 -0700, Linus Torvalds wrote:
>>> On Thu, Apr 25, 2013 at 2:44 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>>>>
>>>> -       if (!sys_table->runtime->query_variable_info)
>>>> +       if (sys_table->runtime->hdr.revision < EFI_2_00_SYSTEM_TABLE_REVISION)
>>>>                 return EFI_UNSUPPORTED;
>>>
>>> Is a EFI 2.00 system table *guaranteed* to have that
>>> "query_variable_info" function? The above adds the version check, but
>>> removes the check for a NULL pointer.
>>
>> As far as the spec's concerned, yes. As far as reality's concerned - if
>> anything doesn't provide it, we're already crashing when
>> efi_virt_query_variable_info() gets called. Nobody's complained so far.
> 
> Well, I don't know if this is related, but commit e971318bbed6 broke
> the google EFI SMI driver with
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<ffffffff814a7245>] variable_is_present+0x55/0x170
> Call Trace:
> [<ffffffff814a9936>] register_efivars+0x106/0x370
> [<ffffffff818ff430>] ? firmware_map_add_early+0xb1/0xb1
> [<ffffffff818ff6dd>] gsmi_init+0x2ad/0x3da
> [<ffffffff8100020f>] do_one_initcall+0x3f/0x170
> ...
> 

I don't know either.  Could you test this patch and see if it does anything?

	-hpa

