Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab3I3CUk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 22:20:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1078 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab3I3CUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 22:20:38 -0400
X-IronPort-AV: E=Sophos;i="4.90,1006,1371052800"; 
   d="scan'208";a="8658199"
Message-ID: <5248DFC8.7060800@cn.fujitsu.com>
Date: Mon, 30 Sep 2013 10:19:52 +0800
From: chaiwen <chaiw.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: vaughan <vaughan.cao@oracle.com>
CC: Jeff Moyer <jmoyer@redhat.com>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, alexey.kodanev@oracle.com
Subject: Re: [PATCH v2] block: register_blkdev doesn't check name against
 NULL
References: <1378809614-17490-1-git-send-email-vaughan.cao@oracle.com> <1378866250-22679-1-git-send-email-vaughan.cao@oracle.com> <x49mwn3y4bo.fsf@segfault.boston.devel.redhat.com> <5247CECC.9050003@oracle.com>
In-Reply-To: <5247CECC.9050003@oracle.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/30 10:18:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/30 10:18:45,
	Serialize complete at 2013/09/30 10:18:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2013 02:55 PM, vaughan wrote:
> On 09/23/2013 10:56 PM, Jeff Moyer wrote:
>> Vaughan Cao<vaughan.cao@oracle.com>  writes:
>>
>>> register_blkdev(0, NULL) can result kernel Oops by copying from NULL
>>> in strlcpy(). Fix it by checking NULL pointer at the beginning and
>>> WARN when encountered in unregister_blkdev.
>> Uhh, so yeah, this is an exported function, so I could see maybe wanting
>> to do the argument checking.  But honestly, if your driver can't even
>> get this right, is there any hope of it actually working?
>>
>> This seems like a pointless patch to me, but ultimately it's up to Jens.
>>
>> Cheers,
>> Jeff
>>
>> p.s. the kerneldoc tells you what to put there:
>>   * @name: the name of the new block device as a zero terminated string
> Thanks for your comment, Jeff. I have the same feeling as you, however,
> shouldn't kernel do its best to provide the maximum stable working ability?
> And it's test case 7 of block driver in ltp project -
> http://sourceforge.net/p/ltp/git/ci/master/tree/testcases/kernel/device-drivers/block/kernel_space/test_block.c.
> It seems their attitude is we should check this.
I checked most of the callers of this function in current code tree.
Indeed, mostly they pass a static string as a parameter.
As jeff has said if a driver wants to get things right, it should able to
give  right parameters.
But as an acknowledge of kernel code protocol, I have a query/question of
the similar situation. if a function is a public one and called rather 
commonly.
In what cases should we have a parameter checking in it?
I think if the parameter is a rather obvious one that  even a look at it 
in the caller telling OK or not.
These parameters may not  need checking.

thanks
chai wen
>
> Vaughan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

