Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641AbaJUVQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:16:24 -0400
Received: from mout.gmx.net ([212.227.15.18]:65460 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932998AbaJUVQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:16:22 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
Subject: .exit.text section in vmlinux ?
Date: Tue, 21 Oct 2014 23:19:01 +0200
User-Agent: KMail/1.13.7 (Linux/3.16.2-dirty; KDE/4.12.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201410212319.20340.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:6by+VaBrWW6XmIW3+P8uXgyu8l53lgaJyGvLvFAv+7lPE1Ki2+C
 pteAKjViEZXrgxHwwGa3Xk+tAdZotHdPrcZH+HzVri5qhEd095GMW9n5EYds8h+jfs2g3sb
 U6OZJ5dgxFXTmGuOBXQUn+wAkNDwTGpEv1NjPyR3TG9DL3+BpnKjnm/DDZu3+klUHwIN2P3
 HSlwMbdfJCf5Ga8B0713w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

as far as I remember everything marked with __exit or __exit_data will only be 
used/called when unloading a module, and gets moved to the .exit.text or 
.exit.data sections.

Why are these sections present in the vmlinux/vmlinux.bin/bzImage and not 
dropped by the linker or at least objdump? 
This code will never be called for everything compiled in - in an allyesconfig 
build these sections account for ~80kb of code.

Is there something I'm missing here, or can we add "--remove-section 
.exit.data --remove-section .exit.text" to the OBJCOPYFLAGS for vmlinux?


Thanks,
Peter
