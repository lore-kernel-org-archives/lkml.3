Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256Ab3FFM45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:56:57 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:38400 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932868Ab3FFM4z (ORCPT
	<rfc822;	linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:56:55 -0400
Date: Thu, 06 Jun 2013 15:56:46 +0300
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of
 target frequency
Message-ID: <p5rarcsfld4nd7ywi4urixo8.1370523406897@email.android.com>
From: Stratos Karafotis <stratosk@semaphore.gr>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Borislav Petkov <bp@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r56Cv5RC011236

Thanks Viresh. I think I couldn't explain this in better way.
Also thanks for acknowledgment!

Stratos

Viresh Kumar <viresh.kumar@linaro.org> wrote:

>On 6 June 2013 15:31, Borislav Petkov <bp@suse.de> wrote:
>
>> Hold on, you say above "easily saturate minimum frequency and lead the
>> CPU to max". I read this as we jump straight to max P-state where we
>> even boost.
>
>Probably he meant: "At lowest levels of frequencies, a small load on system
>may look like a huge one. like: 20-30% load on max freq can be 95% load
>on min freq. And so we jump to max freq even for this load and return back
>pretty quickly as this load doesn't sustain for longer. over that we wait for
>load to go over up_threshold to increase freq."
>
>> "CPU to max" finishes the work faster than middle frequencies, if you're
>> CPU-bound.
>
>He isn't removing this feature at all.
>
>Current code is:
>
>if (load > up_threshold)
>   goto maxfreq.
>else
>   don't increase freq, maybe decrease it in steps
>
>What he is doing is:
>
>if (load > up_threshold)
>   goto maxfreq.
>else
>   increase/decrease freq based on current load.
>
>So, if up_threshold is 95 and load remains < 95, his patch will
>give significant improvement both power & performance wise.
>
>Else, it shouldn't decrease it.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
