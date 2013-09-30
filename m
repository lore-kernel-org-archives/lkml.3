Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab3I3PFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:05:22 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30698 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab3I3PFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:05:18 -0400
Date: Mon, 30 Sep 2013 17:59:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>, list@osuosl.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>, open@osuosl.org,
        HID CORE LAYER <linux-input@vger.kernel.org>,
        devel@linuxdriverproject.org, thomas@m3y3r.de
Subject: Re: [v3.11][Regression] HID: hyperv: convert alloc+memcpy to memdup
Message-ID: <20130930145939.GK6192@mwanda>
References: <20130916203824.GP25896@mwanda>
 <52376ED9.5080208@canonical.com>
 <20130916210503.GQ25896@mwanda>
 <5237A5D5.8010006@canonical.com>
 <alpine.LNX.2.00.1309241129370.18703@pobox.suse.cz>
 <52432152.3030100@canonical.com>
 <alpine.LNX.2.00.1309271250130.18703@pobox.suse.cz>
 <52459942.3020600@canonical.com>
 <20130927152412.GF6192@mwanda>
 <alpine.LNX.2.00.1309301634260.28935@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1309301634260.28935@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 04:35:47PM +0200, Jiri Kosina wrote:
> On Fri, 27 Sep 2013, Dan Carpenter wrote:
> 
> > It looks like magicmouse_raw_event() returns 1 on success and 0 on
> > failure.
> 
> Good catch indeed.
> 
> I am not completely sure whether we are going to fix an oops or not by 
> this, as I haven't seen the actual oops anywhere in this thread :) But 
> definitely this looks like a good fix.
> 
> Joseph, could you please test with that? Thanks.

In the new code both 0 and 1 are treated the same so this can't fix the
bug.

regards,
dan carpenter
