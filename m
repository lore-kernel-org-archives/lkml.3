Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab3BSMn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:43:29 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:30247 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932712Ab3BSMn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:43:28 -0500
Message-ID: <51237362.201@huawei.com>
Date: Tue, 19 Feb 2013 20:43:14 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: <gnehzuil.liu@gmail.com>
CC: <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>, <andi@firstfloor.org>,
        Wuqixuan <wuqixuan@huawei.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        <gregkh@linuxfoundation.org>
Subject: Re: [RFC][PATCH] vfs: always protect diretory file->fpos with inode
 mutex
References: <5122D3E0.6070800@huawei.com> <20130219123344.GA18350@gmail.com>
In-Reply-To: <20130219123344.GA18350@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/2/19 20:33, Zheng Liu wrote:
> On Tue, Feb 19, 2013 at 09:22:40AM +0800, Li Zefan wrote:
>> There's a long long-standing bug...As long as I don't know when it dates
>> from.
>>
>> I've written and attached a simple program to reproduce this bug, and it can
>> immediately trigger the bug in my box. It uses two threads, one keeps calling
>> read(), and the other calling readdir(), both on the same directory fd.
> 
> Hi Zefan,
> 
> Out of curiosity, why do you call read(2) on a directory fd?  I only
> open(2) a directory in order to execute a flush operation to make sure
> that a file is really created.
> 

Because something wrong happened in userspace programs.

After a thread closed a socket, another thread is still reading data from
this socket, but the socket fd has been re-used for opening directory for
readdir()!

