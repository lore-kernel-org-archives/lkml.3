Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964956Ab3GRTHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:07:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52766 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964885Ab3GRTHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:07:08 -0400
Date: Thu, 18 Jul 2013 20:07:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nathan Rutman <nathan_rutman@xyratex.com>
Cc: Peng Tao <bergwolf@gmail.com>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [lustre mess] is mgc_fs_setup() reachable at all?
Message-ID: <20130718190703.GB4165@ZenIV.linux.org.uk>
References: <20130718090835.GZ4165@ZenIV.linux.org.uk>
 <CA+a=Yy49WfQVJAYybUzVvigi9b--kuagqKxBEH+yy0RZSKVnQA@mail.gmail.com>
 <5DD1CAAA-2008-47F9-B3B6-8D342B28D08C@xyratex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5DD1CAAA-2008-47F9-B3B6-8D342B28D08C@xyratex.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 11:40:16AM -0700, Nathan Rutman wrote:
> >>                }
> >>                RETURN(rc);
> >>        }
> >> What is going on here?  We cast something to struct super_block *?
> >> Where does it come from?  The function it's in is
> Well, addressing the "what's going on" question without getting into the larger philosophy,
> keys and values are used as a generic mechanism to pass various items between Lustre clients
> and servers.  In this case, a specific key should only have a value of "a superblock", and so this is 
> just a sanity check to make sure the value length is sane.  It should probably be more of an ASSERT,
> but we can't reasonably assert on remotely-supplied data.

What?  Excuse me, but have you seriously been intending to pass struct
super_block instances around?  Ones that are choke-full of pointers to
all kinds of things, not to mention a mutex, spinlock, etc.?

_THAT_ was going to be a remotely supplied data?  I really hope I've
misparsed what you said above...

And that still leaves the question about the code path that could lead to
execution of mgc_fs_setup().
