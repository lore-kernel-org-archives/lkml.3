Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaIAMm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:42:29 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:47527 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbaIAMm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:42:27 -0400
Message-ID: <1409575342.2703.4.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 2/2] nl80211.c: Fixed the wdev_id being used
 uninitialized.
From: Johannes Berg <johannes@sipsolutions.net>
To: Shakil A Khan <shakilk1729@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, linville@tuxdriver.com
Date: Mon, 01 Sep 2014 14:42:22 +0200
In-Reply-To: <201409010833.10647.shakilk1729@gmail.com> (sfid-20140901_143315_542502_C9A8C225)
References: <1409572467-50908-1-git-send-email-shakilk1729@gmail.com>
	 <1409573258.2703.0.camel@jlt4.sipsolutions.net>
	 <201409010833.10647.shakilk1729@gmail.com>
	 (sfid-20140901_143315_542502_C9A8C225)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-01 at 08:33 -0400, Shakil A Khan wrote:
> On Monday 01 September 2014 08:07:38 Johannes Berg wrote:
> > > +	u64 wdev_id = 0;
> > 
> > it's not used uninitialized, NACK.
> > 
> > johannes
> > 
> 
> wdev_id can be used uninitialized if  have_wdev_id turns to be false,
> which may happen if the entry for NL80211_ATTR_WDEV is removed in
> future. Who knows.

In which case the compiler will warn about it. If you were to use a
newer compiler now, you wouldn't see the warning.

johannes


