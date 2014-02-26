Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaBZPAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:00:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaBZPAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:00:00 -0500
Message-ID: <1393426760.26583.43.camel@deneb.redhat.com>
Subject: Re: [PATCH v4 4/6] arm: add early_ioremap support
From: Mark Salter <msalter@redhat.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Linaro Patches <patches@linaro.org>
Date: Wed, 26 Feb 2014 09:59:20 -0500
In-Reply-To: <CAL_JsqLi=GhGy7dNf2BiAGd4EtzfqqYfbo0YhRhyhuwEp0w8HQ@mail.gmail.com>
References: <1392238575-10000-1-git-send-email-msalter@redhat.com>
	 <1392238575-10000-5-git-send-email-msalter@redhat.com>
	 <CAL_JsqLi=GhGy7dNf2BiAGd4EtzfqqYfbo0YhRhyhuwEp0w8HQ@mail.gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 23:48 -0600, Rob Herring wrote:
> > +#define NR_FIX_BTMAPS          32
> > +#define FIX_BTMAPS_SLOTS       7
> > +#define TOTAL_FIX_BTMAPS       (NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)
> > +#define FIX_BTMAP_END          FIX_KMAP_BEGIN
> > +#define FIX_BTMAP_BEGIN                (FIX_BTMAP_END +
> TOTAL_FIX_BTMAPS - 1)
> 
> Why the different logic from arm64? Specifically, it doesn't make
> adding a permanent mapping simple.

I looked at adding support for permanent mappings but it was going to
take more time than I had. Also on ARM, we have to deal with kmap's
needs as well. Working that out was going to take more time than I
had. I think getting the patch in now to support early_ioremap is
the way to go. Adding support for permanent mappings can be done
later with the early console support for which it is needed.


