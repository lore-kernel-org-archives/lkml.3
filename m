Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab3LSWFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:05:52 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:62127 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab3LSWFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:05:50 -0500
Message-ID: <1387490744.1876.52.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH net-next] hyperv: Add support for Virtual Receive Side
 Scaling (vRSS)
From: Ben Hutchings <bhutchings@solarflare.com>
To: Tom Herbert <therbert@google.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Date: Thu, 19 Dec 2013 22:05:44 +0000
In-Reply-To: <CA+mtBx_SSPd6s5519dWCyPGmFvO=kE+Fh3ZQ9w9oo=pJraRAFQ@mail.gmail.com>
References: <1387405262-18334-1-git-send-email-haiyangz@microsoft.com>
	 <1387475178.1876.29.camel@bwh-desktop.uk.level5networks.com>
	 <ff7f7541d0164d408b3a4278569c593a@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
	 <52B33EC1.5040901@redhat.com>
	 <6ee28c6a94e74c958ee96c3547741fb9@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
	 <CA+mtBx-BBBQjVTOrnaow=GNc7VM5D2Zj8xr=fPM4b4f_xT7qkQ@mail.gmail.com>
	 <05be4f23ff784e56b710dd02eb88358a@DFM-DB3MBX15-08.exchange.corp.microsoft.com>
	 <CA+mtBx_SSPd6s5519dWCyPGmFvO=kE+Fh3ZQ9w9oo=pJraRAFQ@mail.gmail.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20370.002
X-TM-AS-Result: No--8.199800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 13:43 -0800, Tom Herbert wrote:
> Patch is below. This version did most pre-computation of the variants
> I built, but results in largest table (40*256*4 bytes), This gives
> performance roughly comparable with jhash (roughly same as jhash for
> IPv4, about 30% more cycles for IPv6). I have the simpler less memory
> intensive versions also if you're interested, these are 10x worse
> cycles so I wouldn't want those in critical path.
> ----
> Introduce Toeplitz hash functions. Toeplitz is a hash used primarily in
> NICs to performan RSS flow steering.  This is a software implemenation
> of that. In order to make the hash calculation efficient, we precompute
> the possible hash values for each inidividual byte of input. The input
> length is up to 40 bytes, so we make an array of cache[40][256].
[...]

You haven't addressed my comments here:
<http://article.gmane.org/gmane.linux.network/284753>

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

