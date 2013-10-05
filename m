Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab3JEQId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 12:08:33 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:60103 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3JEQIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 12:08:32 -0400
MIME-Version: 1.0
In-Reply-To: <52503441.2030009@asianux.com>
References: <52502E14.5040507@asianux.com>
	<1380987671.2081.122.camel@joe-AO722>
	<52503441.2030009@asianux.com>
Date: Sat, 5 Oct 2013 18:08:31 +0200
Message-ID: <CAFLxGvy0+9tu5PF2kKrUyVRobixtLaSs_u_b9zwFj64YvQrxgw@mail.gmail.com>
Subject: Re: [PATCH] kernel/irq/proc.c: set MAX_NAMELEN 11 instead of 10 which
 express the maximize size of "%d" or "%u".
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Joe Perches <joe@perches.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 5, 2013 at 5:46 PM, Chen Gang <gang.chen@asianux.com> wrote:
> On 10/05/2013 11:41 PM, Joe Perches wrote:
>> On Sat, 2013-10-05 at 23:19 +0800, Chen Gang wrote:
>>> Theoretically, the maximize size of "%d" or "%u" is 11 (10 + '\0'), so
>>> need set MAX_NAMELEN 11 instead of 10.
>>
>> %d can be negative.
>>
>>
>>
>>
>
> Oh, really, it is incorrect. Al Viro succeeds once.  :-(
>
> And I should send patch v2 for it.

irq is in both register_irq_proc() and unregister_irq_proc() an unsigned int.
Therefore %d makes not really sense. Both should use %u.
IMHO sprintf() should also get replaced by snprintf() but that's a
matter of taste.

-- 
Thanks,
//richard
