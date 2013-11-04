Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab3KDQcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:32:00 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:42398 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3KDQb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:31:59 -0500
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v4)
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        Frank Haverkamp <haver@vnet.ibm.com>
In-Reply-To: <20131030173722.GD20147@kroah.com>
References: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com>
	 <1383125578-26202-2-git-send-email-haver@linux.vnet.ibm.com>
	 <20131030173722.GD20147@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Mon, 04 Nov 2013 17:30:34 +0100
Message-ID: <1383582634.15642.18.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110416-0342-0000-0000-000006C036DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Am Mittwoch, den 30.10.2013, 10:37 -0700 schrieb Greg KH:
> On Wed, Oct 30, 2013 at 10:32:58AM +0100, Frank Haverkamp wrote:
> > +/*
> > + * We like to be able to disable the health checking entirely in some
> > + * cases e.g. if a card is broken and needs to be analyzed. I
> > + * considered using debugfs/sysfs attributes, but I did not see a way
> > + * to prevent the thread from being started at driver load time other
> > + * than starting it later manually, what I did not like either
> > + * in this case (e.g. like the new SRIOV enablement).
> > + */
> > +static int genwqe_health_check_interval = 4;   /* <= 0: disabled */
> > +module_param(genwqe_health_check_interval, int, 0644);  /* read/writeable */
> > +MODULE_PARM_DESC(genwqe_health_check_interval,
> > +		 "check card health every N seconds (0 = disabled)");
> 
> Module paramaters are driver wide, not device specific.
> 
> If a card is broken, it's broken, send it back.  No one will ever know
> to set this value, and then you just affected all other cards in the
> system for this same driver.
> 
> Just delete this please.
> 
> thanks,
> 
> greg k-h
> 

Finally I removed all my module parameters or replaced them by debugfs
or sysfs attributes.

Regards

Frank



