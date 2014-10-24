Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbaJXJST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:18:19 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:57291 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbaJXJSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:18:16 -0400
MIME-Version: 1.0
In-Reply-To: <1414086028.5231.3.camel@marge.simpson.net>
References: <CAFxy--b+j86kn6Ttc+qTTi4chDkKbrmSAxEsS7_CnzuabJAZfQ@mail.gmail.com>
	<CAFxy--Z4FpWJbqr8OMoxgpMXa2WMSuCOA_pvtokcwcq6C-uaFg@mail.gmail.com>
	<1414086028.5231.3.camel@marge.simpson.net>
Date: Fri, 24 Oct 2014 14:48:14 +0530
Message-ID: <CAFxy--Zc+262_GzmxQTLkH4Z=G1xvqe8GWF6ov_hbd=ZKBwiQA@mail.gmail.com>
Subject: Re: threadirqs and kthreadd_task
From: ajay kanala <ajaykanala321@gmail.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks Mike for info.
I add mips list in CC now.

In general, the problem does not look like arch specific. Arch code is
calling setup_irq. This code calls generic  __setup_irq. And then
threads are created by this line in kernel/irq/manage.c:
t = kthread_create(irq_thread, new, "irq/%d-%s", irq,
                                   new->name);

and kthreadd_task is uninitialized till this point.

The code looks similar for x86_64 so i am missing something obvious.

Nevertheless, I am hoping someone from mips-list can throw some light
if this feature works well on mips.

Thanks
-- Ajay

On Thu, Oct 23, 2014 at 11:10 PM, Mike Galbraith
<umgwanakikbuti@gmail.com> wrote:
> On Thu, 2014-10-23 at 22:48 +0530, ajay kanala wrote:
>> Hi,
>> any help?
>
> You should CC the MIPS folks methinks, works fine in x86_64 at least.
>
> -Mike
>
>
>
