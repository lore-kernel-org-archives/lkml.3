Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304Ab3DINGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:06:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63271 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758447Ab3DINGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:06:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 1/2] dma: of: Add generic xlate function for matching by channel id
Date: Tue, 9 Apr 2013 15:06:02 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jon Hunter <jon-hunter@ti.com>, Padmavathi Venna <padma.v@samsung.com>,
        linux-kernel@vger.kernel.org
References: <1364217412-31905-1-git-send-email-lars@metafoo.de> <20130409112816.GH31193@intel.com> <51640B48.5060506@metafoo.de>
In-Reply-To: <51640B48.5060506@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304091506.02329.arnd@arndb.de>
X-Provags-ID: V02:K0:/rVs1319XINOahc7MHNRlsWHvPkbVbW46nFDqHT0AE+
 a9uetSKcPhq+o0OXo+4w3cKJC8JVSfazrF1LHuQ+kERnlpOC3p
 bfnmTuX8rjGtp6cvANU690OJXDrgtPtZAVpRW5sQ35T1r996aP
 xKiv8HF1qBoFhbC5pQ5DU7AVKTHsHlp3cYcoOaKEghcWEKVmRI
 tkxjfmRenKMvkDFF5vm6py8WDdnvaAzWqNBFtkrk3E2WucTXZ2
 +4cOj9m5+ABP88hQnndk/l0IfmPS5GYudh/Aw3Ua+GO26w3T2x
 bkK7+2fbEpl6mxY96nk8rqZbgj2gKjBrPqTTFgPZLnzb9o3CZ8
 5s2feTjT4mla0vu/3LVA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 April 2013, Lars-Peter Clausen wrote:
> On 04/09/2013 01:28 PM, Vinod Koul wrote:
> > On Sat, Mar 30, 2013 at 09:38:54AM +0100, Lars-Peter Clausen wrote:
> >> On 03/29/2013 10:49 PM, Vinod Koul wrote:
> >>> On Mon, Mar 25, 2013 at 02:16:51PM +0100, Lars-Peter Clausen wrote:
> >>>> This patch adds a new generic of dma xlate callback function which will match a
> >>>> channel by its id.
> >>> how will the client know which "id" to request? 
> >>
> >> The devicetree tells it, or what exactly do you mean?
> > Is this global id? Anrd, what does the id mean in DT?
> 
> It's more or less a device specific cookie. And in this case we are using a
> 1 to 1 mapping to the channel number.

To clarify this some more: The slave driver uses a name that is defined in the
binding of for the slave device to request a specific channel. This is typically
something trivial like "rx" or "data" that defines how the slave driver knows
its channel.

This gets passed to the dmaengine core, which looks up a dmaengine driver specific
description of a channel, using the name and the slave device pointer as keys.
Normally this is just a request number, sometimes it can be a combinattion
of request number with some other data like a master number or the DMA direction,
if the dmaengine driver requires that information in order to allocate the channel.

In this specific case, it is the chan_id number, which is correct for any driver
that uses the same number for slave_id and chan_id. It may be an exaggeration 
to call it "generic", since this only works for a few dmaengine drivers, but
it's reasonable to have this kind of helper in common code since there are
multiple drivers with the same characteristic.

	Arnd
