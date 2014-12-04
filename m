Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbaLDB1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 20:27:47 -0500
Received: from mail.windriver.com ([147.11.1.11]:34854 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaLDB1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 20:27:46 -0500
Message-ID: <547FB83B.8080401@windriver.com>
Date: Thu, 4 Dec 2014 09:26:19 +0800
From: zhangxiao <xiao.zhang@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>,
        <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <agk@redhat.com>
Subject: Re: [dm-devel] The DM_BUFIO_HASH_BITS is defined as 20, any plan
 to make it flexible?
References: <547D7BC6.6070708@windriver.com> <20141202140015.GB5985@redhat.com> <20141203141921.GB6993@debian>
In-Reply-To: <20141203141921.GB6993@debian>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.163.132]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年12月03日 22:19, Joe Thornber wrote:
> On Tue, Dec 02, 2014 at 09:00:17AM -0500, Mike Snitzer wrote:
>> On Tue, Dec 02 2014 at  3:43am -0500,
>> zhangxiao <xiao.zhang@windriver.com> wrote:
>>
>>> Hi Experts,
>>>
>>> See drivers/md/dm-bufio.c as below:
>>>    50 /*
>>>    51  * Buffer hash
>>>    52  */
>>>    53 #define DM_BUFIO_HASH_BITS      20
>>>    54 #define DM_BUFIO_HASH(block) \
>>>    55         ((((block) >> DM_BUFIO_HASH_BITS) ^ (block)) & \
>>>    56          ((1 << DM_BUFIO_HASH_BITS) - 1))
>>> "drivers/md/dm-bufio.c" 1854L, 45375C
>>>
>>> DM_BUFIO_HASH_BITS was defined as 20 and it maybe not fit for some
>>> use case with limited resources. Do we have any plan to make it more
>>> flexible? Like module parameter or something else?
>>
>> No immediate plans.
>
> That hash table has been replaced with a red/black tree.
>
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.19&id=4e420c452b11edf9d510c8180ac66f529e5b6206
>
>
Great Thanks!

Best Regards
Xiao
