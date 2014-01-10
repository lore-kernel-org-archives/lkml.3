Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbaAJQ7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:59:18 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:49995 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757892AbaAJQ7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:59:16 -0500
Date: Fri, 10 Jan 2014 16:58:47 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: "msalter@redhat.com" <msalter@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 4/6] arm: add early_ioremap support
Message-ID: <20140110165847.GG925@arm.com>
References: <1389325833-16535-1-git-send-email-msalter@redhat.com>
 <1389325833-16535-5-git-send-email-msalter@redhat.com>
 <CAL_JsqLZQ=3gph4yaNSrZ5oPL3kasQKqA5C5+my0GwjGHsvMeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqLZQ=3gph4yaNSrZ5oPL3kasQKqA5C5+my0GwjGHsvMeQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 04:11:03PM +0000, Rob Herring wrote:
> On Thu, Jan 9, 2014 at 9:50 PM, Mark Salter <msalter@redhat.com> wrote:
> > This patch uses the generic early_ioremap code to implement
> > early_ioremap for ARM. The ARM-specific bits come mostly from
> > an earlier patch from Leif Lindholm <leif.lindholm@linaro.org>
> > here:
> >
> >   https://lkml.org/lkml/2013/10/3/279
> 
> I think this will be useful to implement an arm64 style earlycon for
> arm as the current DEBUG_LL doesn't really work with multi-platform
> kernels. I started on this and quickly realized I needed the fixmap
> support.

It would be even better if you can make it more generic
(drivers/tty/serial/) and keep DEBUG_LL as a specialised case for
arch/arm (when !multi-platform).

-- 
Catalin
