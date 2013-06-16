Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3FPB5s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 21:57:48 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:65391 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab3FPB5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 21:57:46 -0400
Message-ID: <51BD1B84.9080402@huawei.com>
Date: Sun, 16 Jun 2013 09:57:24 +0800
From: shencanquan <shencanquan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:6.0.1) Gecko/20110830 Thunderbird/6.0.1
MIME-Version: 1.0
To: Richard Yao <ryao@gentoo.org>
CC: Jeff Liu <jeff.liu@oracle.com>, Mark Fasheh <mfasheh@suse.com>,
        <linux-kernel@vger.kernel.org>, <kernel@gentoo.org>,
        <linux-fsdevel@vger.kernel.org>,
        Ocfs2-Devel <ocfs2-devel@oss.oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH 1/2] ocfs2: Fix llseek() semantics and do
 some cleanup
References: <1371237814-59365-1-git-send-email-ryao@gentoo.org> <1371237814-59365-2-git-send-email-ryao@gentoo.org> <51BBF6FE.6080502@oracle.com> <51BC080D.1090405@huawei.com> <51BD0A66.4070003@gentoo.org>
In-Reply-To: <51BD0A66.4070003@gentoo.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.66.129]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/16 8:44, Richard Yao wrote:
> On 06/15/2013 02:22 AM, shencanquan wrote:
>> Hello, Richard and Jeff,
>>     we found that llseek has another bug when in SEEK_END.  it should be
>> add the inode lock and unlock.
>>     this bug can be reproduce the following scenario:
>>     on one nodeA, open the file and then write some data to file and
>> close the file .
>>     on  another nodeB , open the file and llseek the end of file . the
>> position of file is old.
> Did these operations occur sequentially or did they occur concurrently?
>
> If you meant the former, the inode cache is not being invalidated. That
> should be a bug because Oracle claims OCFS2 is cache-coherent. However,
> it is possible that this case was left out of the cache-coherence
> protocol for performance purposes. If that is the case, then this would
> be by design. someone who works for Oracle would need to comment on that
> though.

    it is a occur sequentially.  after close the file on NodeA , on 
nodeB and then open the file and llseek the end of file.

>
> If you meant the latter, you should ask yourself what would happen when
> you run two separate programs on the same file in a local filesystem.
> There should be no way to avoid a race without some kind of a locking
> mechanism.
>


