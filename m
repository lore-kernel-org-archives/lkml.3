Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab3KBUWg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 16:22:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:39263 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab3KBUWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 16:22:35 -0400
Message-ID: <1383423730.4776.16.camel@pasglop>
Subject: Re: Strange location and name for platform  devices when
 device-tree is used.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: NeilBrown <neilb@suse.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Date: Sun, 03 Nov 2013 07:22:10 +1100
In-Reply-To: <20131102155824.GG23938@kroah.com>
References: <20131101145925.66e22f73@notabene.brown>
	 <1383279744.28909.26.camel@pasglop> <1383280054.28909.30.camel@pasglop>
	 <20131101160329.37f3707b@notabene.brown>
	 <1383282516.28909.36.camel@pasglop> <20131101204749.GA19662@kroah.com>
	 <1383347399.28909.46.camel@pasglop> <20131102155824.GG23938@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-11-02 at 08:58 -0700, Greg Kroah-Hartman wrote:
> Just loop through all the platform devices before registering it to
> determine if you need to do this, the platform code can do this just
> fine.  If you try to register a duplicate name with the driver core,
> odds are it will complain loudly, so don't do that.

But that loop + registration is racy ... oh well, we might do something
better with Neil's idea of labels instead.

Ben.


