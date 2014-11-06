Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaKFTfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 14:35:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbaKFTfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 14:35:07 -0500
Date: Thu, 6 Nov 2014 13:34:33 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141106193433.GA16347@treble.redhat.com>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
 <20141106184446.GA12779@infradead.org>
 <20141106185157.GB29272@suse.cz>
 <20141106185857.GA7106@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141106185857.GA7106@infradead.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 10:58:57AM -0800, Christoph Hellwig wrote:
> On Thu, Nov 06, 2014 at 07:51:57PM +0100, Vojtech Pavlik wrote:
> > I don't think this specific example was generated. 

So there are two ways to use this live patching API: using a generated
module (e.g., using the kpatch-build tool) or manually compiling a
module via kbuild.

Vojtech's right, the provided example was not generated.  Maybe it
belongs in samples/livepatch?

> > 
> > I also don't think including the whole kpatch automation into the kernel
> > tree is a viable development model for it. (Same would apply for kGraft
> > automation.)
> 
> Why?  We (IMHO incorrectly) used the argument of tight coupling to put
> perf into the kernel tree.  Generating kernel live patches is way more
> integrated that it absolutely has to go into the tree to be able to do
> proper development on it in an integrated fashion.

I agree that we should also put kpatch-build (or some converged
kpatch/kGraft-build tool) into the kernel tree, because of the tight
interdependencies between it and the kernel.  I think it would make
development much easier.  Otherwise, for example, it may end up having a
lot of #ifdef hacks based on what kernel version it's targeting.

-- 
Josh
