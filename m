Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781Ab3CTMrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:47:17 -0400
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:53565 "EHLO
	mail.izyk.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496Ab3CTMrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:47:15 -0400
Message-ID: <5149AFD0.8020604@izyk.ru>
Date: Wed, 20 Mar 2013 16:47:12 +0400
From: Ilya Zykov <linux@izyk.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Min Zhang <mzhang@mvista.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/18] tty: Simplify tty buffer/ldisc interface with helper
 function
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>  <1363724513-15604-4-git-send-email-peter@hurleysoftware.com>  <5148E9D2.4030305@izyk.ru> <1363737036.3413.49.camel@thor.lan>
In-Reply-To: <1363737036.3413.49.camel@thor.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I have little question about flush_to_ldisc().
>> Does can it be multithreaded?
>>
>> I think yes, because on SMP schedule_work() can work on different CPU paralleled.
> 
> Yes, the same work item can now run in parallel on SMP since Tejun Heo
> re-did the workqueue implementation on 2.6.36 [Stefan Richter, the
> firewire maintainer, recently explained this history to me].

About multi threaded delayed works:

In many cases tty layer needs single threaded delayed work for each tty instance.
I propose discussion about create for this purpose (tty layer)'s workqueue with WQ_NON_REENTRANT flag.
And use it instead common schedule_work()'s workqueue - system_wq.
I don't know how expensive(for system resource and CPU) it can be,
but for tty layer, it can be very useful.

> 
>> What do you think about this race condition?
>> https://lkml.org/lkml/2011/11/7/98
> 
> Yes, that is a possible race condition that could lead to some nasty
> results. Good find.
> 
> If you want, I could bring that patch into this patchset or you could
> re-submit that patch to Greg and I could rebase this patchset on top of
> that.

Peter,
Please, do it anywhere you consider possible,
I can't do it myself now.

Thank you,
Ilya.

