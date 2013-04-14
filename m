Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3DNASv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 20:18:51 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53092 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab3DNASt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 20:18:49 -0400
Message-ID: <5169F5E7.3070100@gmail.com>
Date: Sat, 13 Apr 2013 17:18:47 -0700
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Marco Stornelli <marco.stornelli@gmail.com>
CC: linux-mm@kvack.org, Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        kosaki.motohiro@gmail.com, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Return value of __mm_populate
References: <51694C2A.4050906@gmail.com>
In-Reply-To: <51694C2A.4050906@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/13/13 5:14 AM), Marco Stornelli wrote:
> Hi,
> 
> I was seeing the code of __mm_populate (in -next) and I've got a doubt 
> about the return value. The function __mlock_posix_error_return should 
> return a proper error for mlock, converting the return value from 
> __get_user_pages. It checks for EFAULT and ENOMEM. Actually 
> __get_user_pages could return, in addition, ERESTARTSYS and EHWPOISON. 

__get_user_pages doesn't return EHWPOISON if FOLL_HWPOISON is not specified.
I'm not expert ERESTARTSYS. I understand correctly, ERESTARTSYS is only returned
when signal received, and signal handling routine (e.g. do_signal) modify EIP and
hidden ERESTARTSYS from userland generically.


> So it seems to me that we could return to user space not expected value. 
> I can't see them on the man page. In addition we shouldn't ever return 
> ERESTARTSYS to the user space but EINTR. According to the man pages 
> maybe we should return EAGAIN in these cases. Am I missing something?


