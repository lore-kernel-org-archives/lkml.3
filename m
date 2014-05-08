Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaEHKla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:41:30 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:59161 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbaEHKl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:41:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn@kryo.se>, Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 3/4] of/platform: fix device naming for non-translatable addresses
Date: Thu, 08 May 2014 12:41:10 +0200
Message-ID: <4314054.Zr5Mecf9vm@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1399499298-8830-4-git-send-email-robherring2@gmail.com>
References: <1399499298-8830-1-git-send-email-robherring2@gmail.com> <1399499298-8830-4-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:OsGPK7Z0DpqAkZvvVQpsJ/Icqh1XfHkwCR7XPnKOWmP
 gVrHLDjbicy9QvzvbKDJO5WzEAgEcID35o2SWkZrsj/XKLjS9e
 oYL8om2mkDSV+j0p/BoWpTAHnQ2lWmQTkLbu+KbWPY+dSMgcm6
 +e6gkN9iTjQ2fxD6pW6npfyGssiU5wCIorw5UX+Du9hBZt5/KD
 F8icW6Oh75i8NxsQ2Gx/pllziKiCSVOsF5SEHCFZPCujF53Ass
 8PBpRFSyMfahpAWnWMcznXQC34P5pLLnWl8xxjd1cp+znDImNT
 2QqgokGmzh78ifEIb2ji+fgte3z98E8lPNcS1FdlgYgsHxLrr0
 yuq50BS1ccOPB59dyC6k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 May 2014 16:48:17 Rob Herring wrote:
> From: Rob Herring <robh@kernel.org>
> 
> Using non-translatable addresses in platform device names is wrong
> because they may not be globally unique. Just use the default naming with
> a global index if the address cannot be translated instead.
> 
> of_can_translate_address has the same checks as of_translate_address, so
> we can remove it here as well.

Have you checked that this doesn't break platforms using clkdev lookup
based on names with local addresses? It's quite possible that nobody
does that, but it would be good to have someone confirm it.

	Arnd
