Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab3DOOI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 10:08:27 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:63384 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab3DOOI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 10:08:26 -0400
MIME-Version: 1.0
In-Reply-To: <87r4ibdh8f.fsf@linaro.org>
References: <1363822467-6275-1-git-send-email-khilman@linaro.org>
	<1363822467-6275-2-git-send-email-khilman@linaro.org>
	<20130411171047.GB17129@somewhere.redhat.com>
	<87r4ibdh8f.fsf@linaro.org>
Date: Mon, 15 Apr 2013 16:08:24 +0200
Message-ID: <CAFTL4hwroTC6HN7WvDRpn=6y-JkX4GeFzS1nro0w3L1CGNMrnA@mail.gmail.com>
Subject: Re: [PATCH 1/3] cputime_nsecs: use math64.h for nsec resolution
 conversion helpers
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/15 Kevin Hilman <khilman@linaro.org>:
> Frederic Weisbecker <fweisbec@gmail.com> writes:
>
>> On Wed, Mar 20, 2013 at 04:34:25PM -0700, Kevin Hilman wrote:
>>> For the nsec resolution conversions to be useable on non 64-bit
>>> architectures, the helpers in <linux/math64.h> need to be used so the
>>> right arch-specific 64-bit math helpers can be used (e.g. do_div())
>>>
>>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>>> Signed-off-by: Kevin Hilman <khilman@linaro.org>
>>
>> Ok the patch is nice!
>>
>> I'm queuing it.
>
> Thanks, did you queue PATCH 3/3 also to remove the 64-bit limitation
> from VIRT_CPU_ACCOUNTING_GEN:  https://lkml.org/lkml/2013/3/20/656

Not yet, for this one I need to deeply check we haven't forgotten
anything concerning cputime_t operations in 32 bits archs.
