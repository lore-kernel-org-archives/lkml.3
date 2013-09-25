Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab3IYAuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:50:39 -0400
Received: from intranet.asianux.com ([58.214.24.6]:38014 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486Ab3IYAue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:50:34 -0400
X-Spam-Score: -100.7
Message-ID: <5242331B.4010309@asianux.com>
Date: Wed, 25 Sep 2013 08:49:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] kernel/groups.c: consider about NULL for 'group_info'
 in all related extern functions
References: <5212DBFA.8030805@asianux.com> <20130923150625.GB14547@htj.dyndns.org> <52410A40.1000304@asianux.com> <20130924040601.GA31575@mtj.dyndns.org> <524114B8.3070903@asianux.com> <20130924120429.GA2366@htj.dyndns.org>
In-Reply-To: <20130924120429.GA2366@htj.dyndns.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 08:04 PM, Tejun Heo wrote:
> On Tue, Sep 24, 2013 at 12:27:36PM +0800, Chen Gang wrote:
>> For real world, /sbin/init will call setgroups, so user space 'help'
>> kernel itself to protect this issue, but I think, we don't only depend
>> on the user space help checking.
>>
>> The proof is below:
>>
>>   [root@gchenlinux tmp]# grep setgroups /sbin/*
>>   Binary file /sbin/init matches
>>   Binary file /sbin/rpc.statd matches
>>   Binary file /sbin/rsyslogd matches
>>   Binary file /sbin/runuser matches
>>
>> From reading kernel source code, kernel itself does not intend to set
>> 'group_info', it is triggered by user space or another kernel mode
>> sub-systems.
> 
> Can you please demonstrate such failure?  You can tell kernel to
> execute a given binary instead of init with "init=" param.
> 

OK, I will/should try, today (although I have to spend my additional
time resource on it. :-( ).

Hmm... in fact, in my opinion, interface (especially content system
call) need make itself consistency, although at present, it can not
cause issue.

> Thanks.
> 

Thanks.
-- 
Chen Gang
