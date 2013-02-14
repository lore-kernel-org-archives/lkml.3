Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab3BNGfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 01:35:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:23597 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab3BNGfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 01:35:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,662,1355126400"; 
   d="scan'208";a="262464834"
Message-ID: <1360823765.12703.153.camel@sauron.fi.intel.com>
Subject: Re: SELinux + ubifs: possible circular locking dependency
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-mtd@lists.infradead.org, linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Date: Thu, 14 Feb 2013 08:36:05 +0200
In-Reply-To: <511BA51E.9000606@pengutronix.de>
References: <51123C80.2050400@pengutronix.de>
	  <5115076E.3070703@pengutronix.de>
	 <1360759673.12703.147.camel@sauron.fi.intel.com>
	 <511BA51E.9000606@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 15:37 +0100, Marc Kleine-Budde wrote:
> > +	lockdep_set_class(&isec->lock, inode->i_sb->s_type->i_mutex_key);
> 
> So I added an "&", so that the line looks like that:

Yeah, I did not compile it, and for the deadlock of course I have to add
own class for isec->lock in the fstype structure. I'll try to come up
with another patch. Thanks!

-- 
Best Regards,
Artem Bityutskiy

