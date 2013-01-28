Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab3A1Qru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:47:50 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:53428 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab3A1Qrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:47:48 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH 0/2] Secure Boot: More controversial changes 
Date: Mon, 28 Jan 2013 11:47:40 -0500
Message-Id: <1359391662-26120-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.0.2
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches break functionality that people rely on without providing
any functional equivalent, so I'm not suggesting that they be merged
as-is. kexec allows trivial circumvention of the trust model (it's
trivially equivalent to permitting module loading, for instance) and
hibernation allows similar attacks (disable swap, write a pre-formed resume
image to swap, reboot). The hibernation patch also shows up a different
issue - some userspace drops all capabilities, resulting in things that
userspace expects to work no longer working. This seems like an
unsurprising result, but breaking userspace is bad and so it'd be nice to
figure out if there's another way to handle this.

