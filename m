Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760421Ab3GSQWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:22:19 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37995 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab3GSQWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:22:17 -0400
Message-ID: <51E967B6.8010305@gmail.com>
Date: Fri, 19 Jul 2013 09:22:14 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: [RFC / musing] Scoped exception handling in Linux userspace?
References: <CALCETrVioVM=pdCU3WhU6qDtGQyqML=btBRZ5+aV6bASj9GkOQ@mail.gmail.com> <51E88AEF.8040701@gmail.com> <CALCETrXnVBPNGGTQQoXnpEmjXHxbhiWx+4RuMVQLRG5sfMpofA@mail.gmail.com> <51E893BC.6070400@gmail.com> <CALCETrX2vU0aWdVKjOPGkVt1OzLp96xw9=PNaM1XaTEU8Y-HXg@mail.gmail.com>
In-Reply-To: <CALCETrX2vU0aWdVKjOPGkVt1OzLp96xw9=PNaM1XaTEU8Y-HXg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 08:29 PM, Andy Lutomirski wrote:
> On Thu, Jul 18, 2013 at 6:17 PM, David Daney <ddaney.cavm@gmail.com> wrote:
>> On 07/18/2013 05:50 PM, Andy Lutomirski wrote:
>>>
>>> On Thu, Jul 18, 2013 at 5:40 PM, David Daney <ddaney.cavm@gmail.com>
>>> wrote:
>>>>
>>>> On 07/18/2013 05:26 PM, Andy Lutomirski wrote:
>>>>
>>>>
>>>> How is this different than throwing exceptions from a signal handler?
>>>
>>>
>>> Two ways.  First, exceptions thrown from a signal handler can't be
>>> retries.
>>
>>
>> ??
>
> s/retries/retried, by which I mean that you can't do things like
> implementing virtual memory in userspace by catching SIGSEGV, calling
> mmap, and resuming.
>
>>
>>
>>> Second, and more importantly, installing a signal handler in
>>> a library is a terrible idea.
>>
>>
>> The signal handler would be installed by main() before calling into the
>> library.  You have to have a small amount of boiler plate code to set it up,
>> but the libraries wouldn't have to be modified if they were already
>> exception safe.
>>
>> FWIW the libgcj java runtime environment uses this strategy for handling
>> NullPointerExceptions and DivideByZeroError(sp?).  Since all that code for
>> the most part follows the standard C++ ABIs, it is an example of this
>> technique that has been deployed in many environments.
>
> Other way around: a *library* that wants to use exception handling
> can't do so safely without the cooperation, or at least understanding,
> of the main program and every other library that wants to do something
> similar.  Suppose my library installs a SIGFPE handler and throws
> my_sigfpe_exception and your library installs a SIGFPE handler and
> throws your_sigfpe_exception.  The result: one wins and the other
> crashes due to an unhandled exception.
>
> In my particular usecase, I have code (known to the main program) that
> catches all kinds of fatal signals to log nice error messages before
> dying.  That means that I can't use a library that handles signals for
> any other purpose.  Right now I want to have a small snippet of code
> handle SIGBUS, but now I need to coordinate it with everything else.
>
> If this stuff were unified, then everything would just work.

That's right.  But I think the Linux kernel already supplies all the 
needed functionality to do this.  It is really a matter of choosing a 
userspace implementation and standardizing your entire system around it. 
  In the realm of GNU/GLibc/Linux, it is really more of social/political 
exercise rather than a technical problem.

David Daney

