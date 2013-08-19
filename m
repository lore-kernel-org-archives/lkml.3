Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188Ab3HSR0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:26:20 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51117 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab3HSR0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:26:18 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, jwboyer@redhat.com, keescook@chromium.org
Subject: [PATCH 0/10] Add additional security checks when module loading is restricted 
Date: Mon, 19 Aug 2013 13:26:01 -0400
Message-Id: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.3.1
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have two in-kernel mechanisms for restricting module loading - disabling
it entirely, or limiting it to the loading of modules signed with a trusted
key. These can both be configured in such a way that even root is unable to
relax the restrictions.

However, right now, there's several other straightforward ways for root to
modify running kernel code. At the most basic level these allow root to
reset the configuration such that modules can be loaded again, rendering
the existing restrictions useless.

This patchset adds additional restrictions to various kernel entry points
that would otherwise make it straightforward for root to disable enforcement
of module loading restrictions. It also provides a patch that allows the
kernel to be configured such that module signing will be automatically
enabled when the system is booting via UEFI Secure Boot, allowing a stronger
guarantee of kernel integrity.

