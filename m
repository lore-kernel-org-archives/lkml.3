Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3J3UFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:05:09 -0400
Received: from plane.gmane.org ([80.91.229.3]:36445 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab3J3UFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:05:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Leon Gorge <leon@georgemail.de>
Subject: Re: compile =?utf-8?b?eDg2XzY0?= waring
Date: Wed, 30 Oct 2013 13:04:42 +0000 (UTC)
Message-ID: <loom.20131030T132303-504@post.gmane.org>
References: <201307051956052638321@gmail.com>  <1374699912.29835.8.camel@x61.thuisdomein> <51F061CC.9080704@ti.com>  <1374742433.29835.31.camel@x61.thuisdomein> <1374745288.29835.41.camel@x61.thuisdomein> <51F1174D.2010105@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 178.5.208.15 (Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Firefox/24.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Rini <trini <at> ti.com> writes:

> 
> On 07/25/2013 05:41 AM, Paul Bolle wrote:
> > Tom,
> > 
> > On Thu, 2013-07-25 at 10:53 +0200, Paul Bolle wrote:
> >> But I've just pulled top-of-tree Linus, ie commit 07bc9dc1b0
> >> ("git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc'"). I'll
> >> try to build that and I 'll send you my .config if this all is still
> >> triggered.
> > 
> > It is still seen with "make bzImage" at v3.11-rc2-185-g07bc9dc (current
> > Linus' tip-of-tree). I get, in summary:
> >     WARNING: arch/x86/mm/built-in.o(.text.unlikely+0xbf2): Section
mismatch in reference from the
> function __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed
> >     WARNING: arch/x86/built-in.o(.text.unlikely+0x140e): Section
mismatch in reference from the
> function __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed
> >     WARNING: vmlinux.o(.text.unlikely+0x1444): Section mismatch in
reference from the function
> __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed
> > 
> > But it is all the same thing (the issue apparently just repeat itself
> > when arch/x86/mm/built-in.o is merged into arch/x86/built-in.o, and
> > again when arch/x86/built-in.o is merged into vmlinux.o).
> 
> OK, thanks.  I just posted a patch that fixes the warning here.  The
> problem is that __node_set wasn't being inlined by the compiler, so you
> have the section mis-match above.
> 


Hello,

I'm just facing the same warning compiling 3.11.4 and 3.11.6 and i wondered
wether your patch shouldn't already be included?

The config was being used with practically every third or fourth
kernel-release since 3.2.something (with adjustments from time to time).

I've re-done the NUMA-related config with 3.7 and didn't get any warnings
until now. Shall i post my config?

