Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaCGNvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:51:13 -0500
Received: from relay.parallels.com ([195.214.232.42]:54824 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbaCGNvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:51:12 -0500
Message-ID: <5319CEC7.6090009@parallels.com>
Date: Fri, 7 Mar 2014 17:51:03 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Andrew Vagin <avagin@gmail.com>,
        Aditya Kali <adityakali@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Oleg Nesterov <oleg@redhat.com>, <linux-kernel@vger.kernel.org>,
        <criu@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [CRIU] [PATCH 1/3] prctl: reduce permissions to change boundaries
 of data, brk and stack
References: <1392387209-330-1-git-send-email-avagin@openvz.org> <1392387209-330-2-git-send-email-avagin@openvz.org> <874n41znl5.fsf@xmission.com> <20140214174314.GA5518@gmail.com> <20140214180129.GK13358@moon> <8761ohqzc6.fsf@xmission.com> <52FE72C1.9090100@parallels.com> <87txc1pibc.fsf@xmission.com> <5301C984.40904@parallels.com>
In-Reply-To: <5301C984.40904@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Eric,

>>>> Why can't you have the process of interest do:
>>>> 	ptrace(PTRACE_ATTACHME);
>>>> 	execve(executable, args, ...);
>>>>         
>>>>         /* Have the ptracer inject the recovery/fixup code */
>>>> 	/* Fix up the mostly correct process to look like it has been
>>>>          * executing for a while.
>>>>          */

> 2. What you propose means we have to effectively strace and execve-ing task. As
> compared with plain prlctl this is up to ~600 times slower. I've made such an experiment.

Have you had time to think on the issue? If the prctl restrictions do not work,
what else can it be?

Thanks,
Pavel
