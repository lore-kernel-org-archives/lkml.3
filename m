Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaCXJEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 05:04:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:33826 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaCXJD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 05:03:59 -0400
To: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [patch 00/16] timers: Plug debugobject leaks and use  =?UTF-8?Q?del=5Ftimer=5Fsync=28=29=20in=20exit/teardown?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Mar 2014 10:03:57 +0100
From: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1403240828220.2211@localhost6.localdomain6>
References: <20140323150557.288925975@linutronix.de>
 <alpine.DEB.2.02.1403232328480.2019@localhost6.localdomain6>
 <alpine.DEB.2.02.1403240027020.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1403240828220.2211@localhost6.localdomain6>
Message-ID: <474c981bb41f7c1a23e600c858500461@www.linutronix.de>
User-Agent: html based client
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-24 08:29, Julia Lawall wrote:
>> Another thing I saw is
>>
>> 	del_timer(&bla->timer);
>> 	....
>> 	kfree(&bla);
>
> In one case I saw the following:
>
>         if (isac->dch.timer.function != NULL) {
>                 del_timer(&isac->dch.timer);
>                 isac->dch.timer.function = NULL;
>         }
>         kfree(isac->mon_rx);
>         isac->mon_rx = NULL;
>
> Is the assignment isac->dch.timer.function = NULL good enough to 
> solve
> the problem?

No. It might lead to a NULL dereference when the other core wants
to call the callback. Same situation as in the other picture.

Thanks,

        tglx

