Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966240AbaLMJDi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 04:03:38 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:49526 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966214AbaLMJDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 04:03:33 -0500
Date: Sat, 13 Dec 2014 10:03:31 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: "perf top -g" leaking ~300MB per second.
Message-ID: <20141213090331.GB13453@x4>
References: <20141213084845.GA13453@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141213084845.GA13453@x4>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.12.13 at 09:48 +0100, Markus Trippelsdorf wrote:
> Running "perf top -g" built from current Linus tree apparently leaks
> ~300MB of memory every second an my machine.

Hmm, this is a much older problem. I just noticed this the first time
today. 
To reproduce: Compile some application in the background (make -j4 in my
case) and run "perf top -g". Perf will continue to accumulate memory
until the system starts to swap and the OOM killer eventually kicks in.

-- 
Markus
