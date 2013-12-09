Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761587Ab3LIVeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:34:15 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:11792
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753970Ab3LIVeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:34:11 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(z579ehz98dI936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
Message-ID: <1386624837.10013.49.camel@snotra.buserror.net>
Subject: Re: [REPOST][PATCH 1/2] driver core: Add new device_driver flag to
 allow binding via sysfs only
From: Scott Wood <scottwood@freescale.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Kim Phillips <kim.phillips@linaro.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <kvm@vger.kernel.org>,
        <R65777@freescale.com>, <B07421@freescale.com>, <B08248@freescale.com>,
        <christoffer.dall@linaro.org>, <alex.williamson@redhat.com>,
        <a.motakis@virtualopensystems.com>, <agraf@suse.de>,
        <B16395@freescale.com>
Date: Mon, 9 Dec 2013 15:33:57 -0600
In-Reply-To: <52A6162D.7090008@siemens.com>
References: <20131203123446.42fbff34a8ebd7afd38159a5@linaro.org>
	 <529DFA09.1030707@siemens.com>
	 <20131205174530.a1d6e763e423d3baaa5992ad@linaro.org>
	 <1386283095.7375.63.camel@snotra.buserror.net>
	 <20131209125802.0e2b86a3daa9d9ad5a7d43bf@linaro.org>
	 <52A6162D.7090008@siemens.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-09 at 20:12 +0100, Jan Kiszka wrote:
> On 2013-12-09 19:58, Kim Phillips wrote:
> > On Thu, 5 Dec 2013 16:38:15 -0600
> > Scott Wood <scottwood@freescale.com> wrote:
> > 
> >> What would combining them solve, other than making it more likely that
> >> Greg complains about the wildcard because it would no longer be handled
> >> at the bus level where all the other matching goes on?
> >>
> >> They are logically separate things.  That doesn't change just because we
> >> currently plan to use them together.
> > 
> > Jan?  Given the above, what would be the advantage of merging
> > sysfs_bind_only and (PCI drivers' PCI_ANY_ID and platform drivers'
> > match_any_dev)?
> 
> That you cannot configure (likely) meaningless or even harmful (bind-any
> + auto-bind) configurations.

If you want to put in a check that warns on bind-any plus auto-bind,
fine -- but that doesn't mean they should share a mechanism.  It's valid
to have no-auto-bind without a wildcard match.  And FWIW, PCI already
has wildcard matches without any no-auto-bind mechanism (it's presumably
not intended to specify PCI_ANY_ID for all fields, but it is allowed
AFAICT).

-Scott


