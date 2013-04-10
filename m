Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936590Ab3DJMWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:22:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53123 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab3DJMWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:22:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 7/8] dmaengine: ste_dma40: Use the BIT macro to replace ugly '(1 << x)'s
Date: Wed, 10 Apr 2013 14:22:31 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linus.walleij@stericsson.com
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org> <201304092112.56039.arnd@arndb.de> <20130410093412.GI25316@gmail.com>
In-Reply-To: <20130410093412.GI25316@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304101422.31601.arnd@arndb.de>
X-Provags-ID: V02:K0:Zz0GQf62p7nKna1OYKLdgK5HY5fphmaHWl/IOn6n8L2
 baQ8Rj0WjEobi32EzvPdfbsfgJeou1FkD5xjjPsVB8r800erH5
 tt0DkGlMb8+6QfZWWqU9hM2GwHVWLtB9gJOL1aZod/LYEuRQ10
 Da/t1ADZ9mB5mEYr2yOHdN1vibtLGOtQI17uTpuh+QGyIxhQ4k
 +coR3cFuo5RG8vjMIUf+nrvVXDxPrj/KlASb25enmoPwRYn6up
 xZwBV/NcEOoVYJtMGuvc7dI9MZyZh6UCQPSVAwEa73mqqSeI5+
 1s7jglkpxjvBykJUcqGaJ0Q2EQ8qgar4jFp9f22yPBDHcNBoGk
 DE6lBO4Nd0oGBZ2WIeXk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 April 2013, Lee Jones wrote:
> On Tue, 09 Apr 2013, Arnd Bergmann wrote:

> > Yes, good point. The macro is only used in one place, to compare
> > two compile-time constant values, but we should define macros in
> > drivers that are already provided by the kernel.
> 
> Okay, it looks like the generic implementation has brackets in it,
> which isn't allowed for this particular usecase.

Ah, right.

> I'll fix this one instead.

Probably not worth then. You could open-code the comparison where
it is used and remove the macro if you want, but I probably
would not bother.

	Arnd

