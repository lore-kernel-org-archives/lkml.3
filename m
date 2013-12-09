Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588Ab3LIEOo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 23:14:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63157 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755693Ab3LIEOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 23:14:42 -0500
X-IronPort-AV: E=Sophos;i="4.93,855,1378828800"; 
   d="scan'208";a="9219420"
Message-ID: <52A5FA13.9000000@cn.fujitsu.com>
Date: Mon, 09 Dec 2013 12:12:51 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix bug for perf kvm report without guestmount.
References: <1386365588-13046-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20131206115627.GA2279@ghostprotocols.net> <52A5DFC9.6020105@cn.fujitsu.com> <52A53C3A.2090107@gmail.com>
In-Reply-To: <52A53C3A.2090107@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 12:14:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 12:14:26,
	Serialize complete at 2013/12/09 12:14:26
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2013 10:42 PM, David Ahern wrote:
> On 12/9/13, 8:20 AM, Dongsheng Yang wrote:
>> How about introduce an option named --guestpid? Then we can make the
>> usage of perf kvm
>> more clear:
>>      * perf kvm --guestkallsyms --guestmodules --guestpid
>> [top|record|report]
>>          This usage is for only one guest and will not resolve the
>> symbols from other guests.
>
> If there is only 1 guest then there should not be a problem right? You 
> give perf a single guest kallsyms as the "default" and it works. 
> --guestpid adds no value in that case.

Yes, if there is only one guest is running, "default" guest is "the" 
guest. Then with my patch in this thread applied, it works well.

But consider this scenario, there are two guests are running, but we 
need to record-report one of them.

--guestmount can achieve this request, but as a shortcut of guestmount, 
--guest{kallysms, modules} dose not
support it well, right? So, I think we can discard the default guest, 
and use guestpid in record-report.
>
> David
>
>
>

