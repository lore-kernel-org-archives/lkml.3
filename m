Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaBQK3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 05:29:46 -0500
Received: from smtp.citrix.com ([66.165.176.89]:54222 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbaBQK3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:29:45 -0500
X-IronPort-AV: E=Sophos;i="4.95,859,1384300800"; 
   d="scan'208";a="103127274"
Message-ID: <5301E496.40802@citrix.com>
Date: Mon, 17 Feb 2014 10:29:42 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: <netdev@vger.kernel.org>, Wei Liu <wei.liu2@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>, <kvm@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>, <linux-kernel@vger.kernel.org>,
        Paul Durrant <Paul.Durrant@citrix.com>,
        <xen-devel@lists.xenproject.org>
Subject: Re: [Xen-devel] [RFC v2 3/4] xen-netback: use a random MAC address
References: <1392433180-16052-1-git-send-email-mcgrof@do-not-panic.com> <1392433180-16052-4-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1392433180-16052-4-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/02/14 02:59, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> The purpose of using a static MAC address of FE:FF:FF:FF:FF:FF
> was to prevent our backend interfaces from being used by the
> bridge and nominating our interface as a root bridge. This was
> possible given that the bridge code will use the lowest MAC
> address for a port once a new interface gets added to the bridge.
> The bridge code has a generic feature now to allow interfaces
> to opt out from root bridge nominations, use that instead.
[...]
> --- a/drivers/net/xen-netback/interface.c
> +++ b/drivers/net/xen-netback/interface.c
> @@ -42,6 +42,8 @@
>  #define XENVIF_QUEUE_LENGTH 32
>  #define XENVIF_NAPI_WEIGHT  64
>  
> +static const u8 xen_oui[3] = { 0x00, 0x16, 0x3e };

You shouldn't use a vendor prefix with a random MAC address.  You should
set the locally administered bit and clear the multicast/unicast bit and
randomize the remaining 46 bits.

(If existing VIF scripts are doing something similar, they also need to
be fixed.)

David
