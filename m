Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381AbaLKOYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 09:24:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932612AbaLKOYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 09:24:03 -0500
Date: Thu, 11 Dec 2014 08:23:28 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Petr Mladek <pmladek@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] livepatch v5: avoid race when checking for state of
 the patch
Message-ID: <20141211142328.GA30621@treble.redhat.com>
References: <1418148307-21434-1-git-send-email-pmladek@suse.cz>
 <1418148307-21434-2-git-send-email-pmladek@suse.cz>
 <20141209183249.GA25239@treble.redhat.com>
 <20141210101147.GB2454@pathway.suse.cz>
 <20141210152506.GA32670@treble.redhat.com>
 <20141211111733.GA16567@dhcp128.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141211111733.GA16567@dhcp128.suse.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 12:17:33PM +0100, Petr Mladek wrote:
> On Wed 2014-12-10 09:25:06, Josh Poimboeuf wrote:
> > On Wed, Dec 10, 2014 at 11:11:47AM +0100, Petr Mladek wrote:
> > > On Tue 2014-12-09 12:32:49, Josh Poimboeuf wrote:
> > But livepatch isn't a module, it's part of the kernel.
> 
> Ah, I remembered that module_init(klp_init) and created a wrong mental link ;-)
> 
> > Even if the init
> > function returns an error, that doesn't prevent any of the other
> > exported functions from getting called.
> 
> Well, it still will be covered by that later klp_patch_is_registered()
> check. But I am find with leaving it as is.

True, it's probably only necessary to call klp_is_enabled() from the
register function.  And I'm thinking it should probably have a better
name, like klp_initialized().

But that's a minor cosmetic change, so if there are no more comments for
the v6 patch set, I can send a separate patch for that later.

-- 
Josh
