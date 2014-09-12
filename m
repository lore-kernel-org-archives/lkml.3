Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbaILOHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:07:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:57496 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632AbaILOHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:07:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,513,1406617200"; 
   d="scan'208";a="602014872"
Date: Fri, 12 Sep 2014 17:07:20 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/6] phy: improved lookup method
Message-ID: <20140912140720.GC30816@xps8300>
References: <1408620803-10464-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1408620803-10464-3-git-send-email-heikki.krogerus@linux.intel.com>
 <5411C0B2.3060505@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5411C0B2.3060505@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 09:03:06PM +0530, Kishon Vijay Abraham I wrote:
> > +static struct phy *phy_find(struct device *dev, const char *con_id)
> > +{
> > +	const char *dev_id = dev ? dev_name(dev) : NULL;
> > +	int match, best_found = 0, best_possible = 0;
> > +	struct phy *phy = ERR_PTR(-ENODEV);
> > +	struct phy_lookup *p, *pl = NULL;
> > +
> > +	if (dev_id)
> > +		best_possible += 2;
> > +	if (con_id)
> > +		best_possible += 1;
> > +
> > +	list_for_each_entry(p, &phys, node) {
> > +		match = 0;
> > +		if (p->dev_id) {
> > +			if (!dev_id || strcmp(p->dev_id, dev_id))
> > +				continue;
> > +			match += 2;
> > +		}
> > +		if (p->con_id) {
> > +			if (!con_id || strcmp(p->con_id, con_id))
> > +				continue;
> > +			match += 1;
> > +		}
> > +
> > +		if (match > best_found) {
> > +			pl = p;
> > +			if (match != best_possible)
> > +				best_found = match;
> > +			else
> > +				break;
> > +		}
> > +	}
> > +
> > +	if (pl) {
> > +		struct class_dev_iter iter;
> > +		struct device *phy_dev;
> > +
> > +		class_dev_iter_init(&iter, phy_class, NULL, NULL);
> > +		while ((phy_dev = class_dev_iter_next(&iter))) {
> > +			if (!strcmp(dev_name(phy_dev), pl->phy_name)) {
> 
> I'm not sure how it'll work with systems which has multiple PHYs since the "id"
> component of the device is determined purely in runtime.
> 
> I'd assume we'll be constantly patching the lookup data for non-dt boot :-/

I'm sorry but I don't think I understand (I must be a bit tired
today)? Could you please elaborate?


Have a nice weekend!

-- 
heikki
