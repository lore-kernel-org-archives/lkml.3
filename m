Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232AbaDQWze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 18:55:34 -0400
Received: from www.meduna.org ([92.240.244.38]:39364 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbaDQWz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 18:55:29 -0400
Message-ID: <53505BD7.9050004@meduna.org>
Date: Fri, 18 Apr 2014 00:55:19 +0200
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        triplesquarednine@gmail.com
CC: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bigeasy@linutronix.de, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: spinlock trylock failure on UP - reverting timer patches
 helps
References: <534C3606.7010206@meduna.org> <534C731F.1050406@meduna.org> <534DADF1.6060608@meduna.org> <53500184.4050309@meduna.org>
In-Reply-To: <53500184.4050309@meduna.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2014-04-18 00:55:23
X-Connected-IP: 95.105.163.217:8013
X-Message-Linecount: 52
X-Body-Linecount: 33
X-Message-Size: 1813
X-Body-Size: 895
X-Received-Count: 1
X-Recipient-Count: 7
X-Local-Recipient-Count: 7
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.04.2014 18:29, Stanislav Meduna wrote:

> Note: the bug goes away reverting the very same patches that are
> helping the Jordan's problms. I did follow
> 
> http://www.spinics.net/lists/linux-rt-users/msg11639.html
> 
> and no BUG while booting anymore. I'll try to let it run some
> more time.

Erm.. nope

# (cat /proc/meminfo ; cat /proc/meminfo) |  grep KernelStack
KernelStack:        5920 kB
KernelStack:        5928 kB

# (cat /proc/meminfo ; cat /proc/meminfo) |  grep KernelStack
KernelStack:        5952 kB
KernelStack:        5960 kB

maybe interrupt nesting ad nauseum? How does one debug
such issues?

It is possible that my previous posting was also caused by this -
disregard, I'll post again if the problem persists.

Jordan, could you check whether your kernel stack remains
stable with only the 3 patches reverted?

Thanks
-- 
                                     Stano

