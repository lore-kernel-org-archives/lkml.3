Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3GPIf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 04:35:29 -0400
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:42301 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab3GPIf0 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Tue, 16 Jul 2013 04:35:26 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jul 2013 04:35:25 EDT
Message-Id: <51E5206D020000A100011DB2@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 16 Jul 2013 10:29:01 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Cc: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Subject: chown: s-Bits: to clear or not to clear
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I discovered (SLES11 SP2 with kernel  3.0.80) that a chown executed by root (from non-root to non-root user) clears any s-Bits that were set for the old owner.

The man page (man 2 chown) says:
       When  the  owner  or  group of an executable file are changed by a non-
       superuser, the S_ISUID and S_ISGID mode bits are cleared.   POSIX  does
       not specify whether this also should happen when root does the chown();
       the Linux behavior depends on the kernel version.  In case  of  a  non-
       group-executable  file (i.e., one for which the S_IXGRP bit is not set)
       the S_ISGID bit indicates mandatory locking, and is not  cleared  by  a
       chown().

As there are good arguments for and against clearing the s-Bits during chown, there are probably only good arguments for having an option for chown(1) to preserve the s-Bits. What do you think? (I know this is the wrong list for discussing utils).

Regards,
Ulrich Windl


