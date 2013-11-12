Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab3KLMUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 07:20:33 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:63640 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab3KLMUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 07:20:31 -0500
MIME-Version: 1.0
In-Reply-To: <52821776.2000300@linux.com>
References: <CALeOzZ_K0o_h4gJ4w-twL5=-0QjC1XWb=m948wXWwjndr4q_Kw@mail.gmail.com>
	<20131110190633.GA18073@citd.de>
	<CALeOzZ_TpR7UxevNZET=ZFu8qL=646pWDwebNT6FH5Jvhv4-GA@mail.gmail.com>
	<20131111184447.GA24530@citd.de>
	<52821776.2000300@linux.com>
Date: Tue, 12 Nov 2013 13:20:29 +0100
Message-ID: <CALeOzZ-oG9zfi-uM5FtLVnLXEs3DgW6Sz4SCMsM_tnkqs348UQ@mail.gmail.com>
Subject: Re: Partially Privileged Applications
From: Shahbaz Youssefi <shabbyx@gmail.com>
To: levex@linux.com
Cc: Matthias Schniedermeyer <ms@citd.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the feedback. You are absolutely right and as I mentioned
before, I came to realize that it would be hard to contain malicious code.

Nevertheless, honest mistakes shouldn't be a big problem. Currently,
if you write a kernel module, you can cause havoc and the only thing
preventing you from inserting a bad module is a `sudo`. For the honest
people (regardless of noob or not), it would be the same. If you want
to run a privileged application, you need a `sudo` and the implications
are as good or as bad as inserting your own kernel module.

On Tue, Nov 12, 2013 at 12:56 PM, Levente Kurusa <levex@linux.com> wrote:
> 2013-11-11 19:44 keltezéssel, Matthias Schniedermeyer írta:
>> On 11.11.2013 14:05, Shahbaz Youssefi wrote:
>>> On Sun, Nov 10, 2013 at 8:06 PM, Matthias Schniedermeyer <ms@citd.de> wrote:
>>>> I don't see a way around "borders" (Papers please), otherwise you can't
>>>> reject things you don't want, you have to check if that something that
>>>> is to be done is allowed. For e.g. you would get around every
>>>> permission-check, because the code you called is allowed to do
>>>> everything.
>>>
>>> You're right actually. Proper linking solves the issue for "good people",
>>> but I can't think of a not-dirty way for preventing bad calls from
>>> "bad people". I may get back here if I do find a solution.
>
> Hi,
>
> What you describe in your blogpost already exists. It is called real-mode.
> Imagine yourself as a userspace developer. You make an application and want
> it to run as fast as possible and therefore you eliminate the mode-switches, which
> do cost a lot of time. Your only way to stop them is by leaving out .text section
> and only having the .privileged section.
>
> Also, think about the malicious software we had back in the DOS times. You caught one,
> your computer or atleast your harddrive died.
>
> Another problem is the bad developer, they want to test out their application, but they
> accidentally left out something. Just thinking about myself, I made lots of stupid mistakes
> when I began development, if the CPU worked per your description, I would have bricked bunch of
> computers. The whole point of separating kernelspace from userspace is not only the abstraction
> of hardware, but the security as well. We want to protect the user from having the fear of bricking
> his or her computer.
>
> By this, I don't mean to say that your idea is bad, but right now we can't just trust userspace
> with 'God' powers.
>
> --
> Regards,
> Levente Kurusa
