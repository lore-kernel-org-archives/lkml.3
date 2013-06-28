Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3F1NmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:42:05 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:41525 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3F1NmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:42:03 -0400
Message-ID: <51CD92A3.5000202@gmail.com>
Date: Fri, 28 Jun 2013 07:41:55 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 06/15] perf tools: fix parse_events_terms() freeing
 local variable on error path
References: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com> <1372319707-13892-7-git-send-email-adrian.hunter@intel.com> <51CC64A7.6040305@gmail.com> <51CD2DFE.6070704@intel.com>
In-Reply-To: <51CD2DFE.6070704@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/13 12:32 AM, Adrian Hunter wrote:

>> Seems like you can just fix parse_events__free_terms to do the right thing
>> and not call free(terms) -- ie., no need for a separate "only" function.
>>  From there only test_term() needs to do the free(terms) and since it mallocs
>> the memory there it is nicely symmetrical.
>
> There are 2 more calls to parse_events__free_terms in util/parse-events.y
>

Right and both look like stack case uses. I don't see the need for 
__free_terms to free the list so no need for an _only version.

David
