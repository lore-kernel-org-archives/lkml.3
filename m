Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab3A3H5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 02:57:48 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:49402 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3A3H5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 02:57:46 -0500
Message-ID: <1359532679.8010.1.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] nl80211: avoid "wdev_id may be used uninitialized"
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Date: Wed, 30 Jan 2013 08:57:59 +0100
In-Reply-To: <1359504662-23561-1-git-send-email-swarren@wwwdotorg.org> (sfid-20130130_011118_335925_03B80596)
References: <1359504662-23561-1-git-send-email-swarren@wwwdotorg.org>
	 (sfid-20130130_011118_335925_03B80596)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-29 at 17:11 -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Silence the following:
> net/wireless/nl80211.c: In function '__cfg80211_wdev_from_attrs.clone.119':
> net/wireless/nl80211.c:57:6: warning: 'wdev_id' may be used uninitialized in this function
> 
> ... by always initializing wdev_id to zero. I assume that wiphy_idx and
> ifidx are set to -1 for similar reasons, so this change simply propagates
> the same workaround.
> 
> In practice, this warning is false, since wdev_id is both set and used
> under the condition if (have_wdev_id). However, at least my compiler
> can't be coerced into realizing this; almost any code between the if
> blocks that set and use the variable causes this warning.

I don't see this warning? What compiler are you using?

johannes

