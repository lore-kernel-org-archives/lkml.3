Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab3DMMyL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 08:54:11 -0400
Received: from smtp209.alice.it ([82.57.200.105]:41958 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975Ab3DMMyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 08:54:10 -0400
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Apr 2013 08:54:09 EDT
Message-ID: <51695273.6080800@alice.it>
Date: Sat, 13 Apr 2013 14:41:23 +0200
From: Marco <firefox82@alice.it>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-mm@kvack.org
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Return value of __mm_populate
References: <51694C2A.4050906@gmail.com>
In-Reply-To: <51694C2A.4050906@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding in cc: lkml

Il 13/04/2013 14:14, Marco Stornelli ha scritto:
> Hi,
>
> I was seeing the code of __mm_populate (in -next) and I've got a doubt
> about the return value. The function __mlock_posix_error_return should
> return a proper error for mlock, converting the return value from
> __get_user_pages. It checks for EFAULT and ENOMEM. Actually
> __get_user_pages could return, in addition, ERESTARTSYS and EHWPOISON.
> So it seems to me that we could return to user space not expected value.
> I can't see them on the man page. In addition we shouldn't ever return
> ERESTARTSYS to the user space but EINTR. According to the man pages
> maybe we should return EAGAIN in these cases. Am I missing something?
>
> Thanks,
>
> Marco
