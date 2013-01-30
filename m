Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab3A3U6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 15:58:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57516 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3A3U6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 15:58:48 -0500
Date: Wed, 30 Jan 2013 21:58:47 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 07/12] perf, x86: Avoid checkpointed counters causing excessive TSX aborts v3
Message-ID: <20130130205847.GG30577@one.firstfloor.org>
References: <1359151245-13179-1-git-send-email-andi@firstfloor.org> <1359151245-13179-8-git-send-email-andi@firstfloor.org> <CABPqkBTM8w_RVrQNiyhBprMBjL5a0Q7Y9KQsKP3Ld62EZPSufQ@mail.gmail.com> <20130128231659.GW30577@one.firstfloor.org> <CABPqkBS=1gQCiWRQYJ8Y0QqFLvmkf0NiRivK-xpFmqwpXwyByA@mail.gmail.com> <20130129010029.GY30577@one.firstfloor.org> <CABPqkBTUfwTcG5U_LMAz6MKDHiCbCkTs5yzqYiRBqcWkJDzDew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTUfwTcG5U_LMAz6MKDHiCbCkTs5yzqYiRBqcWkJDzDew@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's a very low sampling rate, yet I think it would be rejected by your code.

You mean allowed? 

> But if I come in with frequency 0x7fffffff+1, then that's a very high
> frequency, thus
> small period, I would pass the test. So I think you need to reinforce the test
> for freq=1.

I'm aware that there are some configs that can slip through, but there's
no other choice if we still allow guest perf stat. The cutoff is
somewhat arbitary.

It's not a correctness problem, just things can be unexpectedly slower
and you may see unexpected NMI messages.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
