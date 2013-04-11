Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161572Ab3DKPXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:23:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935788Ab3DKPXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:23:16 -0400
Date: Thu, 11 Apr 2013 11:23:08 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Message-ID: <1365693788-djsd2ymu-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20130411134915.GH16732@two.firstfloor.org>
References: <51662D5B.3050001@hitachi.com>
 <20130411134915.GH16732@two.firstfloor.org>
Subject: Re: [RFC Patch 0/2] mm: Add parameters to make kernel behavior at
 memory error on dirty cache selectable
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <20130411134915.GH16732@two.firstfloor.org>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 03:49:16PM +0200, Andi Kleen wrote:
> > As a result, if the dirty cache includes user data, the data is lost,
> > and data corruption occurs if an application uses old data.
> 
> The application cannot use old data, the kernel code kills it if it
> would do that. And if it's IO data there is an EIO triggered.
> 
> iirc the only concern in the past was that the application may miss
> the asynchronous EIO because it's cleared on any fd access. 
> 
> This is a general problem not specific to memory error handling, 
> as these asynchronous IO errors can happen due to other reason
> (bad disk etc.) 
> 
> If you're really concerned about this case I think the solution
> is to make the EIO more sticky so that there is a higher chance
> than it gets returned.  This will make your data much more safe,
> as it will cover all kinds of IO errors, not just the obscure memory
> errors.

I'm interested in this topic, and in previous discussion, what I was said
is that we can't expect user applications to change their behaviors when
they get EIO, so globally changing EIO's stickiness is not a great approach.
I'm working on a new pagecache tag based mechanism to solve this.
But it needs time and more discussions.
So I guess Tanino-san suggests giving up on dirty pagecache errors
as a quick solution.

Thanks,
Naoya
