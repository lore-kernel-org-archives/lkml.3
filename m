Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab3AROrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:47:00 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41837 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab3AROq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:46:58 -0500
Date: Fri, 18 Jan 2013 09:46:48 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "annie.li@oracle.com" <annie.li@oracle.com>,
        "msw@amazon.com" <msw@amazon.com>
Subject: Re: [Xen-devel] [PATCH] xen/grant-table: Force to use v1 of grants.
Message-ID: <20130118144648.GD9214@phenom.dumpdata.com>
References: <1358371369-19089-1-git-send-email-konrad.wilk@oracle.com>
 <1358428356.13856.55.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358428356.13856.55.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 01:12:36PM +0000, Ian Campbell wrote:
> On Wed, 2013-01-16 at 21:22 +0000, Konrad Rzeszutek Wilk wrote:
> > Note: The hypervisor provides an over-ride for the default
> > of 32 frames (pages) per guest: gnttab_max_nr_frames=X
> 
> Should we consider increasing this value?

The fuzzy math is that for a VIF, you end up using 512 grants. For a VBD
it is 352 grants. With V1 you have 512 grants in a page, with V2 you have
256. So roughly the math is that you can at max 31VIFs and 1VBD with V1
(PVHVM guests) and 15VIFs and 1VBD with V2 (so all PV guests).

I would increase the value, but I don't know what a good value is.
> 
> Ian.
> 
