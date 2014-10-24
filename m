Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbaJXKzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:55:42 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:49339 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbaJXKzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:55:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH RFC 1/2] drivers: pci: fix window allocation order wrt bus_range filtering
Date: Fri, 24 Oct 2014 12:55:33 +0200
Message-ID: <3428924.HDrlijkpFb@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141024090409.GR25302@e106497-lin.cambridge.arm.com>
References: <1414077787-20633-1-git-send-email-lorenzo.pieralisi@arm.com> <20141023222707.GB11115@google.com> <20141024090409.GR25302@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:WtAgEWD54TD7+Lqgzjol273kpatb9TnEWSRWOCt8T62
 y2IFvs1HYNk7BgfCiV7QfWD9Mn/9UkOwubsw7oNSi1eiK+oX51
 SpWYbCVGkscyE6yKc4FI+0ZvRJvs5I7k2D7CVZzkntAIDqThU1
 dY8K1kMcaMIHJlgB29hVZjyYvtwtzC3+JDHxbjY9tD1B2wClii
 HEYTZfaTAYM4UhNMBE4A9vV1Y1855z0p3f2t5KFyQMAaqnNtDw
 RfmajuLzPyCG6LYT3C/q21CKsaa4u8bxSTBxrw8aCF0EmbfJlv
 k5aW2W5SCbQVo3d7WpcFivuSQQq8v26PTD3UFhBRTxSR5cZOay
 yC4s5msbaWEOyZND6EN4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 October 2014 10:04:09 Liviu Dudau wrote:
> On Thu, Oct 23, 2014 at 11:27:07PM +0100, Bjorn Helgaas wrote:
> > On Thu, Oct 23, 2014 at 04:23:06PM +0100, Lorenzo Pieralisi wrote:
> > > The number of windows allocated for the host bridge depends on the
> > > bus resource. Instead of first allocating the windows and then
> > > limit the bus resource, this patch reshuffles the code so that if any
> > > limitation is applied to the bus resource it is taken into account in
> > > the windows allocation.
> > > 
> > > Cc: Will Deacon <will.deacon@arm.com>
> > > Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > 
> > Hi Lorenzo,
> > 
> > I can *read* your patches just fine, but when I save them using mutt to
> > apply them, they look like this:
> > 
> >   --- a/drivers/pci/host/pci-host-generic.c
> >   +++ b/drivers/pci/host/pci-host-generic.c
> >   @@ -276,17 +276,17 @@ static int gen_pci_parse_map_cfg_windows(struct gen_p=
> >   ci *pci)
> >    =09=09return err;
> >     =09}
> >     =20
> >     -=09pci->cfg.win =3D devm_kcalloc(dev,
> >     resource_size(&pci->cfg.bus_range),
> > 
> > I can work around this by downloading them another way, but it is a
> > bit of a hassle.  I *think* this is because your email has
> > 
> >   Content-Type: text/plain; charset=WINDOWS-1252
> > 
> > which apparently confuses mutt.  Any idea why this is?  Anybody know how I
> > can fix mutt to deal with this?
> 
> I use decode-save (<Esc>s on my setup) to save the attachment(s). Sometimes
> it works well enough, although more often than not tabs get lost.

I just tried applying the patches locally here. The patch looks the same way
for me, but 'git am' actually works while 'patch' does not.

Maybe Bjorn is using an outdated git version. While the patch clearly shouldn't
have been sent that way, I think git has been changed now to work around that.
I'm using a git-2.1 snapshot here.

	Arnd
