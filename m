Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab3LSNrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:47:25 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:41308 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab3LSNrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:47:23 -0500
Date: Thu, 19 Dec 2013 08:47:19 -0500
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@aculab.com>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v4 9/9] PCI/MSI: Introduce pci_auto_enable_msi*() family
 helpers
Message-ID: <20131219134719.GA16994@htj.dyndns.org>
References: <cover.1387140921.git.agordeev@redhat.com>
 <bbf6f73ef3e16e5dfd7d41fc1e4412f641acb0f3.1387140921.git.agordeev@redhat.com>
 <20131218003002.GA15119@google.com>
 <20131218132349.GA29552@dhcp-26-207.brq.redhat.com>
 <CAErSpo6Km5N+Cfpaj5JEsb966rwcBjrAT4SFvG6Q9QkwkDFXCA@mail.gmail.com>
 <20131219134244.GA32238@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219134244.GA32238@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 19, 2013 at 02:42:45PM +0100, Alexander Gordeev wrote:
> I have troubles with this fallback logic. On each failed step we get an
> error and we do not know if this is indeed an error or an indication of
> insufficient MSI resources. Even -ENOSPC would not tell much, since it
> could be thrown from a lower level.

Well, it's not hard to define what -ENOSPC should mean.

> By contrast, with the tri-state return value we can distinguish and bail
> out on errors right away.

I kinda like that the available options are listed explicitly on the
caller side (even if it ends up being a loop).  It decreases the
chance of the caller going "oh I didn't expect _that_" and generaly
makes things easier to follow.

> So the above is bit ungraceful for me. Combined with a possible waste in
> logs (if we're hitting the same error) it is quite enough for me to keep
> current the interfaces, at least for a time being.

FWIW, I like Bjorn's suggestion.  Given that this is mostly corner
case thing, it isn't as important as the common ones but we might as
well while we're at it.

Thanks a lot for your work in the area!  :)

-- 
tejun
