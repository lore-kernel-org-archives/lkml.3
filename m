Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab3FMDNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 23:13:44 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:38481 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197Ab3FMDNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 23:13:42 -0400
Message-ID: <51B938D3.4000605@huawei.com>
Date: Thu, 13 Jun 2013 11:13:23 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: Tejun Heo <tj@kernel.org>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cl@linux-foundation.org>
Subject: Re: [PATCH 04/11] cgroup: use kzalloc() and list_del_init()
References: <1371070996-20613-1-git-send-email-tj@kernel.org> <1371070996-20613-5-git-send-email-tj@kernel.org> <51B93038.9010202@huawei.com> <20130613023831.GB10979@localhost>
In-Reply-To: <20130613023831.GB10979@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/13 10:38, Kent Overstreet wrote:
> On Thu, Jun 13, 2013 at 10:36:40AM +0800, Li Zefan wrote:
>> On 2013/6/13 5:03, Tejun Heo wrote:
>>> There's no point in using kmalloc() and list_del() instead of the
>>> clearing variants for trivial stuff.  We can live dangerously
>>> elsewhere.  Use kzalloc() and list_del_init() instead and drop 0
>>> inits.
>>>
>>
>> Do you mean we prefer list_del_init() than list_del() in general? Then
>> in which cases do we prefer list_del()?
> 
> IMO, list_del() is preferred when the object shouldn't be reused (i.e.
> it gets taken off a list and then it's freed).

yeah, this is what I have in my mind. I would wonder why list_del_init()
if I know that object won't be used anymore.

> list_del_init() could
> hide bugs.
> 

Same here. I do worry a bit about this.

