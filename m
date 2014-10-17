Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbaJQRXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 13:23:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675AbaJQRXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 13:23:21 -0400
Message-ID: <54415080.90401@redhat.com>
Date: Fri, 17 Oct 2014 13:23:12 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] clocksource, Add warning to clocksource_delta() validation
 code
References: <1413554226-12652-1-git-send-email-prarit@redhat.com>
In-Reply-To: <1413554226-12652-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/17/2014 09:57 AM, Prarit Bhargava wrote:
> A bug report came in against an older kernel which output "backward time"
> messages and the report noted that the upstream kernel worked.  After some
> investigation it turned out that one of the sockets was bad on the system
> and the "backward time" messages were caused by a real, but intermittent,
> hardware failure.
> 
> Commit 09ec54429c6d10f87d1f084de53ae2c1c3a81108 ("clocksource: Move
> cycle_last validation to core code") modifies the x86 clocksource such that
> if a negative delta between two reads of time is calculated the
> clocksource_delta() code will return 0.  There is no warning when this
> occurs and there really should be one in order to catch not only hardware
> issues like the issue above, but potential coding issues as the code is
> modified.  This patch introduces a WARN() which will also dump a stack
> trace to the console so the exact code path can be evaluated.
> 
> I tested this by booting on the broken hardware and left the system idle
> until a negative clocksource_delta() event occurred.
> 
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>

Sorry everyone -- I accidentally sent this out.  It is still untested and needs
some bake time.

Please ignore this patch.

P.
