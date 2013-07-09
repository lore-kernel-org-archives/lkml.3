Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3GIHlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:41:22 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41493 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab3GIHlU convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:12:1>);
	Tue, 9 Jul 2013 03:41:20 -0400
Message-Id: <51DBDAB802000078000E37C1@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 09 Jul 2013 08:41:12 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Borislav Petkov" <bp@alien8.de>, "Matt Wilson" <msw@amazon.com>,
        "Michael Opdenacker" <michael.opdenacker@free-electrons.com>,
        <jeremy@goop.org>, <x86@kernel.org>, <tglx@linutronix.de>,
        <virtualization@lists.linux-foundation.org>,
        <xen-devel@lists.xensource.com>, <mingo@redhat.com>,
        "Paul Bolle" <pebolle@tiscali.nl>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH] xen: remove unused Kconfig parameter
References: <1373264904-27053-1-git-send-email-michael.opdenacker@free-electrons.com>
 <20130708192854.GF4927@phenom.dumpdata.com>
 <20130708193457.GA6926@u109add4315675089e695.ant.amazon.com>
 <51DB2134.9040909@zytor.com> <20130708205834.GA481@pd.tnic>
 <1373326534.1438.10.camel@x61.thuisdomein>
 <f5d6bd67-7464-4932-a7ca-6026fe534fc7@email.android.com>
In-Reply-To: <f5d6bd67-7464-4932-a7ca-6026fe534fc7@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 09.07.13 at 02:26, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> Could you explain to me please why the check in the scripts is superfluous?

This is not really the question - _any_ such check can only be
wrong. The boot loader has absolutely no business caring about
kernel internals, and the kernel shouldn't be limited by it in how it
renames/adds/deletes Kconfig options and anything else.

> Especially as the grand plan is to get rid of CONFIG_XEN_DOM0 and more or 
> less have a backend and fronted config option (since that makes more sense 
> nowadays). And that would make the XEN_DOM0 be obsolete and the XEN_PRIV 
> would be the one that turns a lot of the options needed to compile a kernel 
> that can provide backend driver support. (I am hand waving here). 

That's pretty odd a plan, considering that Dom0 is more than just
an environment to provide backends. In fact, Dom0 may not be
providing any backends at all, and instead just serve the
"controlling hardware" and/or "control domain" purpose that it
really is meant to be. But of course, if none of _that_ functionality
depends on this config option, then it indeed could go away.

Jan

