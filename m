Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbaGUNST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:18:19 -0400
Received: from tango.0pointer.de ([85.214.72.216]:46896 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbaGUNSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:18:18 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jul 2014 09:18:17 EDT
Date: Mon, 21 Jul 2014 15:11:54 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: "Yue Zhang (OSTC DEV)" <yuezha@microsoft.com>
Cc: Tom Gundersen <teg@jklm.no>, netdev <netdev@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        David Miller <davem@davemloft.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>, Thomas Shao <huishao@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>
Subject: Re: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
Message-ID: <20140721131154.GA23385@tango.0pointer.de>
References: <1405680903-28176-1-git-send-email-yuezha@microsoft.com>
 <CAG-2HqXFBUmpTAE8h13-DmP6Fq42viHzmuH9OfNoLgjW8XcQ3Q@mail.gmail.com>
 <DC7803B42427924284F2D5252E076A3B4476A6D1@SINEX14MBXC416.southpacific.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DC7803B42427924284F2D5252E076A3B4476A6D1@SINEX14MBXC416.southpacific.corp.microsoft.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21.07.14 10:21, Yue Zhang (OSTC DEV) (yuezha@microsoft.com) wrote:

> Some network monitoring daemon, like ifplugd has a deferring mechanism.
> When it detects carriers is offline, it doesn't trigger DHCP renew immediately. 
> Instead it will wait for another 5 seconds to check whether carrier is back to 
> online status. In that case, it will avoid renew DHCP lease.

ifplugd doesn't renew DHCP leases anyway, one of the scripts it invokes
does.

ifplugd is obsolete software. I wrote it more than 10 years ago, and
haven't really updated it since. it's sounds seriously wrong to add
multi-second waits to the kernel just to make this crappy, obsolete
software work.

Please fix this properly, and work with the PM guys, so that we get a
sane userspace how the kernel can notify userspace about
suspends/hibernations triggered from the outside, so that userspace
daemons can subscribe to that and then refresh the DHCP leases on their
own.

Lennart

-- 
Lennart Poettering, Red Hat
