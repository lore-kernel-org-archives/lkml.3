Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaHPS6I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 14:58:08 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:39251 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbaHPS6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 14:58:06 -0400
MIME-Version: 1.0
In-Reply-To: <20140816122028.GC9305@htj.dyndns.org>
References: <1408050926-9525-1-git-send-email-xiyou.wangcong@gmail.com>
	<20140816122028.GC9305@htj.dyndns.org>
Date: Sat, 16 Aug 2014 11:58:05 -0700
Message-ID: <CAM_iQpVtuMw_yJDJ90LiUzNqL_UBBvrJf8Zd+erD7+iFCxiORg@mail.gmail.com>
Subject: Re: [Patch v3 1/2] freezer: check OOM kill while being frozen
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2014 at 5:20 AM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Aug 14, 2014 at 02:15:25PM -0700, Cong Wang wrote:
>> +static bool should_thaw_current(bool check_kthr_stop)
>> +{
>> +     if (!freezing(current) ||
>> +         (check_kthr_stop && kthread_should_stop()) ||
>> +         test_thread_flag(TIF_MEMDIE))
>> +             return true;
>> +     else
>> +             return false;
>> +}
>
> I'm not sure this is safe w.r.t. hibernation.  Please cc Rafael on
> freezer related changes.
>

Rafael has been Cc'ed from the beginning. :)

Rafael, any objection?
