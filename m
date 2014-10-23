Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaJWW1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 18:27:20 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:62602 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaJWW1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 18:27:12 -0400
Date: Thu, 23 Oct 2014 16:27:07 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, liviu.dudau@arm.com,
        Suravee.Suthikulpanit@amd.com, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH RFC 1/2] drivers: pci: fix window allocation order wrt
 bus_range filtering
Message-ID: <20141023222707.GB11115@google.com>
References: <1414077787-20633-1-git-send-email-lorenzo.pieralisi@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414077787-20633-1-git-send-email-lorenzo.pieralisi@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 04:23:06PM +0100, Lorenzo Pieralisi wrote:
> The number of windows allocated for the host bridge depends on the
> bus resource. Instead of first allocating the windows and then
> limit the bus resource, this patch reshuffles the code so that if any
> limitation is applied to the bus resource it is taken into account in
> the windows allocation.
> 
> Cc: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

Hi Lorenzo,

I can *read* your patches just fine, but when I save them using mutt to
apply them, they look like this:

  --- a/drivers/pci/host/pci-host-generic.c
  +++ b/drivers/pci/host/pci-host-generic.c
  @@ -276,17 +276,17 @@ static int gen_pci_parse_map_cfg_windows(struct gen_p=
  ci *pci)
   =09=09return err;
    =09}
    =20
    -=09pci->cfg.win =3D devm_kcalloc(dev,
    resource_size(&pci->cfg.bus_range),

I can work around this by downloading them another way, but it is a
bit of a hassle.  I *think* this is because your email has

  Content-Type: text/plain; charset=WINDOWS-1252

which apparently confuses mutt.  Any idea why this is?  Anybody know how I
can fix mutt to deal with this?

Bjorn
