Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaKKRq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:46:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbaKKRqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:46:25 -0500
Date: Tue, 11 Nov 2014 11:45:55 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141111174555.GA28099@treble.redhat.com>
References: <20141106202423.GB2266@suse.cz>
 <20141107074745.GC22703@infradead.org>
 <20141107131153.GD4071@treble.redhat.com>
 <20141107140458.GA21774@suse.cz>
 <20141107154500.GF4071@treble.redhat.com>
 <20141107212735.GA21409@suse.cz>
 <20141108034553.GA11663@treble.redhat.com>
 <20141108080754.GA28969@suse.cz>
 <20141110170903.GA11119@treble.hsd1.ky.comcast.net>
 <20141111090505.GA20424@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141111090505.GA20424@suse.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 10:05:05AM +0100, Vojtech Pavlik wrote:
> On Mon, Nov 10, 2014 at 11:09:03AM -0600, Josh Poimboeuf wrote:
> > > But there are a few (probably much less than 10%) cases like the locking
> > > one I used above, where SWITCH_THREAD just isn't going to cut it and for
> > > those I would need SWITCH_KERNEL or get very creative with refactoring
> > > the patch to do things differently.
> > 
> > I'm not opposed to having both if necessary.  But I think the code would
> > be _much_ simpler if we could agree on a single consistency model that
> > can be used in all cases.  Plus there wouldn't be such a strong
> > requirement to get incremental patching to work safely (which will add
> > more complexity).
> > 
> > I actually agree with you that LEAVE_PATCHED_SET + SWITCH_THREAD is
> > pretty nice.
> 
> Cool! Do you see it as the next step consistency model we would focus on
> implementing in livepatch after the null model is complete and upstream?

Yeah, I'm thinking so.  None of the consistency models are perfect, but
I think this is a nice hybrid of the kGraft and kpatch models.  It
allows us to apply the greatest percentage of patches with the highest
success rate, while keeping the code complexity at a reasonable level.

-- 
Josh
