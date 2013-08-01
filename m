Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab3HAFBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 01:01:51 -0400
Received: from smtp.infotech.no ([82.134.31.41]:55501 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037Ab3HAFBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 01:01:50 -0400
Message-ID: <51F9EB97.7070305@interlog.com>
Date: Thu, 01 Aug 2013 01:01:11 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
        Vaughan Cao <vaughan.cao@oracle.com>, JBottomley@parallels.com
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/4] [SCSI] sg: fix race condition in sg_open
References: <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com> <1374468033-8947-1-git-send-email-vaughan.cao@oracle.com> <20130722170338.GA15824@logfs.org>
In-Reply-To: <20130722170338.GA15824@logfs.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-07-22 01:03 PM, Jörn Engel wrote:
> On Mon, 22 July 2013 12:40:29 +0800, Vaughan Cao wrote:
>>
>> There is a race when open sg with O_EXCL flag. Also a race may happen between
>> sg_open and sg_remove.
>>
>> Changes from v4:
>>   * [3/4] use ERR_PTR series instead of adding another parameter in sg_add_sfp
>>   * [4/4] fix conflict for cherry-pick from v3.
>>
>> Changes from v3:
>>   * release o_sem in sg_release(), not in sg_remove_sfp().
>>   * not set exclude with sfd_lock held.
>>
>> Vaughan Cao (4):
>>    [SCSI] sg: use rwsem to solve race during exclusive open
>>    [SCSI] sg: no need sg_open_exclusive_lock
>>    [SCSI] sg: checking sdp->detached isn't protected when open
>>    [SCSI] sg: push file descriptor list locking down to per-device
>>      locking
>>
>>   drivers/scsi/sg.c | 178 +++++++++++++++++++++++++-----------------------------
>>   1 file changed, 83 insertions(+), 95 deletions(-)
>
> Patchset looks good to me, although I didn't test it on hardware yet.
> Signed-off-by: Joern Engel <joern@logfs.org>
>
> James, care to pick this up?

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Tested O_EXCL with multiple processes and threads; passed.
sg driver prior to this patch had "leaky" O_EXCL logic
according to the same test. Block device passed.

James, could you clean this up:
   drivers/scsi/sg.c:242:6: warning: unused variable ‘res’ [-Wunused-variable]

Doug Gilbert


