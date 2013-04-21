Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab3DUTJK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 15:09:10 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:50901 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab3DUTJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 15:09:08 -0400
MIME-Version: 1.0
Date: Sun, 21 Apr 2013 13:09:08 -0600
Message-ID: <CA+ekxPWi=rKffVBaB_Y-ro5vhMHGHboWVad6KRYt0Xd-7_o8MA@mail.gmail.com>
Subject: Centos 6.3 (2.6.33) hwclock not defaulting to --directisa mode on
 select() timeout util-linux
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the older P4 systems from HP, the util-linux hwclock is no longer
defaulting to --directisa port setting mode if the select() timeout
fails.  It only shows up when you have an old PC with a battery that's
screwed up on the motherboard and the clock doesn't stay up to date.
But whether this is the case or not, ntpdate and ntpd should still be
able to update the system time and resync the hwclock.  I fixed it by
adding --directisa to the /etc/rc.d/rc.sysinit script but the
util-linux should default anyway if there is a failure as a failsafe
mode.

Jeff
