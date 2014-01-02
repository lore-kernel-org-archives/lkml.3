Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaABTRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 14:17:39 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:40117 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaABTRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 14:17:37 -0500
Date: Thu, 2 Jan 2014 14:17:21 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        annie.li@oracle.com, msw@amazon.com
Subject: Re: [Xen-devel] [PATCH] xen/grant-table: Force to use v1 of grants.
Message-ID: <20140102191721.GK3021@pegasus.dumpdata.com>
References: <1388502919-8601-1-git-send-email-konrad.wilk@oracle.com>
 <1388502919-8601-2-git-send-email-konrad.wilk@oracle.com>
 <52C57D9A.8050804@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C57D9A.8050804@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 02:54:18PM +0000, David Vrabel wrote:
> On 31/12/13 15:15, Konrad Rzeszutek Wilk wrote:
> > We have the framework to use v2, but there are no backends that
> > actually use it. The end result is that on PV we use v2 grants
> > and on PVHVM v1. The v1 has a capacity of 512 grants per page while
> > the v2 has 256 grants per page. This means we lose about 50%
> > capacity - and if we want more than 16 VIFs (each VIF takes
> > 512 grants), then we are hitting the max per guest of 32.
> > 
> > Oracle-bug: 16039922
> > CC: annie.li@oracle.com
> > CC: msw@amazon.com
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Reviewed-by: David Vrabel <david.vrabel@citrix.com>
> 
> What does v2 add anyway? Do we want to remove all v2 related code or are

Better status reporting page and two extra types of grants.

> we expecting to make use of it in the near future?

Yes, that is my understanding.
> 
> David
