Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab3HAVE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:04:58 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43251 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756873Ab3HAVEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:04:49 -0400
Message-ID: <1375391087.2034.82.camel@joe-AO722>
Subject: Re: [PATCH V2 3/3] ethernet: Convert mac address uses of 6 to
 ETH_ALEN
From: Joe Perches <joe@perches.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        David Miller <davem@davemloft.net>
Cc: Olof Johansson <olof@lixom.net>, Sam Creasey <sammy@sammy.net>,
        Grant Grundler <grundler@parisc-linux.org>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Network Development <netdev@vger.kernel.org>,
        Sony Chacko <sony.chacko@qlogic.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Manish Chopra <manish.chopra@qlogic.com>,
        Don Fry <pcnet32@frontier.com>, Ron Mercer <ron.mercer@qlogic.com>,
        Andrew Gallatin <gallatin@myri.com>, linux-driver@qlogic.com,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Shahed Shaikh <shahed.shaikh@qlogic.com>
Date: Thu, 01 Aug 2013 14:04:47 -0700
In-Reply-To: <20130801205817.GJ23006@n2100.arm.linux.org.uk>
References: <cover.1375387593.git.joe@perches.com>
	 <4170130535e4ea14c66f8510042577be21941f4d.1375387593.git.joe@perches.com>
	 <CAOesGMhmxJTDjcPeD4b1FvRsbP8df369F01SQBK6dk4nXmRGjA@mail.gmail.com>
	 <20130801203343.GG23006@n2100.arm.linux.org.uk>
	 <1375390528.2034.77.camel@joe-AO722>
	 <20130801205817.GJ23006@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-01 at 21:58 +0100, Russell King - ARM Linux wrote:
> On Thu, Aug 01, 2013 at 01:55:28PM -0700, Joe Perches wrote:
> > On Thu, 2013-08-01 at 21:33 +0100, Russell King - ARM Linux wrote:
> > > On Thu, Aug 01, 2013 at 01:31:09PM -0700, Olof Johansson wrote:
> > > > On Thu, Aug 1, 2013 at 1:14 PM, Joe Perches <joe@perches.com> wrote:
> > > > > diff --git a/drivers/net/ethernet/pasemi/pasemi_mac.h b/drivers/net/ethernet/pasemi/pasemi_mac.h
> > []
> > > > > @@ -79,11 +79,11 @@ struct pasemi_mac {
> > > > >         int             last_cs;
> > > > >         int             num_cs;
> > > > >         u32             dma_if;
> > > > > -       u8              type;
> > > > >  #define MAC_TYPE_GMAC  1
> > > > >  #define MAC_TYPE_XAUI  2
> > > > >
> > > > > -       u8              mac_addr[6];
> > > > > +       u8              mac_addr[ETH_ALEN];
> > > > > +       u8              type;
> > > > 
> > > > Just promote 'type' to u32 instead, saves you from moving the #defines
> > > > down, etc, etc.
> > 
> > type is already u8, why change it?
> > That would also change struct size.
> > 
> > > There's a more fundamental question which has to be asked: what is the
> > > point of moving that in the first place?
> > 
> > Some is_<foo>_ether_addr tests assume __aligned(2)
> > by a casting char * to u16/be16 * and dereferencing.
> > 
> > see patch 0/3 and include/linux/etherdevice.h
> 
> This seems rather obscure - I mean, it's not obvious to driver authors
> that should be the case.  Would it not be better to make this a little
> more obvious somehow?  Maybe __aligned(2) against mac_addr?  Or
> maybe have a debugging check for it?

That'd be for David Miller (cc'd).

I believe he's argued in the past that any alignment check
for mac addresses was unnecessary.

For all I know it really might not matter because pasemi
can successfully dereference a ushort against an odd char
pointer.

I just noticed it and thought it'd be better moved.


