Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab3CATRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:17:10 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60419 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3CATRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:17:06 -0500
Date: Fri, 1 Mar 2013 11:17:04 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>, Gaohuai Han <hangaohuai@huawei.com>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Dan Williams <djbw@fb.com>
Subject: Re: [ 47/53] dca: check against empty dca_domains list before
 unregister provider
Message-ID: <20130301191704.GB30321@kroah.com>
References: <20130226235619.844721947@linuxfoundation.org>
 <20130226235624.751198592@linuxfoundation.org>
 <512FD486.6030804@suse.cz>
 <512FD775.40206@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512FD775.40206@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 11:17:25PM +0100, Jiri Slaby wrote:
> On 02/28/2013 11:04 PM, Jiri Slaby wrote:
> > On 02/27/2013 12:58 AM, Greg Kroah-Hartman wrote:
> >> 3.0-stable review patch.  If anyone has any objections, please let me know.
> >>
> >> ------------------
> >>
> >> From: Maciej Sosnowski <maciej.sosnowski@intel.com>
> >>
> >> commit c419fcfd071cf34ba00f9f65282583772d2655e7 upstream.
> >>
> >> When providers get blocked unregister_dca_providers() is called ending up
> >> with dca_providers and dca_domain lists emptied. Dca should be prevented from
> >> trying to unregister any provider if dca_domain list is found empty.
> >>
> >> Reported-by: Jiang Liu <jiang.liu@huawei.com>
> >> Tested-by: Gaohuai Han <hangaohuai@huawei.com>
> >> Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
> >> Signed-off-by: Dan Williams <djbw@fb.com>
> >> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>
> >> ---
> >>  drivers/dca/dca-core.c |    5 +++++
> >>  1 file changed, 5 insertions(+)
> >>
> >> --- a/drivers/dca/dca-core.c
> >> +++ b/drivers/dca/dca-core.c
> >> @@ -409,6 +409,11 @@ void unregister_dca_provider(struct dca_
> >>  
> >>  	spin_lock_irqsave(&dca_lock, flags);
> >>  
> >> +	if (list_empty(&dca_domains)) {
> >> +		raw_spin_unlock_irqrestore(&dca_lock, flags);
> > 
> > Hi, this is an incorrect backport. It should be spin_unlock_irqrestore
> > obviously...
> 
> Fix attached.

Thanks, now applied.

greg k-h
