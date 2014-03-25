Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaCYAox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 20:44:53 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47953 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaCYAow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 20:44:52 -0400
Message-ID: <5330D15E.2000702@oracle.com>
Date: Mon, 24 Mar 2014 20:44:14 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fs: gpf in simple_setattr
References: <52CD762B.7020600@oracle.com> <53123D81.6080003@oracle.com> <20140303214040.GA15265@quack.suse.cz> <53166920.709@oracle.com> <20140305124536.GA32371@quack.suse.cz> <53189BF8.1010308@oracle.com> <531A7CFD.9030603@oracle.com> <20140310104350.GB28797@quack.suse.cz> <531DC89A.9010601@oracle.com> <53304451.7030800@oracle.com> <20140324214851.GB10057@quack.suse.cz>
In-Reply-To: <20140324214851.GB10057@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2014 05:48 PM, Jan Kara wrote:
>> >[  339.948946] ** 4194304 ffff8805ac03ba38 [eventpoll] ffff8806ec051fe0
>> >[eventpoll] ffffffff84666040 ffff88056c73e7b0           (null)
>    OK, great. So finally we have something useful. We know we have problems
> with [eventpoll] dentry. That is actually a special filesystem not mounted
> anywhere - likely you get to that dentry through/proc/<pid>/fd/. Now
> eventpoll is interesting because it uses single anon inode for all
> eventpoll instances. And that inode should stay in place as long as
> eventpoll filesystem exists. So it's not clear how come that inode is
> freed. The basic check of handling of inode use count didn't find anything
> suspicious. But I can check in more detail and if I fail, we now have a
> pretty narrow area where to look...

Seems like it's not specific to eventpoll, I saw the same error message with
"eventfd" and "perf_event".


Thanks,
Sasha
