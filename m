Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbaAPBDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:03:52 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61793 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaAPBDu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:03:50 -0500
X-AuditID: 9c930197-b7b7cae000000e34-c9-52d72ff5afd7
From: Namhyung Kim <namhyung@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Gaurav Jain <gjain@fb.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH] perf tools: Synthesize anon MMAP records on the heap
References: <20140113165441.GB25953@redhat.com> <CEFB09CC.2CAAA%gjain@fb.com>
	<20140115142727.GJ25953@redhat.com>
Date: Thu, 16 Jan 2014 10:03:48 +0900
In-Reply-To: <20140115142727.GJ25953@redhat.com> (Don Zickus's message of
	"Wed, 15 Jan 2014 09:27:27 -0500")
Message-ID: <87ha9491qj.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

On Wed, 15 Jan 2014 09:27:27 -0500, Don Zickus wrote:
> On Tue, Jan 14, 2014 at 08:48:23PM +0000, Gaurav Jain wrote:
>> On 1/13/14, 11:54 AM, "Don Zickus" <dzickus@redhat.com> wrote:
>> 
>> >On Sat, Jan 11, 2014 at 08:32:14PM -0800, Gaurav Jain wrote:
>> >> Anon records usually do not have the 'execname' entry. However if they
>> >>are on
>> >> the heap, the execname shows up as '[heap]'. The fix considers any
>> >>executable
>> >> entries in the map that do not have a name or are on the heap as anon
>> >>records
>> >> and sets the name to '//anon'.
>> >> 
>> >> This fixes JIT profiling for records on the heap.
>> >
>> >I guess I don't understand the need for this fix.  It seems breaking out
>> >//anon vs. [heap] would be useful.  Your patch is saying otherwise.  Can
>> >give a description of the problem you are trying to solve?
>> 
>> Thank you for looking at the patch.
>> 
>> We generate a perf map file which includes certain JIT¹ed functions that
>> show up as [heap] entries. As a result, I included the executable heap
>> entries as anon pages so that it would be handled in
>> util/map.c:map__new(). The alternative would be to handle heap entries in
>> map__new() directly, however I wasn¹t sure if this would break something
>> as it seems that heap and stack entries are expected to fail all
>> map__find_* functions. Thus I considered executable heap entries as
>> //anon, but perhaps there is a better way.
>
> Thanks for the improved problem description.   I see it led to a better
> patch. :-)  That is why it is generally a good idea to describe the
> problem you are trying to solve to see if others have a better solution.

Yes, thank you very much for pointing it out and helping to resolve this
issue!

Thanks,
Namhyung
