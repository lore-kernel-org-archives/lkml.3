Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945973Ab3BGW5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:57:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:17519 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945894Ab3BGW5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:57:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,625,1355126400"; 
   d="scan'208";a="282380173"
Date: Thu, 7 Feb 2013 23:57:38 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tomas Winkler <tomas.winkler@intel.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 05/11] mei: bus: Call bus routines from the core
 code
Message-ID: <20130207225738.GF5072@sortiz-mobl>
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com>
 <1360270997-7639-6-git-send-email-tomas.winkler@intel.com>
 <201302072237.31048.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302072237.31048.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thu, Feb 07, 2013 at 10:37:30PM +0000, Arnd Bergmann wrote:
> On Thursday 07 February 2013, Tomas Winkler wrote:
> > @@ -197,6 +197,9 @@ static int mei_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >         mei_pdev = pdev;
> >         pci_set_drvdata(pdev, dev);
> >  
> > +       err = mei_bus_init(mei_pdev);
> > +       if (err)
> > +               goto deregister_mei;
> >  
> >         schedule_delayed_work(&dev->timer_work, HZ);
> >  
> 
> This is fairly unusual, and will break if you ever have multiple mei devices
> in one system, because you end up registering the bus type for each
> device. I think it would be more logical to register/unregister
> the bus_type from the module_init/exit functions of the module
> that contains the bus_type object.
That makes sense, I'll fix that.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
