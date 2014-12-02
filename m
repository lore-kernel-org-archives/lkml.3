Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaLBIks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:40:48 -0500
Received: from mail.windriver.com ([147.11.1.11]:63497 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaLBIkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:40:47 -0500
Message-ID: <547D7B05.50406@windriver.com>
Date: Tue, 2 Dec 2014 16:40:37 +0800
From: zhangxiao <xiao.zhang@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dm-devel@redhat.com>
Subject: Re: The DM_BUFIO_HASH_BITS is defined as 20, any plan to make it
 flexible?
References: <547D790E.3070803@windriver.com> <20141202193618.6d3adb22@notabene.brown>
In-Reply-To: <20141202193618.6d3adb22@notabene.brown>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.163.132]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年12月02日 16:36, NeilBrown wrote:
> On Tue, 2 Dec 2014 16:32:14 +0800 zhangxiao <xiao.zhang@windriver.com> wrote:
>
>> Hi NeilBrown,
>>
>> See drivers/md/dm-bufio.c as below:
>>     50 /*
>>     51  * Buffer hash
>>     52  */
>>     53 #define DM_BUFIO_HASH_BITS      20
>>     54 #define DM_BUFIO_HASH(block) \
>>     55         ((((block) >> DM_BUFIO_HASH_BITS) ^ (block)) & \
>>     56          ((1 << DM_BUFIO_HASH_BITS) - 1))
>> "drivers/md/dm-bufio.c" 1854L, 45375C
>>
>>
>> DM_BUFIO_HASH_BITS was defined as 20 and it maybe not fit for some
>> use case with limited resources. Do we have any plan to make it more
>> flexible? Like module parameter or something else?
>>
>
> Thanks, but this question should be address to:
>
Thank you for your kindly remind. :-)

Regards
Xiao

> DEVICE-MAPPER  (LVM)
> M:	Alasdair Kergon <agk@redhat.com>
> M:	Mike Snitzer <snitzer@redhat.com>
> M:	dm-devel@redhat.com
> L:	dm-devel@redhat.com
> W:	http://sources.redhat.com/dm
> Q:	http://patchwork.kernel.org/project/dm-devel/list/
> T:	git git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
> T:	quilt http://people.redhat.com/agk/patches/linux/editing/
> S:	Maintained
> F:	Documentation/device-mapper/
> F:	drivers/md/dm*
> F:	drivers/md/persistent-data/
> F:	include/linux/device-mapper.h
> F:	include/linux/dm-*.h
> F:	include/uapi/linux/dm-*.h
>
> NeilBrown
>
