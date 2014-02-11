Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaBKBK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 20:10:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27147 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbaBKBKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 20:10:55 -0500
X-IronPort-AV: E=Sophos;i="4.95,821,1384272000"; 
   d="scan'208";a="9502792"
Message-ID: <52F97892.1040205@cn.fujitsu.com>
Date: Tue, 11 Feb 2014 09:10:42 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, raistlin@linux.it, juri.lelli@gmail.com,
        clark.williams@gmail.com, mingo@redhat.com
Subject: Re: [PATCH 1/3] sched: Move the priority specific bits into a new
 header file.
References: <cover.1390859827.git.yangds.fnst@cn.fujitsu.com> <f7549508a1588da2c613d601748ca9de30fa5dcf.1390859827.git.yangds.fnst@cn.fujitsu.com> <87fvo75pci.fsf@sejong.aot.lge.com> <52F83FE2.90004@cn.fujitsu.com> <20140210090948.02266f38@gandalf.local.home>
In-Reply-To: <20140210090948.02266f38@gandalf.local.home>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/11 09:08:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/11 09:08:57,
	Serialize complete at 2014/02/11 09:08:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On 02/10/2014 10:09 PM, Steven Rostedt wrote:
>
>
> That's why you have:
>
> +++ b/include/linux/sched/prio.h
> @@ -0,0 +1,23 @@
> +#ifndef _SCHED_PRIO_H
> +#define _SCHED_PRIO_H
>
> The first time a header gets included, it checks if _SCHED_PRIO_H is
> defined, if not, it defines it and continues. Otherwise it skips the
> content of the file.
>
> This is so standard practice that CPP (C Pre-Processor) optimizes this
> by checking if this exists and caches it. It wont even open the file
> the second time it sees it included.

Wow, yes. Thank you for your kind explanation. :)
>
> -- Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

