Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967582Ab3DRPqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:46:48 -0400
Received: from senator.holtmann.net ([87.106.208.187]:43055 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967423Ab3DRPqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:46:47 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [PATCH] net-sysfs: Add entry for nl80211 interface type
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CAMcMvsiW5KQmZq9VgdNOOG+7y-ZWO1yCsv4BD7iFQrR+wcHQ3w@mail.gmail.com>
Date: Thu, 18 Apr 2013 08:46:40 -0700
Cc: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bing Zhao <bzhao@marvell.com>, linux-netdev@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <05ECA628-AE4D-48A2-A743-4C800052F439@holtmann.org>
References: <1366236369-543-1-git-send-email-bzhao@marvell.com> <1366236590.8217.64.camel@jlt4.sipsolutions.net> <516F8F4B.1000504@lri.fr> <BF64DFEC-CFE7-4A89-B251-8E9AF3E44642@holtmann.org> <CAMcMvsiW5KQmZq9VgdNOOG+7y-ZWO1yCsv4BD7iFQrR+wcHQ3w@mail.gmail.com>
To: Paul Stewart <pstew@chromium.org>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

> The original reason to request this change was simple: to figure out
> what type of interface we are looking at, since now some wireless
> drivers can simultaneously create managed, p2p and ap interfaces.
> Knowing that, from a simple front-end (let's even say a shell script)
> we can decide what arguments to use with wpa_supplicant (or indeed if
> we want to start it on this interface).  wpa_supplicant, of course,
> knows how to manipulate the device further using nl80211.  I thought
> it was a bit onerous to force userspace all the way through nl80211
> just to get this trivial piece of information, but apparently this
> doesn't seem to be the common point of view.

quite frankly this is a design issue with wpa_supplicant since it refuses to manage the wireless devices and interfaces. If you would have a real daemon that manages the wireless device via nl80211, then you would never ever have this problem. All the information are available via nl80211.

However my point is that you can not just base this around netdev exposed interfaces. The netdev interface might not even be present. Especially when talking about P2P you might not have a netdev in the first place. You only have a wdev.

Regards

Marcel

