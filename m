Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbaE2J4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:56:12 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:50783 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006AbaE2J4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:56:11 -0400
Message-ID: <53870433.8090606@hitachi.com>
Date: Thu, 29 May 2014 18:56:03 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] perf probe segfaulting when asked for variable it doesn't
 find
References: <20140528214406.GE2764@kernel.org>
In-Reply-To: <20140528214406.GE2764@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/05/29 6:44), Arnaldo Carvalho de Melo wrote:
> Masami-san,
> 
> 	While trying:
> 
> [root@zoo ~]# perf probe 'vfs_getname=getname_flags:65 pathname=result->name:string'
> Failed to find the location of result at this address.
>  Perhaps, it has been optimized out.
> Failed to find 'result' in this function.
>   Error: Failed to add events. (-2)
> [root@zoo ~]# perf probe 'vfs_getname=getname_flags:65 pathname=result->name:string'
> Added new event:
> Segmentation fault (core dumped)
> 
> I got segfaulted while in the past I would get the much nicer:
> 
> [root@zoo ~]# perf probe 'vfs_getname=getname_flags:65 pathname=result->name:string'
> Failed to find the location of result at this address.
>  Perhaps, it has been optimized out.
> Failed to find 'result' in this function.
>   Error: Failed to add events. (-2)
> [root@zoo ~]#

Oops, I got that. Bad SEGV was reproduced here too.
And I've found an error-handling miss in the convert_variable(),
I'll send a patch for fixing it.
Thank you very much for bisecting and finding my fault.

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


