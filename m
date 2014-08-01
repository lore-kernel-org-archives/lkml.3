Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaHAPST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 11:18:19 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:36209 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaHAPSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 11:18:18 -0400
Date: Fri, 1 Aug 2014 11:18:14 -0400
From: Tejun Heo <tj@kernel.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jianyu Zhan <Jianyu.Zhan@emc.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH RFC] sysfs: fix the race of "parent deleted before child
 added"
Message-ID: <20140801151814.GF21624@htj.dyndns.org>
References: <1406891892-10992-1-git-send-email-nasa4836@gmail.com>
 <20140801125045.GA21624@htj.dyndns.org>
 <CAHz2CGXpG2RYNkWHdoj947HUD6ns-CwkOH82n2DJ8cegEogHQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHz2CGXpG2RYNkWHdoj947HUD6ns-CwkOH82n2DJ8cegEogHQw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Dan)

Hello, Jianyu, Dan.

On Fri, Aug 01, 2014 at 10:31:00PM +0800, Jianyu Zhan wrote:
> The problem I met is in an old kernel, in sysfs_create_dir(),  at thie line:

Which old kernel?

>    sysfs_create_dir()
>        if (kobj->parent)
>             parent = kobj->parent->sd;
> 
> I found kobj->parent is valid, so parent == kobj->parent->sd,
> then it is passed into create_dir() function, in which it is dereferenced,
> however  the parent passed in is NULL, so a panic.

Which node?

> Apprently, there is a race, as my case is a test of fast removal and plugging
> of a block device.
> 
> The race is that the kerfs_node(was sysfs_dirent) is disassociated with
> parent kobject, but parent kobject is still alive, so we saw it.

What is the race condition?  You're just describing symptoms.

> And the commit 3a198886 ("sysfs: handle 'parent deleted before child added'")
> add a parent NULLness check before calling into create_dir(),  but I think this
> isn't the real fix, it just narrow down the racy window.

Suspicions aren't good enough justifications.  If you think there's a
race window, please track it down and then determine what the proper
fix is.  You're now trying to change the basic objection lifetime
rules of the driver model without root causing what's actually going
on.  Please don't do things like this.

Thanks.

-- 
tejun
