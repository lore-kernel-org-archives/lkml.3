Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab3IFOTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:19:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab3IFOTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 10:19:02 -0400
Date: Fri, 6 Sep 2013 10:18:52 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ftrace 'failed to modify' bug when loading reiserfs.ko
Message-ID: <20130906141852.GA18708@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130906011924.GA7970@redhat.com>
 <20130905212834.605408a4@gandalf.local.home>
 <20130906013455.GA10073@redhat.com>
 <20130905214455.101c6347@gandalf.local.home>
 <20130906014859.GB10073@redhat.com>
 <20130905215154.74c55e9a@gandalf.local.home>
 <20130906035827.GA13446@redhat.com>
 <20130906093252.02c748f5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130906093252.02c748f5@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 09:32:52AM -0400, Steven Rostedt wrote:
 > On Thu, 5 Sep 2013 23:58:27 -0400
 > Dave Jones <davej@redhat.com> wrote:
 > 
 > > On Thu, Sep 05, 2013 at 09:51:54PM -0400, Steven Rostedt wrote:
 > >  > On Thu, 5 Sep 2013 21:48:59 -0400
 > >  > Dave Jones <davej@redhat.com> wrote:
 > >  > 
 > >  > > On Thu, Sep 05, 2013 at 09:44:55PM -0400, Steven Rostedt wrote:
 > >  > >  > On Thu, 5 Sep 2013 21:34:55 -0400
 > >  > >  > Dave Jones <davej@redhat.com> wrote:
 > >  > >  > 
 > >  > >  > > On Thu, Sep 05, 2013 at 09:28:34PM -0400, Steven Rostedt wrote:
 > >  > 
 > >  > >  > Did you change a config option, or update your gcc?
 > >  > > 
 > >  > > Yeah, changed CONFIG_DEBUG_KOBJECT, which rebuilt the world.
 > >  > 
 > >  > Still doesn't explain why it gave you that splat there.
 > >  > 
 > >  > Do you still have that binary module, and can you show me what's at
 > >  > reiserfs_init_bitmap_cache+0x0 with objdump?
 > > 
 > > I didn't, but it turns out I can recreate this. A little convoluted but..
 > > 
 > > disable DEBUG_KOBJECT_RELEASE
 > > build, install and boot into kernel
 > > 
 > > enable DEBUG_KOBJECT_RELEASE
 > > build kernel
 > > install -> boom
 > 
 > Did it report failing on the same function as before?
 
Yes.

 > > 00000000000028b0 <reiserfs_init_bitmap_cache>:
 > > 
 > >         return bh;
 > > }
 > > 
 > > int reiserfs_init_bitmap_cache(struct super_block *sb)
 > > {
 > >     28b0:       e8 00 00 00 00          callq  28b5 <reiserfs_init_bitmap_cache+0x5>
 > 
 > That looks to be the call to fentry, but without being resolved. What
 > we saw in the previous report wasn't 0xe8 but 0x14, and it was
 > unresolved after loading!
 > 
 > I'm surprised that the module built with a different
 > DEBUG_KOBJECT_RELEASE config would load. Does it not affect module
 > versions?
 
# CONFIG_MODVERSIONS is not set


	Dave

