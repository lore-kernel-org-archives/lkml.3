Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965267Ab3E2IzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:55:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39284 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965117Ab3E2IzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:55:14 -0400
Date: Wed, 29 May 2013 09:54:27 +0100
From: Will Deacon <will.deacon@arm.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: Sricharan R <r.sricharan@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: map_init_section flushes incorrect pmd
Message-ID: <20130529085426.GA13095@mudshark.cambridge.arm.com>
References: <1369738100-11152-1-git-send-email-ratbert.chuang@gmail.com>
 <20130528130502.GA28971@mudshark.cambridge.arm.com>
 <51A4B938.7080708@ti.com>
 <20130528140705.GE28971@mudshark.cambridge.arm.com>
 <51A4FC08.3060906@ti.com>
 <CANutaR-2gTP7ubiEdgjFyzVMc6=4t5GPjLkH8pkup=O882Hb-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANutaR-2gTP7ubiEdgjFyzVMc6=4t5GPjLkH8pkup=O882Hb-Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 03:14:58AM +0100, Po-Yu Chuang wrote:
> Will,
> I guess nobody noticed this because the MMU of later v7 processors
> fetches page table
> from D-cache. It even doesn't need to clean pmd to PoU.

It does if it's UP. The walker is only guaranteed to read from L1 if you
have the multiprocessing extensions.

As for this function, looks like it's ok because it has precisely one
caller, so it might be worth prefixing it with some underscores to make it
clear that nobody else should be calling it!

Will
