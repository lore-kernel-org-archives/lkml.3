Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaJVODt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:03:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbaJVODs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:03:48 -0400
Date: Wed, 22 Oct 2014 09:03:35 -0500
From: Seth Jennings <sjenning@redhat.com>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kprobes: add kprobe_is_function_probed()
Message-ID: <20141022140335.GB5748@cerebellum.variantweb.net>
References: <alpine.LNX.2.00.1410211744550.24255@pobox.suse.cz>
 <20141021164328.GG3978@treble.redhat.com>
 <alpine.LNX.2.00.1410212209560.22681@pobox.suse.cz>
 <20141021211409.GA28989@treble.redhat.com>
 <alpine.LNX.2.00.1410212319100.22681@pobox.suse.cz>
 <20141022024032.GA8719@treble.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022024032.GA8719@treble.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 09:40:32PM -0500, Josh Poimboeuf wrote:
> On Tue, Oct 21, 2014 at 11:25:56PM +0200, Jiri Kosina wrote:
> > On Tue, 21 Oct 2014, Josh Poimboeuf wrote:
> > > 
> > > I'm guessing kGraft doesn't have the address + length?  I think you
> > > could call kallsyms_lookup() to get both values.
> > > 
> > > Maybe we should see what our unified live patching code ends up looking
> > > like before deciding what interface(s) we need here?
> > 
> > Yes, that probably makes sense indeed. I am talking to David Miller wrt. 
> > mailinglist creation on vger.kernel.org as we speak, hopefully it'll 
> > materialize soon.
> 
> Ok, thanks!  Seth is currently slaving away on the code :-)

Yes, I am :)  Let me know if this impacts the information we need to
pass via the *_register() call to the core module.

Currently, I pass the old function name (char *), new function pointer
(void *), and the old_addr (optional, unsigned long).  The old_addr
serves to identify the old function by address instead of name if that
information is provided.

Thanks,
Seth

