Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaG2PO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:14:58 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:60353 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbaG2PO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:14:56 -0400
Message-ID: <53D7BA6E.9040002@gmail.com>
Date: Tue, 29 Jul 2014 09:14:54 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [RFC/PATCH] perf tools: Check recorded kernel version when finding
 vmlinux
References: <1406621715-27819-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1406621715-27819-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/14, 2:15 AM, Namhyung Kim wrote:
> This requires to change signature of symbol__init() to receive struct
> perf_session_env *.  This patch only does some trivial changes - some

Why only pass the env for perf-report? Why not for any command analyzing 
a file? So for live commands env is NULL meaning use host paths; for 
recorded files pass env from session header and use it (plus symbol 
settings like symfs).

David
