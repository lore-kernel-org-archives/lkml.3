Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab3LRJQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:16:47 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:22669 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab3LRJQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:16:43 -0500
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="3702356"
Message-ID: <52B167F6.5060209@broadcom.com>
Date: Wed, 18 Dec 2013 10:16:38 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Sander Eikelenboom <linux@eikelenboom.it>
CC: Ben Hutchings <ben@decadent.org.uk>,
        Julian Calaby <julian.calaby@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Avinash Patil <avinashapatil@gmail.com>
Subject: Re: [cfg80211 / iwlwifi] setting wireless regulatory domain doesn't
 work.
References: <1342235583.20131211182804@eikelenboom.it>	<CAB=NE6UfumA2xez1DvtDSBDZ72WF_tOozFo_8LRnMryYiSqD-A@mail.gmail.com>	<871324710.20131211191104@eikelenboom.it>	<CAB=NE6XRnE0j9NMW0K1vKzEO9v70arSH4YXZjudqa0ZxiLB4AA@mail.gmail.com>	<1937118387.20131216122200@eikelenboom.it>	<52AEE60B.6030509@broadcom.com>	<19210260274.20131216135644@eikelenboom.it>	<CAGRGNgXHemM2FfnXgW5RbzhFT+9SfUfVkjdysK3+=_u3hWSacw@mail.gmail.com>	<1534126119.20131217104548@eikelenboom.it>	<387552477.20131217213319@eikelenboom.it>	<20131217212709.GB5624@decadent.org.uk>	<1254825772.20131217224914@eikelenboom.it> <CA+55aFxQg6=MAWEkEGz64Hz8OawvPyX=fpBOjY8cGBL5XgB9WQ@mail.gmail.com>
In-Reply-To: <CA+55aFxQg6=MAWEkEGz64Hz8OawvPyX=fpBOjY8cGBL5XgB9WQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 11:06 PM, Linus Torvalds wrote:
> We have literally had this *exact* same issue with firmware loading.
> Network drivers shouldn't try to load firmware at module load time.
> Same deal.

It is kind of a chicken and egg problem for (wireless) networking
drivers. To get IFF_UP from the network layer you have to register a
netdevice. For wireless drivers this means you have to register a wiphy
device with cfg80211 which flags capabilities and optionally are custom
regulatory domain. That information depends on the device and firmware
used. And there we have a full circle.

Regards,
Arend
