Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab3DYKCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 06:02:50 -0400
Received: from relay1.sgi.com ([192.48.179.29]:48238 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757260Ab3DYKCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 06:02:48 -0400
Date: Thu, 25 Apr 2013 05:02:46 -0500
From: Robin Holt <holt@sgi.com>
To: Jean Delvare <jdelvare@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        DuanZhenzhong <zhenzhong.duan@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: memcpy_fromio in dmi_scan.c
Message-ID: <20130425100246.GR3672@sgi.com>
References: <1366636689.4503.35.camel@chaos.site>
 <5175FF0F.9050206@oracle.com>
 <1366702122.4667.11.camel@chaos.site>
 <3908561D78D1C84285E8C5FCA982C28F1EA52ED3@ORSMSX104.amr.corp.intel.com>
 <1366831328.4618.476.camel@chaos.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1366831328.4618.476.camel@chaos.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 09:22:08PM +0200, Jean Delvare wrote:
> Hi Tony,
> 
> Thanks for stepping in.
> 
> Le Tuesday 23 April 2013 à 22:00 +0000, Luck, Tony a écrit :
> > > I don't have much knowledge about IA64 either. All I see is that while
> > > x86 implements memcpy_fromio() with memcpy [1], ia64 implements it with
> > > readb [2]. There must be a reason for that, and I can only suppose that
> > > memcpy on __iomem pointers doesn't work on IA64. If memcpy doesn't work
> > > then I can't see memcmp working.
> > 
> > On most platforms readb() just ends up doing a regular dereference of the
> > address ... so I'd expect that memcmp would work just fine.  The exception
> > is the old SGI sn2 which end up calling ___sn_readb() ... which does something
> > weird with sn_dma_flush() after doing the dereference of *addr.  I don't

sn_dma_flush has a good description at the beginning of it.  It is only
related to activity on PCI attached devices and a memcmp should be fine.
It must be that our prom produces a bad DMI table.

Robin
