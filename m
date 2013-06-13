Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab3FMHQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 03:16:30 -0400
Received: from relay.parallels.com ([195.214.232.42]:48928 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab3FMHQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 03:16:29 -0400
Message-ID: <51B971A0.8050406@parallels.com>
Date: Thu, 13 Jun 2013 11:15:44 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Anand Avati <avati@redhat.com>
CC: <miklos@szeredi.hu>, <fuse-devel@lists.sourceforge.net>,
        <bfoster@redhat.com>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>
Subject: Re: [PATCH] fuse: hold i_mutex in fuse_file_fallocate()
References: <20130611105714.24455.38409.stgit@maximpc.sw.ru> <51B8C639.7060500@redhat.com>
In-Reply-To: <51B8C639.7060500@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anand, Brian,

06/12/2013 11:04 PM, Anand Avati пишет:
> On 6/11/13 3:59 AM, Maxim Patlasov wrote:
>
>> -    if (mode & FALLOC_FL_PUNCH_HOLE) {
>> +    if (lock_inode)
>>           mutex_lock(&inode->i_mutex);
>
>> +    if (mode & FALLOC_FL_PUNCH_HOLE)
>>           fuse_set_nowrite(inode);
>> -    }
>
> Just for clarity, can you make the condition to check 
> FALLOC_FL_PUNCH_HOLE and call to fuse_set_nowrite() nested within the 
> larger if (lock_inode) { .. } block? fuse_set_nowrite() should not be 
> called without i_mutex acquired. The current style of calling 
> mutex_lock() and fuse_set_nowrite() in separate conditions can 
> potentially cause bugs in the future if they were to get re-ordered 
> due to some unrelated patch. Nesting them makes the relation more 
> explicit and clear.

Thanks a lot for review. I'll post updated patch soon.

Thanks,
Maxim

