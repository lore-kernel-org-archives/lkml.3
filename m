Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3HBXlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:41:16 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:57984 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab3HBXlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:41:12 -0400
MIME-Version: 1.0
X-Originating-IP: [208.54.5.159]
Date: Fri, 2 Aug 2013 16:41:11 -0700
Message-ID: <CAOesGMgWeP-CdmOE-S7XZmJ-+1buP9a1cqavUns2gpgKrrhaxQ@mail.gmail.com>
Subject: Build breakage due to latest ARM fixes
From: Olof Johansson <olof@lixom.net>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

Looks like you sent up some fixes to Linus that broke one of the atmel
configs (CONFIG_MMU=n):

commit 48be69a026b2c1 ARM: move signal handlers into a vdso-like page

seems to have caused it:

arch/arm/kernel/signal.c: In function 'setup_return':
arch/arm/kernel/signal.c:413:25: error: 'mm_context_t' has no member
named 'sigpage'

I see it with at91x40_defconfig.


-Olof
