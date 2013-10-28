Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab3J1Ppr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:45:47 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:42470 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698Ab3J1Ppp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:45:45 -0400
Date: Mon, 28 Oct 2013 10:45:41 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH trace-cmd 1/5] trace-cmd/listen: Remove use of
 sighandler_t
Message-ID: <20131028154541.GB18282@thinkpad-t410>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org
References: <1382642074-15567-1-git-send-email-seth.forshee@canonical.com>
 <1382642074-15567-2-git-send-email-seth.forshee@canonical.com>
 <20131024203007.GB8006@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131024203007.GB8006@thinkpad-t410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 03:30:07PM -0500, Seth Forshee wrote:
> On Thu, Oct 24, 2013 at 02:14:30PM -0500, Seth Forshee wrote:
> > sighandler_t is a GNU extension and may not be defined if
> > _GNU_SOURCE is not set. To minimize the potential for build
> > problems, change signal_setup() to declare its handle argument
> > the same way struct sigaction declares the sa_handler member.
> 
> I just saw that you've already got a commit to define _GNU_SOURCE on
> master. I was packaging v2.2.1 and didn't notice it, so you can ignore
> this one.

Turns out that fix doesn't work all the time. The following is also
required.


>From 20ec8510d0ca2ac789b1ca9cf7b0a6dc2d02f14c Mon Sep 17 00:00:00 2001
From: Seth Forshee <seth.forshee@canonical.com>
Date: Mon, 28 Oct 2013 08:15:59 -0500
Subject: [PATCH] Makefile: Ensure _GNU_SOURCE really is always defined

When CLFAGS is set with a command argument a normal variable
assignment is not sufficient to ensure that _GNU_SOURCE will be
defined. Since this really is critical for building, use an
override directive when adding it to CFLAGS to ensure that it
really does get defined in all cases.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 1d613c4..a2ba385 100644
--- a/Makefile
+++ b/Makefile
@@ -223,7 +223,7 @@ CFLAGS ?= -g -Wall
 LDFLAGS ?=
 
 # Required CFLAGS
-CFLAGS += -D_GNU_SOURCE
+override CFLAGS += -D_GNU_SOURCE
 
 ifndef NO_PTRACE
 ifneq ($(call try-cc,$(SOURCE_PTRACE),),y)
-- 
1.8.3.2

