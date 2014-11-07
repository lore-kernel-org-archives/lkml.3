Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaKGNMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:12:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbaKGNMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:12:20 -0500
Date: Fri, 7 Nov 2014 07:11:53 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141107131153.GD4071@treble.redhat.com>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <20141106184446.GA12779@infradead.org>
 <20141106185157.GB29272@suse.cz>
 <20141106185857.GA7106@infradead.org>
 <20141106202423.GB2266@suse.cz>
 <20141107074745.GC22703@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141107074745.GC22703@infradead.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 11:47:45PM -0800, Christoph Hellwig wrote:
> On Thu, Nov 06, 2014 at 09:24:23PM +0100, Vojtech Pavlik wrote:
> > One reason is that there are currently at least two generators using
> > very different methods of generation (in addition to the option of doing
> > the patch module by hand), and neither of them are currently in a state
> > where they would be ready for inclusion into the kernel (although the
> > kpatch one is clearly closer to that).
> 
> So agree on one method and get it into shape, just like we do for other
> kernel subsystems.

That's our goal (and it sounds like everybody's on board with that).

But we have two different implementations, all the way up the stack.  I
think we have to work on combining and stabilizing one thing at a time.
We want to do this in stages:

1. Define a common core module with an API that can be used by all three
   approaches (manual, kpatch generator, kGraft generator)

2. Add consistency model(s) (e.g. kpatch stop_machine, kGraft per-task
   consistency, Masami's per task ref counting)

3. Add combined patch module generation tool

-- 
Josh
