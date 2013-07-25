Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab3GYP3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:29:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50116 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab3GYP3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:29:41 -0400
Message-ID: <51F144F4.4090509@oracle.com>
Date: Thu, 25 Jul 2013 23:32:04 +0800
From: vaughan <vaughan.cao@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: JBottomley@parallels.com
CC: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>, dgilbert@interlog.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        vaughan <vaughan.cao@oracle.com>
Subject: Re: [PATCH v5 0/4] [SCSI] sg: fix race condition in sg_open
References: <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com> <1374468033-8947-1-git-send-email-vaughan.cao@oracle.com> <20130722170338.GA15824@logfs.org>
In-Reply-To: <20130722170338.GA15824@logfs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 01:03 AM, Jörn Engel wrote:
> On Mon, 22 July 2013 12:40:29 +0800, Vaughan Cao wrote:
>> There is a race when open sg with O_EXCL flag. Also a race may happen between
>> sg_open and sg_remove.
>>
>> Changes from v4:
>>  * [3/4] use ERR_PTR series instead of adding another parameter in sg_add_sfp
>>  * [4/4] fix conflict for cherry-pick from v3.
>>
>> Changes from v3:
>>  * release o_sem in sg_release(), not in sg_remove_sfp().
>>  * not set exclude with sfd_lock held.
>>
>> Vaughan Cao (4):
>>   [SCSI] sg: use rwsem to solve race during exclusive open
>>   [SCSI] sg: no need sg_open_exclusive_lock
>>   [SCSI] sg: checking sdp->detached isn't protected when open
>>   [SCSI] sg: push file descriptor list locking down to per-device
>>     locking
>>
>>  drivers/scsi/sg.c | 178 +++++++++++++++++++++++++-----------------------------
>>  1 file changed, 83 insertions(+), 95 deletions(-)
> Patchset looks good to me, although I didn't test it on hardware yet.
> Signed-off-by: Joern Engel <joern@logfs.org>
>
> James, care to pick this up?
>
> Jörn
Hi James,

sg driver has two races happen in
 a) exclusive open and non-exclusive open
 b) sg removal and sg open
I explained the scenario detail in the separate patches. I did test
those patches and
Jörn has reviewed them.  I got no response from Doug Gilbert for a long
time.
Would you care to pick these up?

Thanks,
Vaughan

>
> --
> Good warriors cause others to come to them and do not go to others.
> -- Sun Tzu

