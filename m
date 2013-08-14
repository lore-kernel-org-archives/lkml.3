Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760097Ab3HNQb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:31:56 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:57194 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402Ab3HNQbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:31:53 -0400
From: Zach Levis <zach@zachsthings.com>
To: akpm@linux-foundation.org, oleg@redhat.com
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dan.carpenter@oracle.com,
        keescook@chromium.org, cody@linux.vnet.ibm.com, zml@linux.vnet.ibm.com,
        Zach Levis <zach@zachsthings.com>
Subject: [PATCH v4 0/3] fs/binfmts: Improve handling of loops 
Date: Wed, 14 Aug 2013 09:31:35 -0700
Message-Id: <1376497898-18619-1-git-send-email-zach@zachsthings.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com>
References: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com>
In-Reply-To: 1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This v4 is based off Oleg's changes from "exec: more cleanups" and "exec: minor cleanups + minor fix"

It incorporates Oleg and Andrew's suggestions and takes care of the issue from Dan's patch "fs/binfmts: double unlock in search_binary_handler()"

New in v4 is how we handle resetting the linux_binprm data. The same function (init_bprm) is called for the initial do_execve_common and recovering from a loop, making sure that any data that needs to be changed is changed.

Additionally, compat_binfmt_elf gets its own name.
(btw, I'd really like to rename that file to binfmt_elf_compat to match the other binfmts, but not sure if that'd break things or go against some other naming scheme in use)
