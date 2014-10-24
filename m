Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbaJXIx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:53:56 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35406 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaJXIxv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:53:51 -0400
Date: Fri, 24 Oct 2014 09:53:44 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH RFC 1/2] drivers: pci: fix window allocation order wrt
 bus_range filtering
Message-ID: <20141024085344.GA23784@red-moon>
References: <1414077787-20633-1-git-send-email-lorenzo.pieralisi@arm.com>
 <20141023222707.GB11115@google.com>
MIME-Version: 1.0
In-Reply-To: <20141023222707.GB11115@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 24 Oct 2014 08:53:46.0031 (UTC) FILETIME=[053943F0:01CFEF68]
X-MC-Unique: 114102409534803801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 11:27:07PM +0100, Bjorn Helgaas wrote:
> On Thu, Oct 23, 2014 at 04:23:06PM +0100, Lorenzo Pieralisi wrote:
> > The number of windows allocated for the host bridge depends on the
> > bus resource. Instead of first allocating the windows and then
> > limit the bus resource, this patch reshuffles the code so that if any
> > limitation is applied to the bus resource it is taken into account in
> > the windows allocation.
> > 
> > Cc: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> 
> Hi Lorenzo,
> 
> I can *read* your patches just fine, but when I save them using mutt to
> apply them, they look like this:
> 
>   --- a/drivers/pci/host/pci-host-generic.c
>   +++ b/drivers/pci/host/pci-host-generic.c
>   @@ -276,17 +276,17 @@ static int gen_pci_parse_map_cfg_windows(struct gen_p=
>   ci *pci)
>    =09=09return err;
>     =09}
>     =20
>     -=09pci->cfg.win =3D devm_kcalloc(dev,
>     resource_size(&pci->cfg.bus_range),
> 
> I can work around this by downloading them another way, but it is a
> bit of a hassle.  I *think* this is because your email has
> 
>   Content-Type: text/plain; charset=WINDOWS-1252

Yes, it is the SMTP server messing about with patches, I will have to switch
to another one, sorry.

I pushed a branch on my arm git:

git://linux-arm.org/linux-2.6-lp.git pci-host-generic

I can also resend the patches, whatever it is best for you.

Thanks,
Lorenzo

