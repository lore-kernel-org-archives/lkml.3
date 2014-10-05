Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaJENES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 09:04:18 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:39730 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaJENEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 09:04:15 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] lib: string.c:  Added a funktion function strzcpy  
Date: Sun,  5 Oct 2014 15:06:16 +0200
Message-Id: <1412514377-19387-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've added a strzcpy to make it easier to not do wrong
when you use the function strncpy.

Often one needs the zero padding, but must still have a
guaranteed zero character terminat.
Then you end up writing code like this:
  strncpy(to, src, sizeof(to));
  to[sizeof(to) - 1] = '\0';

This is solved with strzcpy.

Rickard Strandqvist (1):
  lib: string.c:  Added a funktion function strzcpy

 include/linux/string.h |    1 +
 lib/string.c           |   31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

-- 
1.7.10.4

