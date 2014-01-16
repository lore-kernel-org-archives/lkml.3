Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbaAPJaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:30:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbaAPJaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:30:00 -0500
Message-ID: <52D7A68F.5030700@redhat.com>
Date: Thu, 16 Jan 2014 10:29:51 +0100
From: =?windows-1252?Q?Jan_Kalu=9Ea?= <jkaluza@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Eric Paris <eparis@redhat.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rgb@redhat.com, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH v4 0/3] Send audit/procinfo/cgroup data in socket-level
 control message
References: <1377614400-27122-1-git-send-email-jkaluza@redhat.com> <1389600109-30739-1-git-send-email-jkaluza@redhat.com> <20140115.121730.1984913330507219167.davem@davemloft.net> <1389828103.681.34.camel@flatline.rdu.redhat.com> <20140115232345.GA22237@mtj.dyndns.org>
In-Reply-To: <20140115232345.GA22237@mtj.dyndns.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 12:23 AM, Tejun Heo wrote:
> On Wed, Jan 15, 2014 at 06:21:43PM -0500, Eric Paris wrote:
>> Reliably being able to audit what process requested an action is
>> extremely useful.  And I like the audit patch, as it is a couple of ints
>> we are storing.
>>
>> procinfo and cgroup can both be up to 4k of data.
>>
>> Is there an alternative he should consider?  Some way to grab a
>> reference on task_struct and just attach that to the message?
>
> Or maybe it can be made separately optional instead of tagging along
> on an existing option so that it doesn't tax use cases which don't
> care about the new stuff?

Right, I could add new option next to SOCK_PASSCRED which could be used 
to send newly added stuff. Would this be acceptable?

I would still vote for SCM_AUDIT to be part of SOCK_PASSCRED and move 
SCM_CGROUP and SCM_PROCINFO into new option.

> Thanks.
>

Regards,
Jan Kaluza

