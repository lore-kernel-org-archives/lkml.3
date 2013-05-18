Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab3EREVm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 00:21:42 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:44639 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3EREVk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 00:21:40 -0400
Date: Fri, 17 May 2013 23:21:37 -0500
From: Rob Landley <rob@landley.net>
Subject: 3.10-rc1: commit ccdfcc398594 broke uClibc build.
To: linux-kernel@vger.kernel.org, kaber@trash.net, davem@davemloft.net
X-Mailer: Balsa 2.4.11
Message-Id: <1368850897.18069.255@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The #include <linux/kernel.h> added to include/uapi/linux/netlink.h  
causes the uClibc build to go:

In file included from include/linux/kernel.h:4,
                  from include/linux/netlink.h:4,
                  from include/linux/rtnetlink.h:5,
                  from libc/inet/netlinkaccess.h:27,
                  from libc/inet/if_index.c:37:
include/linux/sysinfo.h:8: error: expected specifier-qualifier-list  
before '__kernel_long_t'
make: *** [libc/inet/if_index.o] Error 1

If I comment out that line, it builds fine. The kernel builds (for my  
config) either way.

Rob