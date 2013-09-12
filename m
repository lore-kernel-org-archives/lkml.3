Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719Ab3ILDrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 23:47:22 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:44626 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab3ILDrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 23:47:21 -0400
Date: Wed, 11 Sep 2013 23:47:17 -0400
From: Tejun Heo <tj@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, kay@vrfy.org,
        netdev@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCHSET] sysfs: disentangle kobject namespace handling from
 sysfs
Message-ID: <20130912034717.GA4723@mtj.dyndns.org>
References: <1378952949-7900-1-git-send-email-tj@kernel.org>
 <87li324sng.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87li324sng.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 08:37:23PM -0700, Eric W. Biederman wrote:
> At a practical level you probably just want to copy the good parts of
> the structure of sysfs, instead of attempting to share code.
> 
> Sharing code is likely to get you into all kinds of problems with short
> term hacks.

What?  Are you kidding me?  This is one of the most basic principles
which should be followed.  The problem is not doing proper modular
design from the get-go.  You have it completely backwards.

> > I never really understood why namespace support was added the way it
> > was added.  Namespace information is communicated to sysfs via
> > callbacks and back-queries to upper layer, which is a very unusual and
> > weird thing to do when all the involved operations are synchronous.
> > For example, a tagged attribute creation looks like the following.
> 
> Then please ask.

I asked the first time around and the answer I got was basically "I
didn't want to go around updating differnet layers and adding stuffing
it in the ops struct is more convenient".  Do you have a better reason
now?

> I don't have the time or energy to review these right now, and given the
> sweeping nature of the patches, and the dismissive attitude of the
> original design there is almost at least one stupid bug if not something
> worse.
> 
> So until I have the energy to review these.
> 
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

No, you don't get to have a say without actually doing the review.
You sure can ask for more time to review stuff as long as it's
reasonable.  Why are things like this still not clear to you?  You
have been doing this long enough.

> I am sorry but I don't have time to clean up after any more people
> touching sysfs when the break something.  It does look like there are so
> possibly good things going on but..

If you wanna object, do it technically through proper review.  That's
how it works.

Thanks.

-- 
tejun
