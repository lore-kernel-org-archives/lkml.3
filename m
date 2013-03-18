Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab3CRNuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:50:10 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4850 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab3CRNuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:50:07 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <51471B85.5060404@broadcom.com>
Date: Mon, 18 Mar 2013 14:49:57 +0100
From: "Piotr Haber" <phaber@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US;
 rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: "David Herrmann" <dh.herrmann@gmail.com>
cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Arend van Spriel" <arend@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org,
        "Pieter-Paul Giesberts" <pieterpg@broadcom.com>
Subject: Re: [PATCH regression/bisected] Revert
 "brcmsmac: support 4313iPA"
References: <1363603503-2378-1-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1363603503-2378-1-git-send-email-dh.herrmann@gmail.com>
X-Enigmail-Version: 1.1.1
X-WSS-ID: 7D59C6643YC3521136-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/13 11:45, David Herrmann wrote:
> This reverts commit b6fc28a158076ca2764edc9a6d1e1402f56e1c0c. It breaks
> wireless AP reconnection on: (14e4:4727)
>   Broadcom Corporation BCM4313 802.11b/g/n Wireless LAN Controller
> 
> Any attempt to reconnect to an AP results in timeouts no matter how near to the
> AP I am:
>  00:10:40 $nb kernel: wlan0: authenticate with 00:18:39:0a:8e:23
>  00:10:40 $nb kernel: wlan0: direct probe to 00:18:39:0a:8e:23 (try 1/3)
>  00:10:40 $nb kernel: wlan0: direct probe to 00:18:39:0a:8e:23 (try 2/3)
>  00:10:41 $nb kernel: wlan0: direct probe to 00:18:39:0a:8e:23 (try 3/3)
>  00:10:41 $nb kernel: wlan0: authentication with 00:18:39:0a:8e:23 timed out
> ---
> Hi
> 
> I tried coming up with a fix instead of reverting this commit, but the commit is
> way to big for me to understand what's going on. Sorry.
> 
> With linux-3.8 connecting to an AP broke on my machine. I could connect to an AP
> one time, but any further attempt resulted in:
>  00:10:40 $nb kernel: wlan0: authenticate with 00:18:39:0a:8e:23
>  00:10:40 $nb kernel: wlan0: direct probe to 00:18:39:0a:8e:23 (try 1/3)
>  00:10:40 $nb kernel: wlan0: direct probe to 00:18:39:0a:8e:23 (try 2/3)
>  00:10:41 $nb kernel: wlan0: direct probe to 00:18:39:0a:8e:23 (try 3/3)
>  00:10:41 $nb kernel: wlan0: authentication with 00:18:39:0a:8e:23 timed out
> 
> Even sitting right next to the AP didn't help so I started bisecting and it
> turned out to be:
>   "brcmsmac: support 4313iPA" b6fc28a158076ca2764edc9a6d1e1402f56e1c0c
> Please revert it.
> 
> Thanks
> David
> 
Hi,
unfortunately this is not a first report of this patch breaking 4313 for some users.
I'm pretty confident that it is hardware revision related as we have 4313ePA and iPA boards running
successfully in our test setup.
Could you aid us in effort of finding the problem by supplying the contents of this debugfs file:
<debugfs_mount>/brcmsmac/bcma0:0/hardware

Piotr





