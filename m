Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaBLKq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:46:57 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:54362 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaBLKqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:46:54 -0500
Message-ID: <1392202001.4146.11.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH v4] ieee80211: Print human-readable disassoc/deauth
 reason codes
From: Johannes Berg <johannes@sipsolutions.net>
To: Calvin Owens <jcalvinowens@gmail.com>
Cc: Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 12 Feb 2014 11:46:41 +0100
In-Reply-To: <20140211183624.GA2291@gmail.com> (sfid-20140211_193654_194490_DD27EA29)
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
	 <1391661863.30094.56.camel@joe-AO722>
	 <1392030546.4128.11.camel@jlt4.sipsolutions.net>
	 <1392050359.2507.10.camel@joe-AO722> <20140211012523.GA2739@gmail.com>
	 <1392082740.2507.49.camel@joe-AO722> <20140211163738.GA32043@gmail.com>
	 <1392138837.2511.2.camel@joe-AO722> <20140211175232.GA782@gmail.com>
	 <20140211183624.GA2291@gmail.com> (sfid-20140211_193654_194490_DD27EA29)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 12:36 -0600, Calvin Owens wrote:
> Create a function to return a descriptive string for each reason code,
> and print that in addition to the numeric value in the kernel log. These
> codes are easily found on popular search engines, but one is generally
> not able to access the internet when dealing with wireless connectivity
> issues.

Applied.

> Changes in v2: Refactored array of strings into switch statement.
> Changes in v3: Fix style problem, use simplifying macro for switch
> statement, eliminate temporary enum variable.
> Changes in v4: Move new function to net/mac80211/mlme.c and make it
> static, since all of its callers are there.

I removed all this, it belongs after the --- imho.

> +	default: return "<INVALID>";

There are many more valid reason codes that this function doesn't
understand, so <invalid> is misleading, I replaced that by "<unknown>". 

johannes

