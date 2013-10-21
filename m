Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab3JUKf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 06:35:58 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21395 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab3JUKf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 06:35:56 -0400
Message-ID: <5265037B.4050108@oracle.com>
Date: Mon, 21 Oct 2013 18:35:39 +0800
From: Vaughan Cao <vaughan.cao@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: dgilbert@interlog.com, Bart Van Assche <bvanassche@acm.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Madper Xie <cxie@redhat.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, vaughan.cao@oracle.com
Subject: Re: [PATCH] [SCSI] sg: late O_EXCL fix for lk 3.12-rc
References: <52640025.60709@interlog.com> <52641389.6090604@acm.org> <526460A0.3000807@interlog.com>
In-Reply-To: <526460A0.3000807@interlog.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013年10月21日 07:00, Douglas Gilbert wrote:
> On 13-10-20 01:31 PM, Bart Van Assche wrote:
>> On 10/20/13 18:09, Douglas Gilbert wrote:
>>> Given that lk 3.12.0 release is not far away, the safest path
>>> may still be to revert Vaughan Cao's patch. I'll leave that
>>> decision to the maintainers.
>>
>> Hello Doug,
>>
>> Thanks for looking into this. But I would appreciate it if you could 
>> address the
>> whitespace errors reported by checkpatch:
>>
>> ERROR: space prohibited after that '!' (ctx:BxW)
>> #24: FILE: drivers/scsi/sg.c:241:
>> + (excl_case ? (! sdp->exclude) : sfds_list_empty(sdp))));
>> ^
>>
>> ERROR: space prohibited after that '!' (ctx:BxW)
>> #55: FILE: drivers/scsi/sg.c:289:
>> + if (! alone) {
>> ^
>>
>> ERROR: code indent should use tabs where possible
>> #59: FILE: drivers/scsi/sg.c:292:
>> + }$
>>
>> WARNING: please, no spaces at the start of a line
>> #59: FILE: drivers/scsi/sg.c:292:
>> + }$
>>
>> ERROR: space prohibited after that '!' (ctx:BxW)
>> #73: FILE: drivers/scsi/sg.c:301:
>> + while (! alone) {
>> ^
>>
>> WARNING: suspect code indent for conditional statements (8, 12)
>> #144: FILE: drivers/scsi/sg.c:375:
>> + if (excl || sfds_list_empty(sdp))
>> + wake_up_interruptible(&sdp->open_wait);
>>
>
> I'd prefer people to test the patch or find logical flaws.
>
> Doug Gilbert
>
Hi Doug,

Will the lines below conflict with the meaning of NONBLOCK?
 >+ down(&sdp->or_sem);
 >+ alone = sfds_list_empty(sdp);
 > if (!((flags & O_NONBLOCK) ||
 > scsi_block_when_processing_errors(sdp->device))) {

Assume one thread holds the or_sem and waiting in 
scsi_block_when_processing_errors for the underlying scsi device to 
complete error recovery,
another thread with O_NONBLOCK call sg_open().

I'm also curious why we can skip checking _processing_errors() when 
called with O_NONBLOCK?...Though it has been there from the very beginning.
In other words, since scsi device may go into a error recovery state at 
random time, why we only check here?

Thanks,
Vaughan

