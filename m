Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab3LIFqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 00:46:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:26225 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754148Ab3LIFqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 00:46:10 -0500
X-IronPort-AV: E=Sophos;i="4.93,856,1378828800"; 
   d="scan'208";a="9219986"
Message-ID: <52A60F84.1020106@cn.fujitsu.com>
Date: Mon, 09 Dec 2013 13:44:20 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix bug for perf kvm report without guestmount.
References: <1386365588-13046-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20131206115627.GA2279@ghostprotocols.net> <52A5DFC9.6020105@cn.fujitsu.com> <52A53C3A.2090107@gmail.com> <52A5FA13.9000000@cn.fujitsu.com> <52A547F4.6080904@gmail.com> <52A60695.1020504@cn.fujitsu.com> <52A60ED6.9050903@cn.fujitsu.com>
In-Reply-To: <52A60ED6.9050903@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 13:45:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 13:45:54,
	Serialize complete at 2013/12/09 13:45:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> When more than 1 VM, the cases you provided is all about 
>> record-report the symbols from __all__ guests. How about I want to 
>> record-report one of them?
>> Example:
>>     There are 2 guests are running different kernels, I want to 
>> record-report VM1.
>>
>> Currently, we can use --guestmount to get the symbols of VM1, but we 
>> can not remove the symbols of VM2 from report. It means the 
>> percentage of each symbol is not  the symbol only in this VM1.
>>
>> What I want with introducing guestpid is to record-report the symbols 
>> only from VM1, and ignore VM2.
>>
>
> Besides, as we provide two usages of perf-kvm in manpage, 
> guestmount-way and guest{kallsyms,modules}-way, but the 
> guest{kallsyms, modules} is not used 
s/not/only. Sorry for the typo :(
> when
> there is only one guest is running, the guestmount is used in all 
> situations, it seems not reasonable. I think we can provide a guestpid 
> to make the guestkallsyms-way can be used in any situation.
>
> This way, user can understand and choose the usage easily.
>
> 1. one or more guests you want to record-report, --guestmount-way. It 
> provides the full functionality of perf kvm.
>
> 2. only one guest you want to record-report, --guestmount is also 
> available, and there is another usage for this most used case as a 
> shortcut , --guest{kallsyms, modules, pid}.
>
> Then the relationship between the two kinds of usage is more clear, 
> right? And in this way, we can make the result of perf-kvm more 
> foreseeable to user.
>
>>> David
>>>
>>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

