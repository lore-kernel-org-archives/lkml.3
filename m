Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbaA1MzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:55:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbaA1MzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:55:17 -0500
Message-ID: <52E7A8B3.5060105@redhat.com>
Date: Tue, 28 Jan 2014 13:55:15 +0100
From: Florian Weimer <fweimer@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Futex and get_user_pages error conditions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently do not deal with futex operation failures inside glibc, at 
least not for the glibc-internal locks.  (I noticed this while reading 
the code, my question is not prompted by real-world failures.)  In 
general, glibc will ensure that preconditions are met and handles some 
expected errors, or behavior is undefined user code doesn't ensure them, 
but there are some errors which are impossible to prevent by careful 
programming, such as memory allocation failures.

I looked at the kernel implementation, and noticed that in the guts of 
the get_user_pages implementation, it can return ENOMEM.  Does this 
actually affect futexes, especially the plain (non-PI, 
non-cross-process) variant?

Are there any other error conditions we should handle inside glibc?  We 
really need a fast, async-signal-safe locking primitive where locking 
and unlocking cannot fail (after suitable set-up).

-- 
Florian Weimer / Red Hat Product Security Team
