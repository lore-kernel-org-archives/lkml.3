Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab3L1MAz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 07:00:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:28174 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755225Ab3L1MAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 07:00:54 -0500
X-IronPort-AV: E=Sophos;i="4.95,566,1384272000"; 
   d="scan'208";a="9340722"
Message-ID: <52BF73CD.10701@cn.fujitsu.com>
Date: Sat, 28 Dec 2013 19:58:53 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: mingo@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] perf tools: Fix bug in 'perf list event_glob'.
References: <cover.1388184724.git.yangds.fnst@cn.fujitsu.com> <5d72ccb261f7f30da7d2e0e05bf5c6352672c9a4.1388184724.git.yangds.fnst@cn.fujitsu.com> <20131227192142.GA3277@infradead.org>
In-Reply-To: <20131227192142.GA3277@infradead.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/28 20:00:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/28 20:00:07,
	Serialize complete at 2013/12/28 20:00:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2013 02:21 PM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Dec 27, 2013 at 06:03:27PM -0500, Dongsheng Yang escreveu:
>> As what the usage showing, we can input a event_glob as an argument to list
>> all symbols. But it does not work well right now.
>>
>> Example:
>> 	# perf list kvmmmu
>>
>> 	List of pre-defined events (to be used in -e):
>>
>> This patch make it work well as follows.
> It works:
>
> List of pre-defined events (to be used in -e):
> [root@zoo ~]# perf list kvmmmu*:*
>    kvmmmu:kvm_mmu_pagetable_walk                      [Tracepoint event]
>    kvmmmu:kvm_mmu_paging_element                      [Tracepoint event]
>    kvmmmu:kvm_mmu_set_accessed_bit                    [Tracepoint event]
>    kvmmmu:kvm_mmu_set_dirty_bit                       [Tracepoint event]
>    kvmmmu:kvm_mmu_walker_error                        [Tracepoint event]
>    kvmmmu:kvm_mmu_get_page                            [Tracepoint event]
>    kvmmmu:kvm_mmu_sync_page                           [Tracepoint event]
>    kvmmmu:kvm_mmu_unsync_page                         [Tracepoint event]
>    kvmmmu:kvm_mmu_prepare_zap_page                    [Tracepoint event]
>    kvmmmu:mark_mmio_spte                              [Tracepoint event]
>    kvmmmu:handle_mmio_page_fault                      [Tracepoint event]
>    kvmmmu:fast_page_fault                             [Tracepoint event]
>    kvmmmu:kvm_mmu_invalidate_zap_all_pages            [Tracepoint event]
>    kvmmmu:check_mmio_spte                             [Tracepoint event]
> [root@zoo ~]#
>
> The documentation says, as you repeated above, that a glob can be
> provided, not a _substring_ :-)

Yes, you are right. Sorry for that I misunderstood the word of 'glob'.

Thank you for your explanation. :)

Yang
>
> To achive a result similar to:
>
> [root@zoo ~]# perf list hw
>    cpu-cycles OR cycles                               [Hardware event]
>    instructions                                       [Hardware event]
>    cache-references                                   [Hardware event]
>    cache-misses                                       [Hardware event]
>    branch-instructions OR branches                    [Hardware event]
>    branch-misses                                      [Hardware event]
>    bus-cycles                                         [Hardware event]
>    stalled-cycles-frontend OR idle-cycles-frontend    [Hardware event]
>    ref-cycles                                         [Hardware event]
> [root@zoo ~]#
>
> We could say that if no ':' is found in the provided string, and it
> doesn't matches one of the other classes, i.e. hw, sw, cache, etc, and
> it is the name of a tracepoint subsystem, then it would be equivalent
> to 'tracepoint_subsys:*', i.e. 'perf list skb' woud be equivalent to:
>
> [root@zoo ~]# perf list skb:*
>    skb:kfree_skb                                      [Tracepoint event]
>    skb:consume_skb                                    [Tracepoint event]
>    skb:skb_copy_datagram_iovec                        [Tracepoint event]
> [root@zoo ~]#
>
> - Arnaldo
>   
>> Verification:
>> 	# perf list kvmmmu
>>
>> 	List of pre-defined events (to be used in -e):
>> 	  kvmmmu:kvm_mmu_pagetable_walk                      [Tracepoint event]
>> 	  kvmmmu:kvm_mmu_paging_element                      [Tracepoint event]
>> 	  kvmmmu:kvm_mmu_set_accessed_bit                    [Tracepoint event]
>> 	  kvmmmu:kvm_mmu_set_dirty_bit                       [Tracepoint event]
>> 	  kvmmmu:kvm_mmu_walker_error                        [Tracepoint event]
>> 	  kvmmmu:kvm_mmu_get_page                            [Tracepoint event]
>> 	  kvmmmu:kvm_mmu_sync_page                           [Tracepoint event]
>> 	  kvmmmu:kvm_mmu_unsync_page                         [Tracepoint event]
>> 	  kvmmmu:kvm_mmu_prepare_zap_page                    [Tracepoint event]
>> 	  kvmmmu:mark_mmio_spte                              [Tracepoint event]
>> 	  kvmmmu:handle_mmio_page_fault                      [Tracepoint event]
>> 	  kvmmmu:fast_page_fault                             [Tracepoint event]
>>
>> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
>> ---
>>   tools/perf/util/parse-events.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
>> index 094c28b..d887ea4 100644
>> --- a/tools/perf/util/parse-events.c
>> +++ b/tools/perf/util/parse-events.c
>> @@ -1236,6 +1236,8 @@ void print_events(const char *event_glob, bool name_only)
>>   
>>   	print_pmu_events(event_glob, name_only);
>>   
>> +	print_tracepoint_events(event_glob, NULL, name_only);
>> +
>>   	if (event_glob != NULL)
>>   		return;
>>   
>> @@ -1254,8 +1256,6 @@ void print_events(const char *event_glob, bool name_only)
>>   			event_type_descriptors[PERF_TYPE_BREAKPOINT]);
>>   		printf("\n");
>>   	}
>> -
>> -	print_tracepoint_events(NULL, NULL, name_only);
>>   }
>>   
>>   int parse_events__is_hardcoded_term(struct parse_events_term *term)
>> -- 
>> 1.8.2.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

