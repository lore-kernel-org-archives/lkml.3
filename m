Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab3DRHDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 03:03:32 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:64724 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab3DRHDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 03:03:31 -0400
MIME-Version: 1.0
In-Reply-To: <BF64DFEC-CFE7-4A89-B251-8E9AF3E44642@holtmann.org>
References: <1366236369-543-1-git-send-email-bzhao@marvell.com>
	<1366236590.8217.64.camel@jlt4.sipsolutions.net>
	<516F8F4B.1000504@lri.fr>
	<BF64DFEC-CFE7-4A89-B251-8E9AF3E44642@holtmann.org>
Date: Thu, 18 Apr 2013 00:03:30 -0700
X-Google-Sender-Auth: LvzziqorD7-3p2gXO-3Ts8UjnDg
Message-ID: <CAMcMvsiW5KQmZq9VgdNOOG+7y-ZWO1yCsv4BD7iFQrR+wcHQ3w@mail.gmail.com>
Subject: Re: [PATCH] net-sysfs: Add entry for nl80211 interface type
From: Paul Stewart <pstew@chromium.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bing Zhao <bzhao@marvell.com>, linux-netdev@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original reason to request this change was simple: to figure out
what type of interface we are looking at, since now some wireless
drivers can simultaneously create managed, p2p and ap interfaces.
Knowing that, from a simple front-end (let's even say a shell script)
we can decide what arguments to use with wpa_supplicant (or indeed if
we want to start it on this interface).  wpa_supplicant, of course,
knows how to manipulate the device further using nl80211.  I thought
it was a bit onerous to force userspace all the way through nl80211
just to get this trivial piece of information, but apparently this
doesn't seem to be the common point of view.

--
Paul

On Wed, Apr 17, 2013 at 11:43 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Nicolas,
>
>>>> Add a "wireless/nl80211_iftype" entry in the net device sysfs
>>>> file structure to indicate the mode of the wireless device so
>>>> it can be discovered easily from userspace.
>>>
>>> What's wrong with "iw dev", i.e. netlink/nl80211?
>>
>> "Do NOT screenscrape this tool, we don't consider its output stable."
>>
>> So if you are in a shell script, you're basically screwed.
>
> if you are in a shell script, you are screwed no matter what. So what is your point?
>
> Regards
>
> Marcel
>
>
