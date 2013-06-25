Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab3FYXEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 19:04:43 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63562 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3FYXEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 19:04:42 -0400
Message-ID: <51CA2205.4040006@gmail.com>
Date: Tue, 25 Jun 2013 17:04:37 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 12/15] perf tools: allow non-matching sample types
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com> <1372079772-20803-13-git-send-email-adrian.hunter@intel.com> <51C9BDB2.7060905@gmail.com> <CABPqkBQK5PdcULwtAefsVKvV+Ne6kaaH2_jeoba8kz3Ui_EqAw@mail.gmail.com>
In-Reply-To: <CABPqkBQK5PdcULwtAefsVKvV+Ne6kaaH2_jeoba8kz3Ui_EqAw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/13 10:03 AM, Stephane Eranian wrote:
>> Stephane: are you looking at allowing sample_types per event?
>> >
> Yes, this is what I need. I have a kernel patch to do this. I don't
> know how to update perf to handle it correctly. So maybe you can
> help. My patch is useful to drastically reduce the size of the perf.data
> file in case we use the branch-stack with lots of events which is
> what our Gooda tool would like to do.

Refreshing my memory on the root problem here. It's a chicken-and-egg 
problem: we need the id in the sample to find the event (evsel) that 
generated it (perf_evlist__id2evsel). To get the id we need the 
sample_type to parse it and we want the sample_type to be per event.

As I recall this is where the conversation turns to per-event data files...

David
