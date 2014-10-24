Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbaJXJET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:04:19 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46752 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762AbaJXJEP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:04:15 -0400
Date: Fri, 24 Oct 2014 10:04:09 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH RFC 1/2] drivers: pci: fix window allocation order wrt
 bus_range filtering
Message-ID: <20141024090409.GR25302@e106497-lin.cambridge.arm.com>
References: <1414077787-20633-1-git-send-email-lorenzo.pieralisi@arm.com>
 <20141023222707.GB11115@google.com>
MIME-Version: 1.0
In-Reply-To: <20141023222707.GB11115@google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 24 Oct 2014 09:04:10.0263 (UTC) FILETIME=[794B8270:01CFEF69]
X-MC-Unique: 114102410041200701
Content-Type: text/plain; charset=UTF-8
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
> 
> which apparently confuses mutt.  Any idea why this is?  Anybody know how I
> can fix mutt to deal with this?

I use decode-save (<Esc>s on my setup) to save the attachment(s). Sometimes
it works well enough, although more often than not tabs get lost.

Best regards,
Liviu

> 
> Bjorn
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

