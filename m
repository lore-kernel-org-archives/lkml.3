Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3GIRT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 13:19:57 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48051 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab3GIRT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 13:19:56 -0400
Date: Tue, 9 Jul 2013 13:19:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Jan Beulich <JBeulich@suse.com>, Matt Wilson <msw@amazon.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        jeremy@goop.org, x86@kernel.org, tglx@linutronix.de,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com, mingo@redhat.com,
        Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH] xen: remove unused Kconfig parameter
Message-ID: <20130709171909.GA25586@phenom.dumpdata.com>
References: <1373264904-27053-1-git-send-email-michael.opdenacker@free-electrons.com>
 <20130708192854.GF4927@phenom.dumpdata.com>
 <20130708193457.GA6926@u109add4315675089e695.ant.amazon.com>
 <51DB2134.9040909@zytor.com>
 <20130708205834.GA481@pd.tnic>
 <1373326534.1438.10.camel@x61.thuisdomein>
 <f5d6bd67-7464-4932-a7ca-6026fe534fc7@email.android.com>
 <51DBDAB802000078000E37C1@nat28.tlf.novell.com>
 <20130709144840.GF24897@phenom.dumpdata.com>
 <20130709150554.GA27579@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709150554.GA27579@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 05:05:54PM +0200, Borislav Petkov wrote:
> On Tue, Jul 09, 2013 at 10:48:40AM -0400, Konrad Rzeszutek Wilk wrote:
> > Then that should be discussed on grub2 to remove said check and modify
> > the code so that it can properly work without regression.
> 
> Actually, the kernel patch removing that symbol should be applied so
> that grub2 breaks faster. One can't possibly rely on kernel internals
> for anything, as it is insanely insane (yep, the tautology is on purpose
> :-)).

I am not sure why you are advocating that path.

My thinking is that what should be done to have some sense of history
is that the patch in GRUB to not rely on kernel internals should be done.
Then that git commit of that tree should be mentioned in this kernel patch.

This way one can nicely follow the trail of changes and see what the
interdependencies are (or rather that they have been removed).

I wouldn't want GRUB2 to have regressions and stop generating the proper
menu options. That smells of userspace regressions and I am not too
keen to have Linus point this out to me.

Once that is done we can follow up on this patch and perhaps also
nicely convience the initial author of this patch to look at removing the
CONFIG_XEN_DOM0 and replacing them with the two other CONFIG options
that Jan and me have been discussing.
