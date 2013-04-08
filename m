Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964817Ab3DHS1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:27:00 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:39147 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935556Ab3DHS06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:26:58 -0400
Date: Mon, 8 Apr 2013 11:26:49 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        lpoetter@redhat.com, linux-kernel@vger.kernel.org, jpoimboe@redhat.com,
        dhaval.giani@gmail.com, workman-devel@redhat.com
Subject: Re: cgroup: status-quo and userland efforts
Message-ID: <20130408182649.GJ3021@htj.dyndns.org>
References: <20130406012159.GA17159@mtj.dyndns.org>
 <5162CA21.4060108@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5162CA21.4060108@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Glauber.

On Mon, Apr 08, 2013 at 05:46:09PM +0400, Glauber Costa wrote:
> On 04/06/2013 05:21 AM, Tejun Heo wrote:
> > Hello, guys.
>
> Hello Tejun, how are you?

I'm doing okay.  :)

> >  Status-quo
> >  ==========
> > 
> tl;did read;
> 
> This is mostly sensible. There is still one problem that we hadn't yet
> had the bandwidth to tackle that should be added to your official TODO list.
> 
> The cpu cgroup needs a real-time timeslice to accept real time tasks. It
> defaults to 0, meaning that a newly created cpu cgroup cannot accept
> tasks (rt tasks) without the user having to manually configure it.
> As far as I know, this problem hasn't yet been fixed.
> 
> The fix of course, is as trivial as setting a new value instead of 0 as
> a default. The complication lies in determining which value should that be.
> 
> There are many things that we should ask from a controller to implement
> in order to be able to handle fully joint hierarchies. One of them,
> IMHO, is that if you drop a task into a newly created cgroup it should
> run without the user having to do anything for it.

Yeap, definitely.  cpuset has similar problems (Li, help us!).  For
the controllers which are showing behaviors which don't allow sharing
a single hierarchy, I think the solution is to implement an alternate
behavior which can be flipped on mount time and force the switch
flipped when mounting unified hierarchy, so that we don't disturb the
existing users while pushing for more consistent behavior.

Thanks.

-- 
tejun
