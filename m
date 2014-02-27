Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaB0Np7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:45:59 -0500
Received: from service87.mimecast.com ([91.220.42.44]:49052 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaB0Np6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:45:58 -0500
Date: Thu, 27 Feb 2014 13:45:55 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] pci: OF: Fix the conversion of IO ranges into IO
 resources.
Message-ID: <20140227134555.GJ1692@e106497-lin.cambridge.arm.com>
Mail-Followup-To: linux-pci <linux-pci@vger.kernel.org>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com>
 <1393506402-11474-2-git-send-email-Liviu.Dudau@arm.com>
 <14735193.MhDlU8yNYG@wuerfel>
MIME-Version: 1.0
In-Reply-To: <14735193.MhDlU8yNYG@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 27 Feb 2014 13:45:56.0393 (UTC) FILETIME=[3D67F990:01CF33C2]
X-MC-Unique: 114022713455607701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 01:20:54PM +0000, Arnd Bergmann wrote:
> On Thursday 27 February 2014 13:06:39 Liviu Dudau wrote:
> > +       res->flags = range->flags;
> > +       if (res->flags & IORESOURCE_IO) {
> > +               unsigned long port;
> > +               port = pci_address_to_pio(range->pci_addr);
> > +               if (port == (unsigned long)-1) {
> > +                       res->start = (resource_size_t)OF_BAD_ADDR;
> > +                       res->end = (resource_size_t)OF_BAD_ADDR;
> > +                       return;
> > +               }
> > 
> 
> I think this conflicts with the way that pci_address_to_pio() is
> defined on powerpc, where it expects a CPU address as the input,
> not a PCI i/o address.

And you are right, maybe what I need is to fix weak version of the
function, as that one cannot cope with cpu addresses. But I think
the idea still stands.

Thanks for reviewing this version as well!

Liviu

> 
> 	Arnd
> 
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

