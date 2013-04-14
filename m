Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab3DNHdK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 03:33:10 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:43505 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab3DNHdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 03:33:08 -0400
Message-ID: <516A5A02.9090606@gmail.com>
Date: Sun, 14 Apr 2013 09:25:54 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: linux-mm@kvack.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Return value of __mm_populate
References: <51694C2A.4050906@gmail.com> <5169F5E7.3070100@gmail.com>
In-Reply-To: <5169F5E7.3070100@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Il 14/04/2013 02:18, KOSAKI Motohiro ha scritto:
> (4/13/13 5:14 AM), Marco Stornelli wrote:
>> Hi,
>>
>> I was seeing the code of __mm_populate (in -next) and I've got a doubt
>> about the return value. The function __mlock_posix_error_return should
>> return a proper error for mlock, converting the return value from
>> __get_user_pages. It checks for EFAULT and ENOMEM. Actually
>> __get_user_pages could return, in addition, ERESTARTSYS and EHWPOISON.
>
> __get_user_pages doesn't return EHWPOISON if FOLL_HWPOISON is not specified.
> I'm not expert ERESTARTSYS. I understand correctly, ERESTARTSYS is only returned
> when signal received, and signal handling routine (e.g. do_signal) modify EIP and
> hidden ERESTARTSYS from userland generically.
>

Yep, you're right, the "magic" is inside the signal management. Thanks!!

Marco
