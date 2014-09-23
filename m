Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbaIWWLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:11:41 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:52460 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752AbaIWWLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:11:40 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] lib: string.c:  Added a funktion function strzcpy  
Date: Wed, 24 Sep 2014 00:13:35 +0200
Message-Id: <1411510416-16655-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've added a feature strzcpy to make it easier to not do wrong
when you use the function strncpy.
By not have to add a guaranteed trailing null character:
  strncpy(to, src, c);
  to[c - 1] = '\0';


This arose after a discussion with Dan Carpenter:

https://lkml.org/lkml/2014/9/15/74

And I was thinking of making it with the return value corresponding
to strlen, but could not make any neat/optimal solution.
But if we are to add this maybe it's worth thinking about whether
we can use the return value to something sensible.


Rickard Strandqvist (1):
  lib: string.c:  Added a funktion function strzcpy

 include/linux/string.h |    1 +
 lib/string.c           |   31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

-- 
1.7.10.4

