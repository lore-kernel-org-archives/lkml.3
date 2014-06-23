Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbaFWOGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:06:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58246 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbaFWOGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:06:23 -0400
Message-ID: <53A8346A.80905@gmail.com>
Date: Mon, 23 Jun 2014 08:06:34 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>
CC: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] perf kvm: move perf_kvm__mmap_read into session utils
References: <1403261389-13423-1-git-send-email-stfomichev@yandex-team.ru> <1403261389-13423-7-git-send-email-stfomichev@yandex-team.ru> <20140620144427.GF31524@kernel.org>
In-Reply-To: <20140620144427.GF31524@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/14, 8:44 AM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jun 20, 2014 at 02:49:48PM +0400, Stanislav Fomichev escreveu:
>> It will be reused by perf trace in the following commit.
>
> I know this is needed, but one of the goals when I started builtin-trace
> was not to use perf_session at all, as it initially was just about the
> live mode.
>
> record/replay came later and ended up needing it,

perf-kvm does not use the session code because I kept tripping over the 
out of order timestamp problem. By limiting the number of events read in 
a single pass I was able to smooth out the load and avoided hitting it 
as often. As I mentioned before the final piece was using the perf_clock 
timestamp at the start of the round to ensure I never hit it.

Stanislav: are you seeing out of order timestamp errors or just trying 
to reuse the live code from perf-kvm?

David
