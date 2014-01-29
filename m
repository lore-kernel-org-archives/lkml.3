Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbaA2Cab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 21:30:31 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:47103 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaA2Caa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 21:30:30 -0500
Date: Tue, 28 Jan 2014 18:30:19 -0800
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: <roger.pau@citrix.com>, "xen-devel" <xen-devel@lists.xenproject.org>,
        <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [V0 PATCH] pvh: Disable PSE feature for now
Message-ID: <20140128183019.5b765f85@mantra.us.oracle.com>
In-Reply-To: <52E796EB0200007800117804@nat28.tlf.novell.com>
References: <1390875519-8667-1-git-send-email-mukesh.rathor@oracle.com>
	<1390875519-8667-2-git-send-email-mukesh.rathor@oracle.com>
	<52E796EB0200007800117804@nat28.tlf.novell.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014 10:39:23 +0000
"Jan Beulich" <JBeulich@suse.com> wrote:

> >>> On 28.01.14 at 03:18, Mukesh Rathor <mukesh.rathor@oracle.com>
> >>> wrote:
> > Until now, xen did not expose PSE to pvh guest, but a patch was
> > submitted to xen list to enable bunch of features for a pvh guest.
> > PSE has not been looked into for PVH, so until we can do that and
> > test it to make sure it works, disable the feature to avoid flood
> > of bugs.
> > 
> > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > ---
> >  arch/x86/xen/enlighten.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> > index a4d7b64..4e952046 100644
> > --- a/arch/x86/xen/enlighten.c
> > +++ b/arch/x86/xen/enlighten.c
> > @@ -1497,6 +1497,11 @@ static void __init
> > xen_pvh_early_guest_init(void) xen_have_vector_callback = 1;
> >  	xen_pvh_set_cr_flags(0);
> >  
> > +        /* pvh guests are not quite ready for large pages yet */
> > +        setup_clear_cpu_cap(X86_FEATURE_PSE);
> > +        setup_clear_cpu_cap(X86_FEATURE_PSE36);
> 
> And why would you not want to also turn of 1Gb pages then?

Right, that should be turned off too, but Konrad thinks we should
leave them on in linux and deal with issues as they come. I've not
tested them, or looked/thought about them, so had thought would be 
better to turn them on after I/someone gets to test them.

thanks
Mukesh
