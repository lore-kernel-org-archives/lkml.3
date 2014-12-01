Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbaLANcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:32:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbaLANcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:32:47 -0500
Date: Mon, 1 Dec 2014 14:32:45 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Juergen Gross <jgross@suse.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        x86@kernel.org, kvm@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>,
        Joerg Roedel <jroedel@suse.de>, Jan Beulich <JBeulich@suse.com>,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        Borislav Petkov <bp@suse.de>, Olaf Hering <ohering@suse.de>
Subject: Re: [Xen-devel] [PATCH] xen: privcmd: schedule() after private
	hypercall when non CONFIG_PREEMPT
Message-ID: <20141201133245.GA25677@wotan.suse.de>
References: <1417040805-15857-1-git-send-email-mcgrof@do-not-panic.com> <5476C66F.5040308@suse.com> <20141127183616.GV25677@wotan.suse.de> <54777277.5040401@citrix.com> <5477FECF.2060404@suse.com> <547C4A7E.6020207@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547C4A7E.6020207@citrix.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 11:01:18AM +0000, David Vrabel wrote:
> On 28/11/14 04:49, Juergen Gross wrote:
> > On 11/27/2014 07:50 PM, Andrew Cooper wrote:
> >> 
> >> XenServer uses
> >>
> >> https://github.com/xenserver/linux-3.x.pg/blob/master/master/0001-x86-xen-allow-privcmd-hypercalls-to-be-preempted.patch
> >>
> >>
> >> to deal with these issues.  That patch is based on 3.10.
> > 
> > Clever. :-)
> > 
> >>
> >> I can remember whether this has been submitted upstream before (and
> >> there were outstanding issues), or whether it fell at an inconvenient
> >> time with our development cycles.
> > 
> > I found
> > 
> > http://lists.xen.org/archives/html/xen-devel/2014-02/msg02540.html
> > 
> > and nothing else.
> 
> I dropped it because it copy-and-paste a bunch of otherwise generic x86
> assembler and looked unlikely to get an x86 maintainer ack.  If you
> think otherwise, feel free to pick it up and run with it.

I was trying to run with it, but my biggest gripe with this was
the use of preempt_schedule_irq(), but we can review that on the
other thread.

  Luis
