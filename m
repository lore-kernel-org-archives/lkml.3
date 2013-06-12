Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab3FLQ0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 12:26:05 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46804 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754246Ab3FLQ0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 12:26:02 -0400
Message-ID: <1371054361.2069.17.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: forgive use of mixed case variables
 measuring units
From: Joe Perches <joe@perches.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Phil Carmody <phil.carmody@partner.samsung.com>, apw@canonical.com,
        linux-kernel@vger.kernel.org
Date: Wed, 12 Jun 2013 09:26:01 -0700
In-Reply-To: <20130612161758.GU23859@titan.lakedaemon.net>
References: <1369825370-31901-1-git-send-email-phil.carmody@partner.samsung.com>
	 <1369826652.22004.106.camel@joe-AO722>
	 <003601ce676c$a92360c0$fb6a2240$%carmody@partner.samsung.com>
	 <1371052935.2069.14.camel@joe-AO722>
	 <20130612161758.GU23859@titan.lakedaemon.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-12 at 12:17 -0400, Jason Cooper wrote:
> On Wed, Jun 12, 2013 at 09:02:15AM -0700, Joe Perches wrote:
> > On Wed, 2013-06-12 at 15:59 +0300, Phil Carmody wrote:
> > > I agree that a creeping list of exceptions where CamelCase
> > > is to be overlooked would be bad, but I would argue that 
> > > perhaps my exceptions aren't actual CamelCase - they're
> > > (pretending to be) SI units, and just happen to match the
> > > CamelCase regexp. I did a grep for my regexp, and everything
> > > I noticed in a quick scan did look like a justifiable 
> > > variable name.
> > 
> > Maybe, but this regex misses variants like:
> > 
> > regulator_min_uA_show
> > 
> > Maybe "^[a-z_]*_[numk][VAS](?:_\w+)?$"
> > 
> > But this regex also does not match on other common
> > sound variants "_dB", "_mB" and temperature like "_mC".
> 
> And _dBm ...

As far as I can tell, all those uses are either in staging
or are in obsolete/superceded code.

There is one I think ugly variant that could be fixed:

drivers/media/dvb-frontends/stv0367_priv.h:     s32 Power_dBmx10;       /* Power of the RF signal (dBm x 10) */


