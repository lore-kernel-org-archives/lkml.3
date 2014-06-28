Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaF1Vwl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 17:52:41 -0400
Received: from mout.gmx.net ([212.227.15.15]:62937 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbaF1Vwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 17:52:40 -0400
Message-ID: <53AF3925.7070300@gmx.de>
Date: Sat, 28 Jun 2014 23:52:37 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: lib/argv_split.c : should argv be kfree'ed ?
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:0DsHqxYTuZhexYtiuYaO3JrMmAGWGfpmYGSH6FvqRNv0cmwyGlv
 we0CkVySJuFI8IM1Is+G6ijvpvr4huJuPsc94PSiZtjB7PbaXYkdM6SBVemn/xqorrKRume
 0BXg/nR76lqhiynWWYTkQp0bnL0MjgpZ7BQcgOU0jM4isa7gRM2HO8QwYWrvwc96ESw1GlW
 YpJ3B2/owMv7JorSvKIpg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/me wonders if this patch is needed here :


diff --git a/lib/argv_split.c b/lib/argv_split.c
index e927ed0..7de4cb4 100644
--- a/lib/argv_split.c
+++ b/lib/argv_split.c
@@ -85,6 +85,7 @@ char **argv_split(gfp_t gfp, const char *str, int *argcp)
                        *argv++ = argv_str;
                }
        }
+       kfree (argv);
        *argv = NULL;

        if (argcp)

-- 
Toralf

