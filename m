Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3IJQX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:23:57 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:65331 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab3IJQXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:23:54 -0400
Message-ID: <522F4797.1050509@linaro.org>
Date: Tue, 10 Sep 2013 09:23:51 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Gerlando Falauto <gerlando.falauto@keymile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        "Brunck, Holger" <Holger.Brunck@keymile.com>,
        "Longchamp, Valentin" <Valentin.Longchamp@keymile.com>,
        "Bigler, Stefan" <Stefan.Bigler@keymile.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: kernel deadlock
References: <521F6D06.1040107@keymile.com> <E92455D61233364C88CCD4A6DAB2E2850E09518110@SRVDEHAN1MX1.keymile.net> <521FDD12.7050000@linaro.org> <52212511.9050206@keymile.com> <5221264F.4070402@linaro.org> <5225F8EF.3040701@keymile.com> <52261BBB.60904@linaro.org> <5226EB35.6080604@keymile.com> <522E2FBB.4070406@linaro.org> <20130910072908.GA32257@gmail.com>
In-Reply-To: <20130910072908.GA32257@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 12:29 AM, Ingo Molnar wrote:
> * John Stultz <john.stultz@linaro.org> wrote:
>
>> Now, I'm still in the dark as to why HRTICK exposes this, but seems like 
>> the following patch should resolve the issue (and quiets the lockdep 
>> warnings in my testing). Let me know how it works for you!
>>
>> Ingo: This makes me think we really should have some lockdep smarts 
>> added to seqlock/seqcount structures. Is there something already 
>> discovered thats preventing this, or has this just not yet been tried?
> There's no fundamental reason to not do it, it's a very good idea!
>
>> From 09885df9734aa678ccb61dbef356fea4faeff16c Mon Sep 17 00:00:00 2001
>> From: John Stultz <john.stultz@linaro.org>
>> Date: Mon, 9 Sep 2013 13:07:18 -0700
>> Subject: [PATCH] timekeepeing: Fix HRTICK related deadlock from ntp lock changes
> Cool fix! I think I've seen this deadlock in various incarnations but was 
> never able to track it down. Do you have a guesstimate about roughly when 
> it was introduced? Is it an ancient bug?

3.10, I believe. So no not ancient, but we've seen and resolved similar
issues in the past (the old printk while holding xtime_lock deadlock).

Hopefully the lockdep enablement helps sort these out for good.

thanks
-john

