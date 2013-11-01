Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab3KALWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:22:03 -0400
Received: from intranet.asianux.com ([58.214.24.6]:49024 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3KALWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:22:01 -0400
X-Spam-Score: -100.8
Message-ID: <52738E90.6040104@asianux.com>
Date: Fri, 01 Nov 2013 19:20:48 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] about latest commit for "scripts/get_maintainers.pl"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joe:

I meet a failure about "scripts/get_maintainers.pl", it is about the
commit "750432d get_maintainer.pl incomplete output", if use original
"scripts/get_maintainer.pl", it will be OK.

Please help check, thanks.


The related information:

-------------------------information begin---------------------------

  [root@gchenlinux linux-next]# ./scripts/get_maintainer.pl /tmp/0001-hexagon-kernel-remove-useless-variables-dn-r-and-err.patch
  Can't use string ("GitAuthor: Chen Gang <gang.chen@"...) as an ARRAY ref while "strict refs" in use at ./scripts/get_maintainer.pl line 1883.

  [root@gchenlinux linux-next]# cat /tmp/0001-hexagon-kernel-remove-useless-variables-dn-r-and-err.patch
  From ef7384078bacdc5151039ea710943e5710d7c5ed Mon Sep 17 00:00:00 2001
  From: Chen Gang <gang.chen@asianux.com>
  Date: Fri, 1 Nov 2013 18:58:18 +0800
  Subject: [PATCH] hexagon: kernel: remove useless variables 'dn', 'r' and 'err' in time_init_deferred() in "time.c"
  
  Remove them, since they are useless. The related warnings (with allmodconfig for v4):
  
      CC      arch/hexagon/kernel/time.o
    arch/hexagon/kernel/time.c: In function 'time_init_deferred':
    arch/hexagon/kernel/time.c:196: warning: unused variable 'err'
    arch/hexagon/kernel/time.c:195: warning: unused variable 'r'
    arch/hexagon/kernel/time.c:194: warning: unused variable 'dn'
  
  
  Signed-off-by: Chen Gang <gang.chen@asianux.com>
  ---
   arch/hexagon/kernel/time.c |    3 ---
   1 files changed, 0 insertions(+), 3 deletions(-)
  
  diff --git a/arch/hexagon/kernel/time.c b/arch/hexagon/kernel/time.c
  index 9903fad..d0c4f5a 100644
  --- a/arch/hexagon/kernel/time.c
  +++ b/arch/hexagon/kernel/time.c
  @@ -191,9 +191,6 @@ void __init time_init_deferred(void)
   {
   	struct resource *resource = NULL;
   	struct clock_event_device *ce_dev = &hexagon_clockevent_dev;
  -	struct device_node *dn;
  -	struct resource r;
  -	int err;
  
   	ce_dev->cpumask = cpu_all_mask;
  
  -- 
  1.7.7.6

-------------------------information end-----------------------------


Thanks.
-- 
Chen Gang
