Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750864Ab3LKG3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 01:29:07 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:40304 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3LKG3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 01:29:01 -0500
Message-ID: <52A80627.9020109@linaro.org>
Date: Wed, 11 Dec 2013 14:28:55 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>
Subject: nohz_full left a periodic tick cpu issue
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

Sorry for idiot of nohz_full. When we using this feature on my mobile
devices, we found this feature keep cpu0 in periodic tick mode. then the
timer interrupt on cpu0 is very higher than normal nohz mode.
that cause high power consuming cost.

I found you have mention this on commit: a382bf934449
nohz: Assign timekeeping duty to a CPU outside the full dynticks range

In fact, if all full dynticks cpu are in idle, cpu0 should be safe to
get into idle too. Do you have some plan or idea to implement this?
otherwise, power cost is too high to enable nohz_full in mobile platform.

-- 
Thanks
    Alex
