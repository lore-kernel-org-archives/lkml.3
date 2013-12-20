Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab3LTRJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 12:09:58 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:58662 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab3LTRJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 12:09:57 -0500
Message-ID: <52B479E1.7020204@gmail.com>
Date: Fri, 20 Dec 2013 10:09:53 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Joseph Schuchart <joseph.schuchart@tu-dresden.de>,
        Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        thomas.ilsche@tu-dresden.de, linux-kernel@vger.kernel.org,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] Perf: Correct Assumptions about Sample Timestamps in
 Passes
References: <528484CB.7@tu-dresden.de> <20131114083930.GC16543@gmail.com> <528490DE.4080204@tu-dresden.de> <20131114100552.GA5064@gmail.com> <528E1EE6.9040407@tu-dresden.de> <20131127135137.GA24403@gmail.com> <52B437AA.4090102@tu-dresden.de>
In-Reply-To: <52B437AA.4090102@tu-dresden.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/13, 5:27 AM, Joseph Schuchart wrote:
> I know this comes late, but: As far as I can see, your change does not
> preserve the logic of the code I suggested. The idea was to first gather
> all the maximum timestamps of all cpus (that is, the last timestamp seen
> on each cpu) and then determine the minimum of these maxima. These are
> two distinct steps that I think cannot be combined in one update. Your

  A number of people have reported similar problems -- timestamps below 
last flush time. This approach would solve that problem for data 
processed from files, so it would be a good improvement.

David
