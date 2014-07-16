Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798AbaGPPF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:05:26 -0400
Received: from mga14.intel.com ([192.55.52.115]:61384 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbaGPPFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:05:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,673,1400050800"; 
   d="scan'208";a="562696201"
Message-ID: <53C6948C.2080103@intel.com>
Date: Wed, 16 Jul 2014 18:04:44 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 20/41] perf tools: Let a user specify a PMU event without
 any config terms
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com> <1405332185-4050-21-git-send-email-adrian.hunter@intel.com> <20140716142510.GE9441@krava.redhat.com>
In-Reply-To: <20140716142510.GE9441@krava.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/07/2014 5:25 p.m., Jiri Olsa wrote:
> On Mon, Jul 14, 2014 at 01:02:44PM +0300, Adrian Hunter wrote:
>> This enables a PMU event to be specified in the form:
>>
>> 	pmu//
>>
>> which is effectively the same as:
>>
>> 	pmu/config=0/
>>
>> This patch is a precursor to defining
>> default config for a PMU.
>
> I understand the need for default config, but could you please elaborate
> why do we want to parse 'pmu//' as an event string string?

Currently the parser requires the slashes to identify a PMU event
as opposed to a hardware or other kind of event.
