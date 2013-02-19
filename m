Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729Ab3BSR2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:28:25 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:40101 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758685Ab3BSR2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:28:24 -0500
X-IronPort-AV: E=Sophos;i="4.84,696,1355097600"; 
   d="scan'208";a="1619905"
Message-ID: <1361294901.1051.137.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH LINUX] xen: event channel arrays are xen_ulong_t and not
 unsigned long
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Tim Deegan <tim@xen.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, "Keir (Xen.org)" <keir@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Tue, 19 Feb 2013 17:28:21 +0000
In-Reply-To: <20130219172645.GA97631@ocelot.phlegethon.org>
References: <1361285327.1051.115.camel@zakaz.uk.xensource.com>
	 <1361285357-26696-1-git-send-email-ian.campbell@citrix.com>
	 <alpine.DEB.2.02.1302191642230.4654@kaball.uk.xensource.com>
	 <1361294248.1051.136.camel@zakaz.uk.xensource.com>
	 <20130219172645.GA97631@ocelot.phlegethon.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-19 at 17:26 +0000, Tim Deegan wrote:
> At 17:17 +0000 on 19 Feb (1361294248), Ian Campbell wrote:
> > On Tue, 2013-02-19 at 17:11 +0000, Stefano Stabellini wrote:
> > > On Tue, 19 Feb 2013, Ian Campbell wrote:
> > > > +/*
> > > > + * We cannot use xchg because it does not support 8-byte
> > > > + * values. However it is safe to use {ldr,dtd}exd directly because all
> > > > + * platforms which Xen can run on support those instructions.
> > > > + */
> > > > +static inline xen_ulong_t xchg_xen_ulong(xen_ulong_t *ptr, xen_ulong_t val)
> > > > +{
> > > > +       xen_ulong_t oldval;
> > > > +       unsigned int tmp;
> > > > +
> > > > +       wmb();
> > > > +       asm volatile("@ read_evtchn_pending_sel\n"
> > >                            ^ do we need this?
> > 
> > It means that the .s files (if you create them) and such are a bit more
> > readable, it's not that uncommon in the ARM inline assembly.
> 
> +1.  s/read_evtchn_pending_sel/xchg_xen_ulong/ though.

Damn, yes. I just sent v3 too :-(

Ian.

