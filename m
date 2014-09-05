Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaIESAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 14:00:46 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:38945 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaIESAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 14:00:45 -0400
Date: Sat, 6 Sep 2014 03:00:40 +0900
From: Tejun Heo <tj@kernel.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140905180040.GC12991@mtj.dyndns.org>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <20140905140815.GA10455@mtj.dyndns.org>
 <CAM_iQpUJONZ7UWTzJoqsbYfHsp5HnRVR-mhpP_kvR3AUafELqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUJONZ7UWTzJoqsbYfHsp5HnRVR-mhpP_kvR3AUafELqQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 09:31:50AM -0700, Cong Wang wrote:
> On Fri, Sep 5, 2014 at 7:08 AM, Tejun Heo <tj@kernel.org> wrote:
> >> +     /* It might not be safe to check TIF_MEMDIE for pm freeze. */
> >
> > This is just another representation of the following code which isn't
> > particularly useful.  Wouldn't it be better if the comment actually
> > explains why this might not be safe?
> 
> I don't know actually, I never understand pm code, just don't
> want to take the risk of breaking it as you told. :)

Let's please try to understand and explain it properly.  Reading
intricate code like this w/ comment which doesn't really explain
anything can be very frustrating for other people reading the code.
Rafael, can you please help?

Shouldn't the primary goal of the comment be explaining why we need
TIF_MEMDIE check there at all anyway?  The deadlock possiblity is not
very obvious.

Thanks.

-- 
tejun
