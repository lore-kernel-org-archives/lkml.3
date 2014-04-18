Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaDRAYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:24:41 -0400
Received: from smtp.outflux.net ([198.145.64.163]:54843 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbaDRAYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:24:35 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>,
        Oleg Nesterov <oleg@redhat.com>,
        John Johansen <john.johansen@canonical.com>,
        Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>,
        linux-doc@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH v3 0/5] seccomp: add PR_SECCOMP_EXT and SECCOMP_EXT_ACT_TSYNC
Date: Thu, 17 Apr 2014 17:24:15 -0700
Message-Id: <1397780660-24750-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the ability for threads to request seccomp filter
synchronization across their thread group (either at filter attach time
or later). To support this, seccomp locking on writes is introduced,
along with refactoring of no_new_privs. Races with thread creation are
handled via the tasklist_list.

I think all the concerns raised during the discussion[1] of the first
version of this patch have been addressed. However, the races involved
have tricked me before. :)

Thanks!

-Kees

[1] https://lkml.org/lkml/2014/1/13/795

v3:
 - added SECCOMP_EXT_ACT_FILTER for new filter install options
v2:
 - reworked to avoid clone races

