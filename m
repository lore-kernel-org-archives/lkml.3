Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab3HBOTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:19:52 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:52251 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab3HBOTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:19:51 -0400
MIME-Version: 1.0
Date: Fri, 2 Aug 2013 11:19:50 -0300
Message-ID: <CAOMZO5BFmsLqj5iRKbmTEvLa3J3CwtN3s7P0qiE_x9aQ6tEJbQ@mail.gmail.com>
Subject: "watchdog: update watchdog_tresh properly" breaks non-SMP
From: Fabio Estevam <festevam@gmail.com>
To: mhocko@suse.cz
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Commit 0ce6966b5 (watchdog: update watchdog_tresh properly) breaks the
build for uniprocessor systems:

kernel/watchdog.c: In function ‘update_timers’:
kernel/watchdog.c:523:2: error: implicit declaration of function
‘__smp_call_function_single’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[1]: *** [kernel/watchdog.o] Error 1

Regards,

Fabio Estevam
