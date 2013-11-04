Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab3KDPR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 10:17:29 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:36247 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab3KDPR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 10:17:28 -0500
Message-ID: <5277BA84.1090208@gmail.com>
Date: Mon, 04 Nov 2013 08:17:24 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
CC: Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 3/3] perf tools: Check maximum frequency rate for record/top
References: <1383563173-17466-1-git-send-email-jolsa@redhat.com> <1383563173-17466-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1383563173-17466-4-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/4/13, 4:06 AM, Jiri Olsa wrote:
> Adding the check for maximum allowed frequency rate
> defined in following file:
>    /proc/sys/kernel/perf_event_max_sample_rate
>
> When we cross the maximum value we fail and display
> detailed error message with advise.

perf commands should automatically adjust the default frequency too. If 
the user did not specify a frequency then this message is going to be 
confusing.

Though the algorithm that keeps lowering the rate should be tweaked as well.

David
