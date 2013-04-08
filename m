Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935998Ab3DHNpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 09:45:33 -0400
Received: from mx2.parallels.com ([199.115.105.18]:36382 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934619Ab3DHNpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 09:45:31 -0400
Message-ID: <5162CA21.4060108@parallels.com>
Date: Mon, 8 Apr 2013 17:46:09 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Li Zefan <lizefan@huawei.com>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
        <lpoetter@redhat.com>, <linux-kernel@vger.kernel.org>,
        <jpoimboe@redhat.com>, <dhaval.giani@gmail.com>,
        <workman-devel@redhat.com>
Subject: Re: cgroup: status-quo and userland efforts
References: <20130406012159.GA17159@mtj.dyndns.org>
In-Reply-To: <20130406012159.GA17159@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2013 05:21 AM, Tejun Heo wrote:
> Hello, guys.
> 
Hello Tejun, how are you?

>  Status-quo
>  ==========
> 
tl;did read;

This is mostly sensible. There is still one problem that we hadn't yet
had the bandwidth to tackle that should be added to your official TODO list.

The cpu cgroup needs a real-time timeslice to accept real time tasks. It
defaults to 0, meaning that a newly created cpu cgroup cannot accept
tasks (rt tasks) without the user having to manually configure it.
As far as I know, this problem hasn't yet been fixed.

The fix of course, is as trivial as setting a new value instead of 0 as
a default. The complication lies in determining which value should that be.

There are many things that we should ask from a controller to implement
in order to be able to handle fully joint hierarchies. One of them,
IMHO, is that if you drop a task into a newly created cgroup it should
run without the user having to do anything for it.


