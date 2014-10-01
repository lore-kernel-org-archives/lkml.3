Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaJAOOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:14:54 -0400
Received: from sym2.noone.org ([178.63.92.236]:32959 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbaJAOOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:14:52 -0400
Date: Wed, 1 Oct 2014 16:14:49 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Joe Perches <joe@perches.com>
Cc: Mark Einon <mark.einon@gmail.com>, davem@davemloft.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] et131x: Add PCIe gigabit ethernet driver et131x
 to drivers/net
Message-ID: <20141001141449.GI3279@distanz.ch>
References: <1412112586-2194-1-git-send-email-mark.einon@gmail.com>
 <20141001124500.GH3279@distanz.ch>
 <1412171027.3247.6.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412171027.3247.6.camel@joe-AO725>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-01 at 15:43:47 +0200, Joe Perches <joe@perches.com> wrote:
> On Wed, 2014-10-01 at 14:45 +0200, Tobias Klauser wrote:
> > On 2014-09-30 at 23:29:46 +0200, Mark Einon <mark.einon@gmail.com> wrote:
> > > This adds the ethernet driver for Agere et131x devices to
> > > drivers/net/ethernet.
> []
> > > diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/agere/et131x.c
> []
> > > +	rc = pci_enable_device(pdev);
> > > +	if (rc < 0) {
> > > +		dev_err(&pdev->dev, "pci_enable_device() failed\n");
> > > +		goto out;
> > 
> > Nit: Just return rc here.
> 
> I don't think it matters at all.

Combined with my second remark this change makes the `out' label
unnecessary. If Mark decides to keep the goto here, at least the
position of the label should be changed to the end of the function, to
remain predictable and avoid jumping back.
