Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbaHFRaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:30:20 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:54408 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457AbaHFRaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:30:19 -0400
Date: Wed, 6 Aug 2014 11:30:14 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com
Subject: Re: [PATCH] PCI: keystone: add a pci quirk to limit mrrs
Message-ID: <20140806173014.GD19914@obsidianresearch.com>
References: <1407338300-9146-1-git-send-email-m-karicheri2@ti.com>
 <20140806163021.GB19914@obsidianresearch.com>
 <53E25E24.8070506@ti.com>
 <20140806165837.GC19914@obsidianresearch.com>
 <53E26155.1020107@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E26155.1020107@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 01:09:41PM -0400, Murali Karicheri wrote:

> >>Yes it works with tuning enabled. Tuning happens afterwards. The
> >>'limiting mrrs to 256' below is from my patch.
> >
> >That seems backwards to me...
> Rational? The tuning is reading mrrs and set mps to less than or
> equal to mrss. So adding this before make sure mrrs used is below
> keystones's limit.

The tuning process adjusts the parameters however it sees fit, todays
algorithm might not increase a BIOS set MRRS, but tomorrow's could.

The quirk should be after the tuning to ensure the MRRS is limited..

Jason
