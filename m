Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab3J3NYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:24:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53843 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab3J3NYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:24:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Walker <dwalker@fifo99.com>
Subject: Re: [PATCH 3/4] ARM: msm: Remove 7x30 supporty
Date: Wed, 30 Oct 2013 14:23:21 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1382993006-27359-1-git-send-email-davidb@codeaurora.org> <1382993006-27359-4-git-send-email-davidb@codeaurora.org> <20131029211554.GA16284@fifo99.com>
In-Reply-To: <20131029211554.GA16284@fifo99.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201310301423.21711.arnd@arndb.de>
X-Provags-ID: V02:K0:cyZ8U+qO9m+GGnEG1qgkrDfl0CmAtEeFnPQsdwchVYM
 14mdAnzy+VlPOJG8fkxIxqLsefvRtzw799ZI2SxP4VAA902wsl
 cukamaA2Rk8zGaAthqWYfciQcgDfh7kpL2bIVwEWuch9FADekF
 oLrudyfnf+2KXfFlZcU8wOOsVW8ALcsliaXf6dqEmOmYwgWK+/
 mQFdaV9YX6EbK+r8wA1nFtvvd3JG2uzlLNbakW134IOdHUrF+p
 DYv7qapUG/aNzWcq6RmiOCIy48ux6JN0NenVpXEXkS4ZQ6QTHt
 lizPwUmGopse7iQzUl2gunNjQSWCdCB7HZDdbzjOGztnnNWR8u
 7HZ7ScN/IZ1VzmmWH3wo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 October 2013, Daniel Walker wrote:
> Why wouldn't you just update it to use the device tree ? There are lots
> of phones our there using 7x30 .. 
> 
> This is one that Qualcomm specifically upstreamed, so what was the point
> of upstreaming it ?

Things like this happen a lot: you start with great ambitions, then real
life takes over and everybody who was once working on it has moved on to
other projects before the code actually works. 

We have the policy to let new code for incomplete platforms into the
tree very liberally, but the flip side is that we have to remove them
as swiftly if progress stops. Note that this is completely different
from most of the older platforms like the StrongARM based machines
that are way more outdated but are actually working just fine and
getting fixed when they don't.

The MSM platform is currently a mess with most SoCs broken most of 
the time. I definitely agree with David's approach of removing the
ones that are not being worked on and finally getting the newer ones
to work properly, and on the same level as the other platforms.

Once that work is complete, adding back support for the older SoCs
should become much easier if anyone is still interested, since the
required changes (multiplatform, DT, ...) are targetted at reducing
the effort of maintaining platforms.

	Arnd
