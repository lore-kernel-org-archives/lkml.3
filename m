Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbaCEWa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:30:56 -0500
Received: from mout.web.de ([212.227.15.14]:55385 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbaCEWaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:30:55 -0500
Message-ID: <5317A59D.4@users.sourceforge.net>
Date: Wed, 05 Mar 2014 23:30:53 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Coccinelle <cocci@systeme.lip6.fr>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH with Coccinelle?] Deletion of unnecessary checks before
 specific function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:JEMf+9QYF0QBwSC9cZc0kmG9hhooVhqKIpcQWHkIA2p7Ey2Of+a
 xLUWmDLj4bCDdy7bDCa3xYvu5zf9hNoYJPEdzv5S8UMMZ7fsilA6SWLO0gpZIeWieE8Xppm
 wXuumuv+0PCpEJZHsmn3mL+wG8Eowbwb2dF89kcgzzVrLwwrzCQaHXzUkOmm6UZTnO+M2Sn
 nbwW77KGM+nW9Vh4MawYQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you are convinced that dropping the null tests is a good idea, then you 
> can submit the patch that makes the change to the relevant maintainers and 
> mailing lists.

Hello,

A couple of functions perform input parameter validation before their
implementations will try further actions with side effects. Some calling
functions perform similar safety checks.

Functions which release a system resource are often documented in the way that
they tolerate the passing of a null pointer for example. I do not see a need
because of this fact that a function caller repeats a corresponding check.

Now I would like to propose such a change again.

1. Extension of the infrastructure for the analysis tool "coccicheck"
   Semantic patch patterns can help to identify update candidates also in the
Linux source file hierarchy.

https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/scripts/coccinelle?id=79f0345fefaafb7cde301a830471edd21a37989b

2. Clarification for some automated update suggestions
   My source code search approach found seventy functions at least which might
need another review and corresponding corrections for Linux 3.14-rc5. Further
software development will point out even more potentially open issues.

Regards,
Markus
