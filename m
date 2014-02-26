Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbaBZULp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:11:45 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44100 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaBZULi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:11:38 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        linux-efi@vger.kernel.org, jmorris@namei.org,
        linux-security-module@vger.kernel.org
Subject: Trusted kernel patchset for Secure Boot lockdown 
Date: Wed, 26 Feb 2014 15:11:01 -0500
Message-Id: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.5.3
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.207.143
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The conclusion we came to at Plumbers was that this patchset was basically
fine but that Linus hated the name "securelevel" more than I hate pickled
herring, so after thinking about this for a few months I've come up with
"Trusted Kernel". This flag indicates that the kernel is, via some
external mechanism, trusted and should behave that way. If firmware has
some way to verify the kernel, it can pass that information on. If userspace
has some way to verify the kernel, it can set the flag itself. However,
userspace should not attempt to use the flag as a means to verify that the
kernel was trusted - untrusted userspace could have set it on an untrusted
kernel, but by the same metric an untrusted kernel could just set it itself.

If people object to this name then I swear to god that I will open a poll
on Phoronix to decide the next attempt and you will like that even less.

