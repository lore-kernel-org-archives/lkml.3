Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaKKKjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:39:14 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:57511 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbaKKKjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:39:12 -0500
Message-ID: <1415702338.2163.5.camel@sipsolutions.net>
Subject: Re: [PATCH 1/1] linux-wireless: Added psk in struct
 cfg80211_connect_params needed for offloading 4way handshake to driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "Gautam (Gautam Kumar) Shukla" <gautams@broadcom.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jithu Jance <jithu@broadcom.com>, Sreenath S <sreenats@broadcom.com>,
        Vladimir Kondratiev <vkondrat@qca.qualcomm.com>
Date: Tue, 11 Nov 2014 11:38:58 +0100
In-Reply-To: <5461E67E.7010408@broadcom.com>
References: <DF163EE1A432BF4BBE6B2088220663A67437BD@SJEXCHMB06.corp.ad.broadcom.com>
		 <1415698161.2163.0.camel@sipsolutions.net> <5461DCC9.5050702@broadcom.com>
	 <1415700220.2163.3.camel@sipsolutions.net> <5461E67E.7010408@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 11:35 +0100, Arend van Spriel wrote:

> What did pop up is the wiphy flags vs. nl80211 feature flags. When that
> comes up it looks like 'potAtoes, potaetoes' to me.
> 
> So is there are clear design rule for when to use which flag. For me the
> wiphy object represents the device/firmware and 4-way handshake offload
> support is determined by what the device/firmware supports.

There are three types of flags:

 * wiphy flag attributes - deprecated as far as I'm concerned
 * wiphy nl80211 feature flags - much easier to use in kernel (and
userspace)
 * nl80211 protocol flags - only one exists
                            (NL80211_PROTOCOL_FEATURE_SPLIT_WIPHY_DUMP)

johannes

