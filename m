Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaFCBWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 21:22:17 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:54586 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaFCBWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 21:22:15 -0400
Date: Mon, 2 Jun 2014 21:22:11 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jianyu Zhan <nasa4836@gmail.com>
Subject: Re: 3.15 regression: wrong cgroup magic
Message-ID: <20140603012211.GE19855@htj.dyndns.org>
References: <CALCETrXbpiqwY=qyPcNWn2zX=vehXzBbxDG725egM9T2Ox2KTA@mail.gmail.com>
 <538D2261.70406@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538D2261.70406@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 09:18:25AM +0800, Li Zefan wrote:
> > commit 2bd59d48ebfb3df41ee56938946ca0dd30887312
> > Author: Tejun Heo <tj@kernel.org>
> > Date:   Tue Feb 11 11:52:49 2014 -0500
> > 
> >     cgroup: convert to kernfs
> > 
> > In particular, this piece:
> > 
> > -       sb->s_magic = CGROUP_SUPER_MAGIC;
> > 
> > The result is that cgroup shows up with the wrong magic number, so my
> > code goes "oh crap, cgroupfs isn't mounted" and fails.
> > 
> > I can change my code to hack around this, but I can imagine other
> > things getting tripped up.  Is there still time to fix this?
> > 
> 
> This should be fixed by "kernfs: move the last knowledge of sysfs out from kernfs".
> 
> It's in driver-core-next.
> 
> https://git.kernel.org/cgit/linux/kernel/git/gregkh/driver-core.git/commit/?h=driver-core-next&id=26fc9cd200ec839e0b3095e05ae018f27314e7aa

Right, I was writing about the same patch with a nagging sense of
deja-vu.  I should have noticed that this must go through
driver-core-linus not -next.  Sorry about that.

Linus, can you please cherry-pick the commit?

Thanks.

-- 
tejun
