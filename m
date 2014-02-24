Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaBXCXt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 21:23:49 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:47018 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaBXCXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 21:23:47 -0500
From: minyard@acm.org
To: OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Russ Anderson <rja@sgi.com>,
        Matthew Garrett <matthew.garrett@nebula.com>, lenb@kernel.org,
        rjw@rjwysocki.net, linux-acpi@vger.kernel.org
Subject: [PATCH 0/3] ipmi: Cleanups for allowing IPMI support to always be "y"
Date: Sun, 23 Feb 2014 20:23:33 -0600
Message-Id: <1393208616-16500-1-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three patches to remove issues with probing interface default, to make
sure the driver is completely idle if nothing is happening on it, and to
compile the IPMI driver into the kernel if ACPI is enabled.

The ACPI spec really requires that the IPMI driver be built into the
kernel because ACPI uses IPMI for some operations.  But some people
do not want the driver even using the mimimal amount of CPU it uses
when idle.  And the default probing, even though sort of implied to
be required by the spec, is really a bad idea and can result in hangs
on systems with other hardware at those location.

Hopefully these patches make everyone happy.

