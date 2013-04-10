Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936983Ab3DJJeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:34:20 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38455 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3DJJeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:34:18 -0400
Date: Wed, 10 Apr 2013 10:34:12 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linus.walleij@stericsson.com
Subject: Re: [PATCH 7/8] dmaengine: ste_dma40: Use the BIT macro to replace
 ugly '(1 << x)'s
Message-ID: <20130410093412.GI25316@gmail.com>
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org>
 <1365532783-27425-7-git-send-email-lee.jones@linaro.org>
 <CAHLZz133b6kydVwh0_Cn2yg-Q_MeUF+Z-7+CMY7TkB7KK2ssAQ@mail.gmail.com>
 <201304092112.56039.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201304092112.56039.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Apr 2013, Arnd Bergmann wrote:

> On Tuesday 09 April 2013, Harvey Harrison wrote:
> > 
> > On Tue, Apr 9, 2013 at 11:39 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > >
> > > The aim is to make the code that little more readable.
> > >
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > 
> > >
> > >  #define MAX(a, b) (((a) < (b)) ? (b) : (a))
> > 
> > Not part of your patch, but probably a good idea to switch to the
> > generic MAX macro, this
> > one is evaluating its args twice.
> 
> Yes, good point. The macro is only used in one place, to compare
> two compile-time constant values, but we should define macros in
> drivers that are already provided by the kernel.

Okay, it looks like the generic implementation has brackets in it,
which isn't allowed for this particular usecase. I'll fix this one
instead.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
