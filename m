Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbaC1Atg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 20:49:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50172 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794AbaC1Ate (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 20:49:34 -0400
Message-ID: <5334C71B.1090506@linaro.org>
Date: Thu, 27 Mar 2014 17:49:31 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Bohac <jbohac@suse.cz>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: is printk() safe within a timekeeper_seq write section?
References: <20140306174531.GA30634@midget.suse.cz> <531F6429.8050008@linaro.org> <alpine.DEB.2.02.1403112040100.18573@ionos.tec.linutronix.de> <531F8605.10003@linaro.org> <20140312092125.GA30305@midget.suse.cz>
In-Reply-To: <20140312092125.GA30305@midget.suse.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 02:21 AM, Jiri Bohac wrote:
> On Tue, Mar 11, 2014 at 02:54:13PM -0700, John Stultz wrote:
>> Ok, so a generic solution is probably not going to be worth it then. My
>> thought was that since we do a very limited amount of informational
>> printks in the timekeeping code, we can be fairly safe delaying the
>> print-out until we drop the locks.
>>
>> For timekeeping, its really 4 call sites:
>> * invalid inject_sleep_time deltas
>> * > 11% clocksource freq adjustments
>> * insert leap second
>> * delete leap second
> I believe these last two were made safe by 
> commit ca4523cd (timekeeping: Shorten seq_count region). 
>
> write_seqcount_begin(&timekeeper_seq) is now done after the
> accumulate_nsecs_to_secs(tk) from where the printks are called.

So I started looking into deferring the printk with a small local
buffer, but I suddenly realized there are all these WARN_ON's around
which would likely have the same problem, no?

So I'm starting to doubt we can safely get away with a timekeeping
specific hack to defer the printk. :(

thanks
-john




