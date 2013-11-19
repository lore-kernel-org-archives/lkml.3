Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab3KSCTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 21:19:52 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:49154
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557Ab3KSCTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 21:19:49 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzzz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 19 Nov 2013 10:21:35 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Nishanth Menon <nm@ti.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Carlos Hernandez <ceh@ti.com>
Subject: Re: [PATCH] cpufreq: cpufreq-cpu0: Use a sane boot frequency when
 booting with a mismatched bootloader configuration
Message-ID: <20131119022133.GB18434@S2101-09.ap.freescale.net>
References: <1384568535-26611-1-git-send-email-nm@ti.com>
 <20131116134445.GI11014@S2101-09.ap.freescale.net>
 <CAKohponU-WFnG8Gx6ba=k3eJmWV_0eWtpsy9kDP8yA2KrdoKtg@mail.gmail.com>
 <528A27F8.3070402@ti.com>
 <20131118155753.GU11014@S2101-09.ap.freescale.net>
 <528A4340.3020508@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <528A4340.3020508@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 10:41:36AM -0600, Nishanth Menon wrote:
> In the case of mismatch, to consider that device tree may be wrong in
> driver is also to assume that hardware was always configured correctly
> and we assume description is the flawed data.

No, I did not say that.  IMO, when cpufreq-cpu0 sees a mismatch, it has
no way to know or assume which one is correct and which is incorrect.
The best thing it can do is to fail out without changing anything about
running frequency and voltage.

Shawn

> That is just plain
> wrong. we need to assume device tree is the correct description of the
> hardware and any mismatch must be assumed as bad configuration - and
> this is what the patch does.
> 
> Now, if the description is wrong, that is a dts bug of it's own.
> 
> If the suggestion is to improve my commit message, I am more than
> happy to do so - please suggest how I could improve the same.

