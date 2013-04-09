Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936183Ab3DIUL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:11:28 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:61087 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933036Ab3DIUL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:11:27 -0400
Message-ID: <516475EB.7030508@linaro.org>
Date: Tue, 09 Apr 2013 13:11:23 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>, John Stultz <johnstul@us.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] fs, proc: truncate /proc/pid/comm writes to first TASK_COMM_LEN
 bytes
References: <alpine.DEB.2.02.1304081854440.22640@chino.kir.corp.google.com> <20130409130306.4e24a5dd1773c99eaf356db8@linux-foundation.org>
In-Reply-To: <20130409130306.4e24a5dd1773c99eaf356db8@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 01:03 PM, Andrew Morton wrote:
>> cc: John Stultz <johnstul@us.ibm.com>
> I don't know if that address still works.

No, that email is no longer active. Thanks for noticing this.


> From: David Rientjes <rientjes@google.com>
> Subject: fs, proc: truncate /proc/pid/comm writes to first TASK_COMM_LEN bytes
>
> Currently, a write to a procfs file will return the number of bytes
> successfully written.  If the actual string is longer than this, the
> remainder of the string will not be be written and userspace will complete
> the operation by issuing additional write()s.
>
> Hence
>
> 	$ echo -n "abcdefghijklmnopqrs" > /proc/self/comm
>
> results in
>
> 	$ cat /proc/$$/comm
> 	pqrs
>
> since the final four bytes were written with a second write() since
> TASK_COMM_LEN == 16.  This is obviously an undesired result and not
> equivalent to prctl(PR_SET_NAME).  The implementation should not need to
> know the definition of TASK_COMM_LEN.

That's embarrassing, thanks for catching it!


> This patch truncates the string to the first TASK_COMM_LEN bytes and
> returns the bytes written as the length of the string written so the
> second write() is suppressed.
>
> 	$ cat /proc/$$/comm
> 	abcdefghijklmno
>
> Signed-off-by: David Rientjes <rientjes@google.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: John Stultz <john.stultz@linaro.org>
