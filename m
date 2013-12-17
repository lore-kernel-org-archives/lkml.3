Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3LQJcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:32:10 -0500
Received: from m59-178.qiye.163.com ([123.58.178.59]:48183 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab3LQJcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:32:04 -0500
Message-ID: <52B019F5.7020505@ubuntukylin.com>
Date: Tue, 17 Dec 2013 17:31:33 +0800
From: Li Wang <liwang@ubuntukylin.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Matthew Wilcox <matthew@wil.cx>, Cong Wang <xiyou.wangcong@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Sage Weil <sage@inktank.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: Re: [PATCH 0/5] VFS: Directory level cache cleaning
References: <cover.1387205337.git.liwang@ubuntukylin.com> <CAM_iQpUSX1yX9SMvUnbwZ7UkaBMUheOEiZNaSb4m8gWBQzzGDQ@mail.gmail.com> <52AFC020.10403@ubuntukylin.com> <20131217035847.GA10392@parisc-linux.org> <52AFFBE3.8020507@ubuntukylin.com> <52B01594.80001@huawei.com>
In-Reply-To: <52B01594.80001@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUlNVUNLQkJCQk9NTkJPSUhDSFdZCQ4XHghZQV
	koKz0kKDQ9Lz06MjckMjUkMz46Pz4pQUtVS0A2IyQiPigkMjUkMz46Pz4pQUtVS0ArLykkNTQkMj
	UkMz46Pz4pQUlVS0A4NC41LykiJDg1QUtVS0ApPjwyNDUkOigyOkFLVUtAKyk0LTI1OD4kMy41Oj
	VBS1VLQD8iNTo2MjgkMiskNTQkMjUkMz46Pz4pQUtVS0ApPjo3JDIrJDI1JCk5NyQyNSQzPjo*Pi
	lBSklVS0A2LjcvMiQpOCsvJD8yPT0#KT41LyQyNSQzPjo*PilBSVVLQDIrJC80PzoiJDg1LyRLJE
	pLS0FLVUtAMiskTiQ2MjUuLz4kODUvJEskSktBS1VLQDIrJEokNjI1Li8#JDg1LyRLJEpLQUtVS0
	AyKyRKJDM0LikkODUvJEskSktLQUtVS0AyKyRISyQ2MjUuLz4kODUvJEskTktBS1VLQD86Lz4kMj
	U9NCQyNSQ4NDUvPjUvJD00NC8#KUFIVUtANTQvJD06NjQuKCQ*NDY6MjUkKCs9JD06MjdBSktVS0
	A9NSQ2OiIkT0pCJDM3MSRKJEtDS0hLT0FLVUhIQD0rJCk#JD0sJDM3MSRLQ0tIS01BVkxVTkAoLj
	kkPkFKVU5OQD01JCguOSQ#NSw0KT8oJDM3MSRKS0tJS0pBS1VJQ0A9NSQ5Mi9MJDM3MSRLTEpJS0
	lBSFVKTlkG
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENM
	SUxJTElLTEhMVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUhIS0o3V1kSC1lBWU1KVUpDTFVOT1VCWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extension is just add-on extension. The original debugging
capability is still there, and more flexible debugging is now allowed.

On 2013/12/17 17:12, Li Zefan wrote:
> On 2013/12/17 15:23, Li Wang wrote:
>> If we do wanna equip fadvise() with directory level page cache cleaning,
>> this could be solved by invoking (inode_permission() || capable(CAP_SYS_ADMIN)) before manipulating the page cache of that inode.
>> We think the current extension to 'drop_caches' has a complete back
>> compatibility, the old semantics keep unchanged, and with add-on
>> features to do finer granularity cache cleaning should be also
>> desirable.
>>
>
> I don't think you can extend the drop_caches interface this way. It should
> be used for debuging only.
>
> commit 9d0243bca345d5ce25d3f4b74b7facb3a6df1232
> Author: Andrew Morton <akpm@osdl.org>
> Date:   Sun Jan 8 01:00:39 2006 -0800
>
>      [PATCH] drop-pagecache
>
>      Add /proc/sys/vm/drop_caches.  When written to, this will cause the kernel to
>      discard as much pagecache and/or reclaimable slab objects as it can.  THis
>      operation requires root permissions.
>
>      ...
>
>      This is a debugging feature: useful for getting consistent results between
>      filesystem benchmarks.  We could possibly put it under a config option, but
>      it's less than 300 bytes.
>
> Also see http://lkml.org/lkml/2013/7/26/230
>
