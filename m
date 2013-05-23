Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462Ab3EWUv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 16:51:58 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:47023 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759397Ab3EWUvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 16:51:54 -0400
Message-ID: <519E8163.8070402@hp.com>
Date: Thu, 23 May 2013 16:51:47 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: remaper <yp.fangdong@gmail.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ian Kent <raven@themaw.net>,
        Sage Weil <sage@inktank.com>, Steve French <sfrench@samba.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Eric Paris <eparis@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        autofs <autofs@vger.kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Andi Kleen <andi@firstfloor.org>, Dave Chinner <david@fromorbit.com>
Subject: Re: =?gb18030?Q?=BB=D8=B8=B4=A3=BA=5BPATCH_1/3_v3=5D_dcach?=
 =?gb18030?Q?e=3A_Don=27t_take_unnecessary_lock_in_d=5Fcount_?=
 =?gb18030?Q?update?=
References: <tencent_6519A7723A666F8378EE1517@qq.com>
In-Reply-To: <tencent_6519A7723A666F8378EE1517@qq.com>
Content-Type: text/plain; charset=gb18030; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 05:09 AM, remaper wrote:
> maybe you can use the atomic_dec_and_lock(&dentry->d_count,&dentry->d_lock) here, right ?
>
> ------------------ Origin ------------------
>> The current code takes the dentry's d_lock lock whenever the d_count
>> reference count is being updated. In reality, nothing big really
>> happens until d_count goes to 0 in dput(). So it is not necessary to
>> take the lock if the reference count won't go to 0.
Thank for the suggestion.

First of all, the d_count field is not an atomic type. Changing it to 
atomic will require touching quite a large number of source files even 
though that change won't change the size of the dentry. Secondly, the 
function internally uses cmpxchg to do its work. There isn't any 
performance  advantage of using it. I also need the count to go in both 
direction, not just going down.

Regards,
Longman
