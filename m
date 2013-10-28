Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab3J1OVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:21:19 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:34271 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab3J1OVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:21:18 -0400
Message-ID: <1382970069.17956.23.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 3.12] cfg80211: fix ibss wext chandef creation
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: linux-wireless@vger.kernel.org,
        Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
        Dirk Gouders <dirk@gouders.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Mon, 28 Oct 2013 15:21:09 +0100
In-Reply-To: <1382472166-19563-1-git-send-email-sw@simonwunderlich.de> (sfid-20131022_221235_343937_76CC3A81)
References: <1382472166-19563-1-git-send-email-sw@simonwunderlich.de>
	 (sfid-20131022_221235_343937_76CC3A81)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-22 at 22:02 +0200, Simon Wunderlich wrote:
> The wext internal chandefs for ibss should be created using the
> cfg80211_chandef_create() functions. Otherwise the center_freq1 field
> will not be set and cfg80211_chandef_valid() will spit a warning and
> report the chandef as invalid when it should be used.

I think

commit f478f33a93f9353dcd1fe55445343d76b1c3f84a
Author: Bruno Randolf <br1@einfach.org>
Date:   Thu Sep 26 16:55:28 2013 +0100

    cfg80211: fix warning when using WEXT for IBSS


already fixed this. Your patch doesn't apply, but feel free to send me a
new one (for -next) converting to the creation helpers.

johannes

