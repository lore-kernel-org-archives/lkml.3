Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933247Ab3BSRs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:48:26 -0500
Received: from ocelot.phlegethon.org ([81.29.64.94]:62103 "EHLO
	mail.phlegethon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136Ab3BSRsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:48:25 -0500
X-Greylist: delayed 1292 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2013 12:48:24 EST
Date: Tue, 19 Feb 2013 17:26:45 +0000
From: Tim Deegan <tim@xen.org>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, "Keir (Xen.org)" <keir@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH LINUX] xen: event channel arrays are xen_ulong_t and not unsigned long
Message-ID: <20130219172645.GA97631@ocelot.phlegethon.org>
References: <1361285327.1051.115.camel@zakaz.uk.xensource.com> <1361285357-26696-1-git-send-email-ian.campbell@citrix.com> <alpine.DEB.2.02.1302191642230.4654@kaball.uk.xensource.com> <1361294248.1051.136.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1361294248.1051.136.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 17:17 +0000 on 19 Feb (1361294248), Ian Campbell wrote:
> On Tue, 2013-02-19 at 17:11 +0000, Stefano Stabellini wrote:
> > On Tue, 19 Feb 2013, Ian Campbell wrote:
> > > +/*
> > > + * We cannot use xchg because it does not support 8-byte
> > > + * values. However it is safe to use {ldr,dtd}exd directly because all
> > > + * platforms which Xen can run on support those instructions.
> > > + */
> > > +static inline xen_ulong_t xchg_xen_ulong(xen_ulong_t *ptr, xen_ulong_t val)
> > > +{
> > > +       xen_ulong_t oldval;
> > > +       unsigned int tmp;
> > > +
> > > +       wmb();
> > > +       asm volatile("@ read_evtchn_pending_sel\n"
> >                            ^ do we need this?
> 
> It means that the .s files (if you create them) and such are a bit more
> readable, it's not that uncommon in the ARM inline assembly.

+1.  s/read_evtchn_pending_sel/xchg_xen_ulong/ though.

Tim.
