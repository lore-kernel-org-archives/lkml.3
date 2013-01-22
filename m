Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3AVQOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:14:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab3AVQOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:14:37 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH V5 00/30] loop: Issue O_DIRECT aio using bio_vec
References: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com>
	<x49obgmif7w.fsf@segfault.boston.devel.redhat.com>
	<x49k3raidd6.fsf@segfault.boston.devel.redhat.com>
	<50F98D29.6050701@oracle.com>
	<x4938xyi2mm.fsf@segfault.boston.devel.redhat.com>
	<50F9CD9E.1050902@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 22 Jan 2013 11:14:27 -0500
In-Reply-To: <50F9CD9E.1050902@oracle.com> (Dave Kleikamp's message of "Fri,
	18 Jan 2013 16:33:02 -0600")
Message-ID: <x49622pb3fg.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp <dave.kleikamp@oracle.com> writes:

> On 01/18/2013 03:48 PM, Jeff Moyer wrote:
>> Dave Kleikamp <dave.kleikamp@oracle.com> writes:
>> 
>>> On 01/18/2013 11:56 AM, Jeff Moyer wrote:
>>>> Jeff Moyer <jmoyer@redhat.com> writes:
>>>>
>>>>> ./check -g aio
>>>>>
>>>>> and here is the summary:
>>>>>
>>>>> Ran: 112 113 198 207 208 209 210 211 212 239 240
>>>>> Failures: 112 198 207 239 240
>>>>> Failed 5 of 11 tests
>>>>>
>>>>> To be fair, I have not yet run this on a kernel without your changes.
>>>>
>>>> I re-ran the same test against a vanilla 3.8.0-rc4 kernel and it passed:
>>>>
>>>> Ran: 112 113 198 207 208 209 210 211 212 239 240
>>>> Passed all 11 tests
>>>>
>>>> I'll start digging into the failures.
>>>
>>> Thanks, I'll take a look at it too.
>> 
>> Note that the failures occur on regular block devices, too;  this isn't
>> restricted to loop.  The fix I mentioned in reply to patch 17 actually
>> fixes all of the failures reported in the aio group.  I'm going to do
>> some more thorough testing over the weekend.
>
> Thanks much. I'll definitely add this to my testing.

After fixing up that thinko, a full run of xfstests on an xfs file
system backed by a loop device (which itself is a file on an xfs file
system) shows no regressions.

Cheers,
Jeff
