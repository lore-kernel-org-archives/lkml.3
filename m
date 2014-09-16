Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaIPD7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 23:59:50 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:57125 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753917AbaIPD7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 23:59:49 -0400
X-IronPort-AV: E=Sophos;i="5.04,533,1406563200"; 
   d="scan'208";a="36005062"
Message-ID: <5417B283.10702@cn.fujitsu.com>
Date: Tue, 16 Sep 2014 11:46:11 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Chao Yu <chao2.yu@samsung.com>
CC: "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Changman Lee'" <cm224.lee@samsung.com>,
        <linux-f2fs-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [f2fs-dev][PATCH 4/5] f2fs: fix to clean previous mount option
 when remount_fs
References: <003001cfd0cc$96f9e8e0$c4edbaa0$@samsung.com> <54179768.2010708@cn.fujitsu.com> <00a001cfd15b$30bdadc0$92390940$@samsung.com>
In-Reply-To: <00a001cfd15b$30bdadc0$92390940$@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 11:05 AM, Chao Yu wrote:

> Hi Gu,
> 
>> -----Original Message-----
>> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
>> Sent: Tuesday, September 16, 2014 9:51 AM
>> To: Chao Yu
>> Cc: Jaegeuk Kim; Changman Lee; linux-f2fs-devel@lists.sourceforge.net;
>> linux-kernel@vger.kernel.org
>> Subject: Re: [f2fs-dev][PATCH 4/5] f2fs: fix to clean previous mount option when remount_fs
>>
>> Hi Yu,
>> On 09/15/2014 06:04 PM, Chao Yu wrote:
>>
>>> In manual of mount, we descript remount as below:
>>>
>>> "mount -o remount,rw /dev/foo /dir
>>> After  this call all old mount options are replaced and arbitrary stuff from
>>> fstab is ignored, except the loop= option which is internally generated and
>>> maintained by the mount command."
>>>
>>> Previously f2fs do not clear up old mount options when remount_fs, so we have no
>>> chance of disabling previous option (e.g. flush_merge). Fix it.
>>
>> Please don't.
>> "Remount" should just change what you specified and keep others unchanged.
> 
> Actually, there are two kinds of different 'remount', they are all specified in
> manual of mount.
> 1) mount -o remount,rw /dev/foo /dir
> 2) mount -o remount,rw  /dir

Thanks for your reminder, I confused them.

Regards,
Gu

> 
> I think 'remount' in your description is the second kind, being different from the
> first kind in description of this patch, for the second kind remount, 'mount' command
> can keep old options by loading them from mtab/fstab then merge them with new
> specified options.
> 
> Thanks,
> Yu
> 
>> The problem here is that we need to provide mount opts for disable/enable
>> some features, but we missed it. So the right way is adding these opts if
>> we really need them.
>>
>> Thanks,
>> Gu
>>
>>>
>>> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
>>> ---
>>>  fs/f2fs/super.c | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
>>> index 54444bb..90fcbe0 100644
>>> --- a/fs/f2fs/super.c
>>> +++ b/fs/f2fs/super.c
>>> @@ -616,6 +616,9 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
>>>  	org_mount_opt = sbi->mount_opt;
>>>  	active_logs = sbi->active_logs;
>>>
>>> +	sbi->mount_opt.opt = 0;
>>> +	sbi->active_logs = NR_CURSEG_TYPE;
>>> +
>>>  	/* parse mount options */
>>>  	err = parse_options(sb, data);
>>>  	if (err)
> 
> 
> .
> 


