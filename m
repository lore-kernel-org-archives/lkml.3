Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbaCDXbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:31:06 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:54391 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbaCDXbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:31:05 -0500
MIME-Version: 1.0
In-Reply-To: <1393963738-9210-6-git-send-email-msalter@redhat.com>
References: <1393963738-9210-1-git-send-email-msalter@redhat.com>
	<1393963738-9210-6-git-send-email-msalter@redhat.com>
Date: Tue, 4 Mar 2014 17:31:03 -0600
Message-ID: <CAL_JsqLQ8gj4nkwh+67i58rQBARoh_CgZ+4D9uepdBQm-XBwJA@mail.gmail.com>
Subject: Re: [PATCH 5/5] arm64: add early_ioremap support
From: Rob Herring <robherring2@gmail.com>
To: Mark Salter <msalter@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Linaro Patches <patches@linaro.org>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2014 at 2:08 PM, Mark Salter <msalter@redhat.com> wrote:
> Add support for early IO or memory mappings which are needed
> before the normal ioremap() is usable. This also adds fixmap
> support for permanent fixed mappings such as that used by the
> earlyprintk device register region.

One minor comment:

> +enum fixed_addresses {
> +       FIX_EARLYCON,

Can you align this name with x86 and rename to FIX_EARLYCON_MEM_BASE.
Doing that will help enable the earlycon driver in 8250_early.c.

Rob
