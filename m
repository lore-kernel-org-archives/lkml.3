Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab3KHN7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 08:59:30 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:41802 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3KHN7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 08:59:23 -0500
Date: Fri, 8 Nov 2013 14:59:18 +0100
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org
Subject: Re: [PATCH] edac, highbank: remove dependency on ARCH_HIGHBANK
Message-ID: <20131108135918.GO7429@rric.localhost>
References: <1383708352-19527-1-git-send-email-robherring2@gmail.com>
 <20131106142025.GB16072@x1.alien8.de>
 <527A6B08.5020302@gmail.com>
 <20131106165437.GA21870@x1.alien8.de>
 <527A79B5.4070507@gmail.com>
 <20131107122716.GC27116@x1.alien8.de>
 <527B943E.9050603@gmail.com>
 <20131107133329.GJ27116@x1.alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107133329.GJ27116@x1.alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.11.13 14:33:29, Borislav Petkov wrote:
> On Thu, Nov 07, 2013 at 07:23:10AM -0600, Rob Herring wrote:
> > See, we are benefiting already.
> 
> You can catch this when building on arm64, i.e. basically one of the
> target architectures for which the driver is meant for.

Can't we just take

 depends on EDAC_MM_EDAC && (ARCH_MULTI_V7 || ARM64)

as a first step to increase build coverage?

There is also COMPILE_TEST that could be used which is exactly what we
want here: "Compile also drivers which will not load":

 depends on EDAC_MM_EDAC && (ARCH_MULTI_V7 || ARM64 || COMPILE_TEST)

This should enable it with allmodconfig.

-Robert
