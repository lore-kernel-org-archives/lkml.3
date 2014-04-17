Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaDQSFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 14:05:48 -0400
Received: from smtp.outflux.net ([198.145.64.163]:46089 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbaDQSF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 14:05:28 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: John Johansen <john.johansen@canonical.com>,
        Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH v2 0/3] seccomp: add PR_SECCOMP_EXT and SECCOMP_EXT_ACT_TSYNC
Date: Thu, 17 Apr 2014 11:05:01 -0700
Message-Id: <1397757904-30665-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the ability for threads to request seccomp filter 
synchronization across their thread group. To support this, 
seccomp locking on writes is introduced, along with refactoring
of no_new_privs. Races with thread creation are handled via the
tasklist_list. 

I think all the concerns raised during the discussion[1] of the first
version of this patch have been addressed. However, the races involved
have tricked me before. :)

Thanks!

-Kees

[1] https://lkml.org/lkml/2014/1/13/795

