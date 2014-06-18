Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaFRTLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:11:00 -0400
Received: from relay.parallels.com ([195.214.232.42]:44567 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbaFRTK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:10:59 -0400
Message-ID: <53A1E41F.9010504@parallels.com>
Date: Wed, 18 Jun 2014 23:10:23 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>,
        <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "David Howells" <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Vasiliy Kulikov <segooon@gmail.com>,
        "Gotou Yasunori" <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH] ns: introduce getnspid syscall
References: <1403000496-10094-1-git-send-email-chenhanxiao@cn.fujitsu.com> <53A030CE.6070101@parallels.com> <20140618180237.GA22219@redhat.com>
In-Reply-To: <20140618180237.GA22219@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [89.169.95.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 10:02 PM, Oleg Nesterov wrote:
> On 06/17, Pavel Emelyanov wrote:
>>
>> On 06/17/2014 02:21 PM, Chen Hanxiao wrote:
>>> +	case PIDTYPE_PID:
>>> +		ret = task_pid_nr_ns(task, ns2);
>>
>> But this is not correct. If task doesn't live in ns2, but ns2
>> just has the ns->level small enough, then the wrong pid value
>> would be reported.
> 
> Confused... pid_nr_ns() checks upid->ns == ns and returns zero
> otherwise?

Yes, you're right. I've missed that line of code :(

> Oleg.
> 
> .
> 


