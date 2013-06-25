Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab3FYTJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:09:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45907 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab3FYTJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 15:09:32 -0400
Message-ID: <51C9EADD.5000904@zytor.com>
Date: Tue, 25 Jun 2013 12:09:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>, Nathan Zimmer <nzimmer@sgi.com>,
        Robin Holt <holt@sgi.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <20130621165142.GA32125@kroah.com> <51C48745.9030304@zytor.com> <CAE9FiQX3Opcv0E7+PXNAUoJtgoa0Cxv5wOK=R_ERvQjN79poXQ@mail.gmail.com> <20130621185056.GA23473@kroah.com> <51C4C5F3.3050800@sgi.com> <CAE9FiQXaUNbK9+g-7j6gfvLrSvUJFWWKapDv658LPe4VfbH=tQ@mail.gmail.com> <51C9D4ED.5070805@sgi.com> <51C9DEC1.6030602@zytor.com> <CAE9FiQV5z+3AXy5c=aaU3vq1V3fibJ6PhhA4VW5H8BWVzhxXPA@mail.gmail.com> <51C9E523.7000803@zytor.com> <51C9E83A.8070700@sgi.com> <CAE9FiQUckP6m-HTdzdAJt0P_1bok-QHrxqm3RUTx=v_C=ufFCg@mail.gmail.com>
In-Reply-To: <CAE9FiQUckP6m-HTdzdAJt0P_1bok-QHrxqm3RUTx=v_C=ufFCg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 12:03 PM, Yinghai Lu wrote:
>> It is worth experimenting with but the big question would be,
>> if it still avoids the very expensive "memmap_init_zone" and
>> it's sub-functions using huge expanses of memory.  I'll do some
>> experimenting as soon as I can.  Our 32TB system is being
>> brought back to 16TB (we found a number of problems as we
>> get closer and closer to the 64TB limit), but that's still
>> a significant size.
> 
> According to Intel SDM, CPU could support 52bits physical addressing.
> 
> So how linux kernel will handle it? as we only have 48bits virtual addressing.
> 

The Linux kernel will not support more than V-2 bits of physical address
space for any number V of virtual address bits.

	-hpa


