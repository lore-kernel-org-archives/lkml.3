Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbaDSXsS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 19:48:18 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:65535 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbaDSXro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 19:47:44 -0400
Date: Sat, 19 Apr 2014 19:47:40 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH 5/9 V2] idr: covert BUG_ON() to WARN_ON_ONCE() if the
 argument is invalid.
Message-ID: <20140419234740.GD3277@htj.dyndns.org>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
 <1397907496-5993-1-git-send-email-laijs@cn.fujitsu.com>
 <1397907496-5993-6-git-send-email-laijs@cn.fujitsu.com>
 <20140419130726.GC3277@htj.dyndns.org>
 <CACvQF52jWM1LFQGYZFyktCubt6YWdCx6kd3+aCW=3mCpzCR1Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF52jWM1LFQGYZFyktCubt6YWdCx6kd3+aCW=3mCpzCR1Mw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Apr 19, 2014 at 10:04:06PM +0800, Lai Jiangshan wrote:
> On Sat, Apr 19, 2014 at 9:07 PM, Tejun Heo <tj@kernel.org> wrote:
> WARN_ON_ONCE() for invalid id (negative id).
> idr_remove_warning() for unallocated id.

I don't know.  Seem like an unnecessary distinction.

> >> @@ -1030,6 +1030,9 @@ void ida_remove(struct ida *ida, int id)
> >>       int n;
> >>       struct ida_bitmap *bitmap;
> >>
> >> +     if (WARN_ON_ONCE(id < 0))
> >> +             return;
> >
> > Why not jump to err?
> 
> WARN_ON_ONCE() for invalid id (negative id).
> "goto err" for unallocated id.

Ditto.

Thanks.

-- 
tejun
