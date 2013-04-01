Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739Ab3DAVVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 17:21:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39951 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758587Ab3DAVVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 17:21:45 -0400
Date: Mon, 1 Apr 2013 22:21:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Yet another pipe related oops.
Message-ID: <20130401212142.GD21522@ZenIV.linux.org.uk>
References: <20130312130614.GA32237@ZenIV.linux.org.uk>
 <CA+55aFyPUYiFoiLrMCzeHpbAgAignCe_awU7SbvPh+T6eHeqng@mail.gmail.com>
 <20130312194353.GI21522@ZenIV.linux.org.uk>
 <CA+55aFx-8TrSSJZM-WTDN4Hc3pESLXBsGC9x3xVaxuwxnGKqpA@mail.gmail.com>
 <20130327135127.GB1738@redhat.com>
 <20130327152030.GY21522@ZenIV.linux.org.uk>
 <CA+55aFx=BPQ2empEahqCs2hQ=sRaw3OjJotrS6OMT3e6tUVMLQ@mail.gmail.com>
 <20130327174506.GZ21522@ZenIV.linux.org.uk>
 <20130401203445.GA20862@ZenIV.linux.org.uk>
 <20130401210029.GA3245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130401210029.GA3245@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 02:00:29PM -0700, Greg Kroah-Hartman wrote:

> > IOW, how do we deal with a race between attempt to open a debugfs file and
> > its removal on driver unload?  Greg?
> 
> Hm, I thought the i_fop->owner thing would be the needed protection, but

It will be, if you manage to fetch it...

> I guess you are right, it will not.  I guess we need to do what
> character devices do and have an "intermediate" fops in order to protect
> this.  Would that work?

You mean, with reassigning ->f_op in ->open()?  That'll work, as long as
we have exclusion between removal and fetching the sucker in primary
->open()...  Where would you prefer to stash fops?
