Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3F0VE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 17:04:56 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:63652 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab3F0VEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 17:04:55 -0400
Date: Thu, 27 Jun 2013 14:04:45 -0700
From: Tejun Heo <tj@kernel.org>
To: Tim Hockin <thockin@hockin.org>
Cc: Li Zefan <lizefan@huawei.com>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>, bsingharora <bsingharora@gmail.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, jpoimboe <jpoimboe@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dawnchen@google.com
Subject: Re: cgroup: status-quo and userland efforts
Message-ID: <20130627210445.GA22860@mtj.dyndns.org>
References: <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
 <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
 <20130625000118.GT1918@mtj.dyndns.org>
 <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
 <20130626212047.GB4536@htj.dyndns.org>
 <CAAAKZws1qkSik4G4pRr7z+067Jp9-jHfpx9-euqbvmdHjoN_Zg@mail.gmail.com>
 <20130627010427.GF4536@htj.dyndns.org>
 <CAAAKZwsMT7FRccyVxSn77GR8+9JsSeqmDO6oOy7ycNCY7Desnw@mail.gmail.com>
 <20130627173809.GB5599@mtj.dyndns.org>
 <CAAAKZwvabGRsce43ymru7OBr0LX93DRnTVkzn-nhahTR6yMUZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAKZwvabGRsce43ymru7OBr0LX93DRnTVkzn-nhahTR6yMUZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 27, 2013 at 01:46:18PM -0700, Tim Hockin wrote:
> So what you're saying is that you don't care that this new thing is
> less capable than the old thing, despite it having real impact.

Sort of.  I'm saying, at least up until now, moving away from
orthogonal hierarchy support seems to be the right trade-off.  It all
depends on how you measure how much things are simplified and how
heavy the "real impacts" are.  It's not like these things can be
determined white and black.  Given the current situation, I think it's
the right call.

> If controller C is enabled at level X but disabled at level X/Y, does
> that mean that X/Y uses the limits set in X?  How about X/Y/Z?

Y and Y/Z wouldn't make any difference.  Tasks belonging to them would
behave as if they belong to X as far as C is concerened.

> So take away some of the flexibility that has minimal impact and
> maximum return.  Splitting threads across cgroups - we use it, but we
> could get off that.  Force all-or-nothing joining of an aggregate

Please do so.

> construct (a container vs N cgroups).
> 
> But perform surgery with a scalpel, not a hatchet.

As anything else, it's drawing a line in a continuous spectrum of
grey.  Right now, given that maintaining multiple orthogonal
hierarchies while introducing a proper concept of resource container
involves addition of completely new constructs and complexity, I don't
think that's a good option.  If there are problems which can't be
resolved / worked around in a reasonable manner, please bring them up
along with their contexts.  Let's examine them and see whether there
are other ways to accomodate them.

Thanks.

-- 
tejun
