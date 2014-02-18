Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaBRELu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 23:11:50 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34020 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaBRELt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 23:11:49 -0500
X-AuditID: 85900ec0-d272ab9000001514-bb-5302dd820430
Message-ID: <5302DD81.7030409@hitachi.com>
Date: Tue, 18 Feb 2014 13:11:45 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH V2] serial/uart: Add tunable RX interrupt trigger I/F
 of FIFO buffers
References: <20140217044812.4868.28106.stgit@yunodevel> <20140217151222.3488abb6@alan.etchedpixels.co.uk>
In-Reply-To: <20140217151222.3488abb6@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Thank you for your reply.

(2014/02/18 0:12), One Thousand Gnomes wrote:
>> According to HW specification of serial UART devices, RX interrupt trigger
>> can be changed, but the trigger is hard-coded. For example, RX interrupt trigger
>> in 16550A can be set to 1, 4, 8, or 14 bytes for HW, but current driver sets
>> the trigger to only 8bytes.
>>
>> This patch makes a 16550A device change RX interrupt trigger from userland.
>
> We probably need to be much smarter about how we set this as lots of non
> 16550A type devices have a tunable trigger.
>
> We tune it dynamically based upon baud rate for many platforms, and we
> turn it on and off according to low latency settings. In other words we
> can't just have an ioctl poking values about in parallel and without any
> locking.

You're right. If a user sets low_latency using ioctl() on an 8250
device, serial8250_clear_fifos() initializing FCR will be executed.
So, my approach which does not get lock is inappropriate.

> For the API IMHO this really belongs in sysfs IMHO. That does mean we need
> to turn the existing sysfs API read/write by adding a few set methods not
> just get ones in drivers/tty/serial/ but it would be a lot cleaner and
> the uart_set_info path does the correct stopping and restarting as well
> as locking for the fifo size change.

As you say, sysfs is more convenient than ioctl for users. Moreover,
using uart_set_info() solves the competent problem. So, I'll
implement this feature in sysfs.

Thank you,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


