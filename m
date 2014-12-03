Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaLCJPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:15:38 -0500
Received: from smtprelay0048.hostedemail.com ([216.40.44.48]:33893 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750855AbaLCJPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:15:35 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2196:2199:2393:2553:2559:2562:3138:3139:3140:3141:3142:3354:3622:3865:3867:3868:3870:3871:3872:3874:4321:4362:4385:4605:5007:6261:7576:7875:7903:9040:10004:10400:10402:10407:10848:10967:11026:11232:11658:11914:12049:12296:12438:12517:12519:12555:12740:14096:14097:19901:19997:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shop19_137f87c380145
X-Filterd-Recvd-Size: 2896
Date: Wed, 3 Dec 2014 04:15:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: byungchul.park@lge.com
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, seungho1.park@lge.com,
        jolsa@redhat.com
Subject: Re: [PATCH v6] tracing: add additional marks to signal very large
 time
Message-ID: <20141203041533.6ce4f9d0@gandalf.local.home>
In-Reply-To: <1416789259-24038-1-git-send-email-byungchul.park@lge.com>
References: <1416789259-24038-1-git-send-email-byungchul.park@lge.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014 09:34:19 +0900
byungchul.park@lge.com wrote:

> From: Byungchul Park <byungchul.park@lge.com>
> 
> Currently, function graph tracer prints "!" or "+" just before
> function execution time to signal a function overhead, depending
> on the time. And some tracers tracing latency also print "!" or
> "+" just after time to signal overhead, depending on the interval
> between events. Even it is usually enough to do that, we sometimes
> need to be signaled for bigger execution time than 100 micro seconds.
> 
> For example, I used function graph tracer to detect if there is
> any case that exit_mm() takes too much time. I did following steps
> in /sys/kernel/debug/tracing. It was easier to detect very big
> excution time with patched kernel than with original kernel.
> 
> $ echo exit_mm > set_graph_function
> $ echo function_graph > current_tracer
> $ echo > trace
> $ cat trace_pipe > $LOGFILE
>  ... (do something and terminate logging)
> $ grep "\\$" $LOGFILE
>  3) $ 22082032 us |                      } /* kernel_map_pages */
>  3) $ 22082040 us |                    } /* free_pages_prepare */
>  3) $ 22082113 us |                  } /* free_hot_cold_page */
>  3) $ 22083455 us |                } /* free_hot_cold_page_list */
>  3) $ 22083895 us |              } /* release_pages */
>  3) $ 22177873 us |            } /* free_pages_and_swap_cache */
>  3) $ 22178929 us |          } /* unmap_single_vma */
>  3) $ 22198885 us |        } /* unmap_vmas */
>  3) $ 22206949 us |      } /* exit_mmap */
>  3) $ 22207659 us |    } /* mmput */
>  3) $ 22207793 us |  } /* exit_mm */
> 
> And then, it was easy to find out that a schedule-out occured by
> sub_preempt_count() within kernel_map_pages().
> 
> To detect very large function exection time caused by either problematic
> function implementation or scheduling issues, this patch can be useful.
> 
> Signed-off-by: Byungchul Park <byungchul.park@lge.com>

Looks good!

Thanks,

-- Steve
