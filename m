Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbaIJFVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 01:21:08 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:44507 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaIJFVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 01:21:06 -0400
MIME-Version: 1.0
In-Reply-To: <5074996.Ni2JIb7nJr@vostro.rjw.lan>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
	<20140909151655.GB4851@dhcp22.suse.cz>
	<20140909152336.GB8890@mtj.dyndns.org>
	<5074996.Ni2JIb7nJr@vostro.rjw.lan>
Date: Tue, 9 Sep 2014 22:21:05 -0700
Message-ID: <CAM_iQpXo+6ANUe_x96rS5nehK+S3B9iOBU9szc8WQ4nzV7gnRA@mail.gmail.com>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
From: Cong Wang <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 1:48 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Wednesday, September 10, 2014 12:23:36 AM Tejun Heo wrote:
>> On Tue, Sep 09, 2014 at 05:16:55PM +0200, Michal Hocko wrote:
>> > But OOM killer doesn't kill kernel threads as they do not own any
>> > memory. So the check should be safe, no?
>>
>> Even for userland tasks, try_to_freeze() can currently be anywhere in
>> the kernel.  The frequently used ones are few but there are some odd
>> ones out, and, again, there's nothing enforcing any structure on
>> try_to_freeze() usage.  The other thing is that we may do quite a bit
>> during exiting including allocating memory.  Are those safe for system
>> PM?  Rafael, what exactly are the rules for PM?  What shouldn't
>> change?
>
> We can't make any assumptions regarding the availability of any devices.
> That is, whatever can end up in device access may potentially fail.
>

So we still have to rule out PM freeze, right?

I am thinking about adding a new task flag or adding a new parameter
to __refrigerator() to distinguish PM freeze with cgroup freeze. Will try
to code tomorrow.

Thanks!
