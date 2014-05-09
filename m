Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbaEIB3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 21:29:37 -0400
Received: from mail.anarazel.de ([217.115.131.40]:33634 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569AbaEIB3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 21:29:34 -0400
From: Andres Freund <andres@anarazel.de>
To: Borislav Petkov <bp@suse.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: 
Date: Fri,  9 May 2014 03:29:15 +0200
Message-Id: <1399598957-7011-1-git-send-email-andres@anarazel.de>
X-Mailer: git-send-email 2.0.0.rc2.4.g1dc51c6.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After 3.14 I noticed that perf started to only support software
events.

The reason - found after a some staring deathmatches because the
patches look innocent - is a typo in __flip_bit() introduced by
22085a66c2fab6cf9b9393c056a3600a6b4735de which only takes effect after
c0a639ad0bc6b178b46996bd1f821a04643e2bde. Due to the typo no msr
writes via either msr_clear/set_bit actually write back the new value.
That then causes cpuid limits not to be lifted causing 'my' perf and
very likely some other problems.

There's also a typo in the former commit which makes it impossible to
actually use the MSR_IA32_MISC_ENABLE_LIMIT_CPUID macro correctly.

Regards,

Andres Freund

