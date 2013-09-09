Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab3IIPMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:12:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57505 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab3IIPMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:12:01 -0400
Date: Mon, 9 Sep 2013 17:11:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>
Subject: "cpufreq: fix serialization issues with freq change notifiers" breaks
 cpufreq too
Message-ID: <Pine.LNX.4.64.1309091656200.6602@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:l2YDQioCOBUK+atBI7jlFpj9Tvev5V+qhQiKAWm7eHs
 ANe/4gwdolnXez4EOnTm5Mhea+TufSLkxYxCi+T+uNQp1VT78M
 g5JePchret2kecBMhXfHH8kxBhbrfyXqcu+lKoawOc7OYrwndh
 3b1Xb/IXuWjmHmHmuNTb0bnK0T4feYlJOwmMXLVrhoPQokkTOg
 s3AAjhPFn8ZQjh0+rcKiFdGM+uHhmLrMX1X+GydkZ6IpgCg80E
 Xp2t2a2VqTpXUx0B/NHs1/sKRqTd1ERl2oH8CGiQYnnp3dlQW4
 iRg0UY1TXoMQOOzU61g3oaE0dmveSsIWLmNbyU9Fj081bQn+2z
 DmYHtjS92/qs8XBPjiz7JVo2JyPbHCiupis75tuX55vjOVCczt
 LCh/1T4LGA4HA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry guys, I'm trying my best to stop this patch from propagating to 
stable and to get it fixed asap, so, the CC list might be a bit excessive. 
Also trying to fix the originally spare cc list, which makes it impossible 
for me to reply to the original thread, instead have to start a new one.

Commit

commit dceff5ce18801dddc220d6238628619c93bc3cb6
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Sun Sep 1 22:19:37 2013 +0530

    cpufreq: fix serialization issues with freq change notifiers

breaks .transition_ongoing counting. This leads to cpufreq-cpu0 not 
working any more. In particular switching the governor from performance to 
powersave directly after boot doesn't result in a frequency switch any 
more. Reverting this patch fixes the problem again. Tested with today's 
-next.

Please, refrain from including into "stable" until clarified!

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
