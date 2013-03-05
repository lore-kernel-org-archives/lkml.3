Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab3CEUk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:40:58 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:55498 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab3CEUk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:40:56 -0500
Message-ID: <1362516018.4392.233.camel@falcor1>
Subject: Re: IMA: How to manage user space signing policy with others
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Date: Tue, 05 Mar 2013 15:40:18 -0500
In-Reply-To: <20130305151829.GB4519@redhat.com>
References: <1362140107.9158.101.camel@falcor1>
	 <20130301152839.GA3457@redhat.com> <20130301184027.GB3457@redhat.com>
	 <1362166753.9158.169.camel@falcor1> <20130301213329.GC3457@redhat.com>
	 <1362346944.18325.1.camel@falcor1> <20130304152919.GA15199@redhat.com>
	 <1362423581.4392.46.camel@falcor1> <20130304191546.GF15199@redhat.com>
	 <1362446491.4392.133.camel@falcor1> <20130305151829.GB4519@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030520-3620-0000-0000-0000017DB324
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-05 at 10:18 -0500, Vivek Goyal wrote:

> Can we do following. (Just modifying your proposal little bit).
> 
> - Implement a new policy say ima_mem_exec. This policy can vary based on
>   config options. This will be the default policy. 

Just to clarify, the default is the existing null policy.  When
'secureboot' is enabled, ima_mem_exec will be the default policy.

> - ima_mem_exec will be default policy and it can be disabled by passing
>   a command line option ima_mem_exec_disable.
> 
> - If user wants to use ima_apprase_tcb policy, they can pass two command
>   line option. (ima_mem_exec_disable  and ima_appraise_tcb).

Both aren't really needed.   Nothing changes for existing users, if
'ima_appraise_tcb' replaces the ima_mem_exec policy. 

> - Similary if user wants to put its own policy using "policy" interface,
>   they need to boot kernel with command line option "ima_mem_exec_disable".

Not a good idea, as this would be a new requirement for existing users.
Invert the logic.

> In the end, this is again "either A or B"  mechanism. Both ima_mem_exec
> and ima_appraise_tcb are not co-existing. Comand line option just enables
> choosing one over other.

Does this impact 'ima_tcb' or only 'ima_appraise_tcb'?

> The fact that we are able to replace ima_mem_exec policy using command
> line, binary loader will need a way to query IMA to find what's the
> current policy. If ima_mem_exec has been replaced, then binary loader
> will not memlock files and will not raise extra capability to binary. And
> this will disable kdump functionality on secureboot platforms. (Something
> which I don't like much).

Ok

thanks,

Mimi

