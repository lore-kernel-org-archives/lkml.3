Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092AbaISOVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 10:21:41 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:49290 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500AbaISOVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 10:21:38 -0400
Message-ID: <541C3BEF.4010907@gmail.com>
Date: Fri, 19 Sep 2014 08:21:35 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf session: Add option to copy events when queueing
References: <1411060059-23589-1-git-send-email-yarygin@linux.vnet.ibm.com>	<1411060059-23589-2-git-send-email-yarygin@linux.vnet.ibm.com>	<20140918185345.GJ2770@kernel.org> <541B3ECD.8000706@gmail.com>	<541B40A8.8020406@gmail.com> <87r3z86lnu.fsf@linux.vnet.ibm.com>
In-Reply-To: <87r3z86lnu.fsf@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/19/14, 2:48 AM, Alexander Yarygin wrote:
> It did't work. Turned out that there is at least one event alive after
> finished_round(), usually I get more - ~20. Not sure why, maybe it's
> another problem which should be solved at first?

hmm.... perf_evlist__mmap_consume is not at the event level, but at the 
mmap level -- it assumes everything read has been processed which is not 
true for this case.

David

