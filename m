Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab3KOL1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:27:45 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:49000 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab3KOL1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:27:38 -0500
Date: Fri, 15 Nov 2013 12:27:35 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] panic: setup panic_timeout early
Message-ID: <20131115112735.GA19004@gmail.com>
References: <1384180814-21823-1-git-send-email-felipe.contreras@gmail.com>
 <20131113000358.GA2420@gmail.com>
 <CAMP44s17p0ZpFx0Y2E_K7Oq9c4tk2J+9uXRWDYChAD-yM-4JjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s17p0ZpFx0Y2E_K7Oq9c4tk2J+9uXRWDYChAD-yM-4JjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Felipe Contreras <felipe.contreras@gmail.com> wrote:

> On Tue, Nov 12, 2013 at 6:03 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> >> +static int __init set_panic_timeout(char *val)
> >> +{
> >> +     long timeout;
> >> +     int ret;
> >> +
> >> +     ret = kstrtol(val, 0, &timeout);
> >> +     if (ret < 0)
> >> +             return ret;
> >> +
> >> +     panic_timeout = timeout;
> >> +     return 0;
> >> +}
> >
> > I think the type of the 'timeout' local variable should match the type of
> > 'panic_timeout' (which is 'int', not 'long').
> 
> So you would rather have this?
> 
>   kstrtol(val, 0, (long *)&timeout);
> 
> Couldn't that potentially write the value beyond the memory 
> allocated to 'timeout'?

No, casting that to 'long *' is actively wrong, I'd use a
string -> integer conversion method that deals with ints,
not longs, such as kstrtoint().

Thanks,

	Ingo
