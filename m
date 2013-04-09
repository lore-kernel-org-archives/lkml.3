Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935571Ab3DINWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:22:44 -0400
Received: from mail1.windriver.com ([147.11.146.13]:65362 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759375Ab3DINWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:22:43 -0400
Message-ID: <5164160D.7080201@windriver.com>
Date: Tue, 9 Apr 2013 09:22:21 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/4] nohz: New option to force all CPUs in full dynticks
 range
References: <1364398359-21990-1-git-send-email-fweisbec@gmail.com> <1364398359-21990-5-git-send-email-fweisbec@gmail.com> <20130328074507.GC24433@gmail.com> <CAFTL4hzQfodVP4O+nir1XwQ2QkUUqrfr_dBpWL0635f0u4oRBA@mail.gmail.com> <20130330091037.GA31743@gmail.com> <0000013dea26b171-8095c339-dc81-4459-a3ad-a8d69c803448-000000@email.amazonses.com>
In-Reply-To: <0000013dea26b171-8095c339-dc81-4459-a3ad-a8d69c803448-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-04-08 10:57 AM, Christoph Lameter wrote:
> I think we could simplify things quite a bit if we either
> 
> 1. Add any cpus specified with nohz_full/extended=xxx to
> rcu_nocb. No check is then necessary anymore.
> 
> or
> 
> 2. Avoid the setting of cpus entirely? If full nohz mode is desired
> then pick one cpu (f.e. the first one or the one that is used for xtime
> updates) and then make all other cpus nohz. Set the affinity mask for the
> rcuoXXX threads to that cpu.

I can imagine people with multi socket systems wanting to have
a system partitioned with one "normal" core per physical socket,
for timekeeping, RCU threads, etc, but #2 would prevent that.

Paul.
