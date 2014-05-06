Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbaEFNkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:40:16 -0400
Received: from mx02.posteo.de ([89.146.194.165]:58377 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756430AbaEFNkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:40:14 -0400
Message-ID: <5368E638.4070601@posteo.de>
Date: Tue, 06 May 2014 15:40:08 +0200
From: Martin Kepplinger <martink@posteo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        lidza.louina@gmail.com, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: dgnc: fix compile warning frame size is larger
 than 1024 bytes
References: <1399380097-11908-1-git-send-email-martink@posteo.de> <20140506133326.GU26890@mwanda>
In-Reply-To: <20140506133326.GU26890@mwanda>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-05-06 15:33, schrieb Dan Carpenter:
> On Tue, May 06, 2014 at 02:41:37PM +0200, Martin Kepplinger wrote:
>> fix following warning by dynamically allocating memory:
>> dgnc_tty.c:583:1: warning: the frame size of 1060 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>
>> Signed-off-by: Martin Kepplinger <martink@posteo.de>
>> ---
>> This is more of a question. Is this a desired solution to fixing such a
>> frame size warning?
> 
> This warning is because the kernel uses an 8k stack so you add up all
> the stack memory used by each function from the syscall to here.  If
> it adds up to more than 8k then it's a bug.  The 1k limit per function
> is just a hack to spot where people are maybe being reckless.

nice. thanks.

> 
> There are no kfree()s and this function is called with a spin_lock held
> so this patch introduces a couple bugs.

I know, it should have been just a question (probably to kernelnewbies'
list). Sorry for the noise.

> 
> There may be a better way to allocate this.  Like maybe at probe() and
> then use spinlocks to serialize access to the buffer.  But sometimes
> that's a very bad idea.
> 
> It's better if you know the driver a bit and can test things.
> 
> regards,
> dan carpenter
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

