Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab3KHOpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 09:45:15 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59867 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab3KHOpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 09:45:12 -0500
Date: Fri, 8 Nov 2013 15:47:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Robert Richter <rric@kernel.org>
Cc: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org
Subject: Re: [PATCH] edac, highbank: remove dependency on ARCH_HIGHBANK
Message-ID: <20131108144700.GB7044@x1.alien8.de>
References: <1383708352-19527-1-git-send-email-robherring2@gmail.com>
 <20131106142025.GB16072@x1.alien8.de>
 <527A6B08.5020302@gmail.com>
 <20131106165437.GA21870@x1.alien8.de>
 <527A79B5.4070507@gmail.com>
 <20131107122716.GC27116@x1.alien8.de>
 <527B943E.9050603@gmail.com>
 <20131107133329.GJ27116@x1.alien8.de>
 <20131108135918.GO7429@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131108135918.GO7429@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 02:59:18PM +0100, Robert Richter wrote:
> Can't we just take
>
>  depends on EDAC_MM_EDAC && (ARCH_MULTI_V7 || ARM64)
>
> as a first step to increase build coverage?

Yep, that's basically what I was suggesting.

> There is also COMPILE_TEST that could be used which is exactly what we
> want here: "Compile also drivers which will not load":
> 
>  depends on EDAC_MM_EDAC && (ARCH_MULTI_V7 || ARM64 || COMPILE_TEST)
> 
> This should enable it with allmodconfig.

You could do this but the first is already coverage enough IMO and, as I
said previously, compiling this thing on other architectures could raise
bugs/issues which are not necessarily such on arm/arm64, for example.

-- 
Regards/Gruss,
Boris.
