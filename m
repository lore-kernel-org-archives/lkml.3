Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab3IIPz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:55:26 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44952 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab3IIPwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:52:09 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        linux-efi@vger.kernel.org, jmorris@namei.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH 00/12] One more attempt at useful kernel lockdown 
Date: Mon,  9 Sep 2013 11:49:34 -0400
Message-Id: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.3.1
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:5d52:9ee3:3e84:6668
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some use cases require the ability to ensure that anything running in ring 0
is trusted code. We have support for signing the kernel and kernel modules,
but there's still a range of exported kernel interfaces that make it easy to
modify the running kernel. Previous attempts to implement a generic interface
to restrict this have included a new capability (breaks existing userspace)
and tying it to a requirement for signed modules (breaks assumptions in
certain situations where userspace is already running with restricted
privileges).

So, this is my final attempt at providing the functionality I'm interested
in without inherently tying it to Secure Boot. There's strong parallels
between the functionality that I'm interested in and the BSD securelevel
interface, so here's a trivial implementation. 

