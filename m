Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbaHKPMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:12:23 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:56433 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873AbaHKPMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:12:18 -0400
Message-ID: <1407769925.9844.10.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH v2] cfg80211: Try multiple bandwidths when checking
 usable channels.
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Mon, 11 Aug 2014 17:12:05 +0200
In-Reply-To: <1406205820-18152-1-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140724_144351_874544_422BC7B4)
References: <1406205820-18152-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140724_144351_874544_422BC7B4)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-24 at 14:43 +0200, Rostislav Lisovy wrote:
> Current code checks if at least 20MHz bandwidth is allowed for
> particular channel -- if it is not, the channel is disabled.
> This disables usage of 5/10 MHz channels.
> Another issue with the current code is that it may allow a channel
> with bandwidth which is although less or the same as the "maximum
> bandwidth allowed" but overlaps the border of the band.
> 
> The new approach is that there are multiple checks for one channel --
> one for each bandwidth: 5, 10, 20, 40, 80, 160 MHz (when we hit a
> bandwidth that is not allowed, greater bandwidths are automatically
> disabled as well).  This prevents the following scenario to happen:
> The 5 MHz bandwidth channel at the very end of the band is
> successfully checked to fit which is followed by setting flags
> IEEE80211_CHAN_NO_* according to the maximum bandwidth allowed by the
> particular regulatory rule (which may be greater than the 5 MHz).
> When someone will try to use that particular channel with the maximum
> bandwidth allowed (e.g. 20 MHz), the resulting channel will not be in
> the range of the band anymore (will overlap the border).

I really don't know what to do with this. I don't quite understand
what's going on, to be honest.

Luis?

johannes

