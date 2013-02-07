Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab3BFRAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:00:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:65427 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3BFRAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:00:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: devicetree-discuss@lists.ozlabs.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg KH <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-tegra@vger.kernel.org,
        Andrew Murray <andrew.murray@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 06/14] ARM: pci: Keep pci_common_init() around after init
Date: Thu, 07 Feb 2013 01:54:22 +0100
Message-ID: <9348609.HjKCmL9u9S@wuerfel>
User-Agent: KMail/4.10 rc3 (Linux/3.8.0-3-generic; KDE/4.9.98; x86_64; ; )
In-Reply-To: <CACRpkdYV5w6BksUjXvXs=88BovUyXgRt-vXSD0twjRpzbZcvFQ@mail.gmail.com>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <1357764194-12677-7-git-send-email-thierry.reding@avionic-design.de> <CACRpkdYV5w6BksUjXvXs=88BovUyXgRt-vXSD0twjRpzbZcvFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:uhoa/l6fAq4/YBeNS6dsqJMe56J2fFvMQEHwH1sayGR
 ceWZlSry4m9EnnktbRj8gRuTJy1TfSVCBxC9JGdEeXvld/vZUI
 3yfV42cZZsZnlOPg0KBpkusBfqK5JEgzxrQmo6llZxMibXcH4Y
 To0JB7vKM5M8JyjYFh36A0sZVR1WXukCFgVlorTQdlj7nugzSI
 dby7HCiUA3IsI+n5vWCVSezbPtrd1T8LukZmNNuHam7+eFXwqe
 zMMXvDZhX6SMMRGfCAF0ZzKHvCG7pL95pvx4kO0vsVoaTTc1B+
 8LMmYD8Z2NKqO4cwigsY0Kdzp1MVGJYbYv1/esYEgBh4aEOWyw
 h4Fud+4jjZb7ZLnWjO9c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2013 17:38:20 Linus Walleij wrote:
> On Wed, Jan 9, 2013 at 9:43 PM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> 
> > When using deferred driver probing, PCI host controller drivers may
> > actually require this function after the init stage.
> >
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> 
> There seem to be a proliferation of these patches now.
> 
> Isn't this just papering over the real problem? The discarding
> of __init sections need to happen *after* all deferred probes
> are complete, lest we have to remove *all* __init sections from
> *all* drivers in the kernel, don't we?

No, I think it's not quite that bad. I think the rule is still
just that .probe() functions and anything called from them must
not be __init. They used to be __devinit, which would cause
problems with deferred probing on !HOTPLUG systems but that's
gone in 3.9.

Thierry's patch is just necessary because pci_common_init used
to be called only from actual __init functions, and not it
gets called from a .probe() function for the first time.

	Arnd
