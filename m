Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934589Ab3GSBRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 21:17:53 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58066 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab3GSBRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 21:17:51 -0400
Message-ID: <51E893BC.6070400@gmail.com>
Date: Thu, 18 Jul 2013 18:17:48 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: [RFC / musing] Scoped exception handling in Linux userspace?
References: <CALCETrVioVM=pdCU3WhU6qDtGQyqML=btBRZ5+aV6bASj9GkOQ@mail.gmail.com> <51E88AEF.8040701@gmail.com> <CALCETrXnVBPNGGTQQoXnpEmjXHxbhiWx+4RuMVQLRG5sfMpofA@mail.gmail.com>
In-Reply-To: <CALCETrXnVBPNGGTQQoXnpEmjXHxbhiWx+4RuMVQLRG5sfMpofA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 05:50 PM, Andy Lutomirski wrote:
> On Thu, Jul 18, 2013 at 5:40 PM, David Daney <ddaney.cavm@gmail.com> wrote:
>> On 07/18/2013 05:26 PM, Andy Lutomirski wrote:
>>>
>>> Windows has a feature that I've wanted on Linux forever: stack-based
>>> (i.e. scoped) exception handling.  The upshot is that you can do,
>>> roughly, this (pseudocode):
>>>
>>> int callback(...)
>>> {
>>>     /* Called if code_that_may_fault faults.  May return "unwind to
>>> landing pad", "propagate the fault", or "fixup and retry" */
>>> }
>>>
>>> void my_function()
>>> {
>>>     __hideous_try_thing(callback) {
>>>       code_that_may_fault();
>>>     } blahblahblah {
>>>       landing_pad_code();
>>>     }
>>> }
>>
>>
>> How is this different than throwing exceptions from a signal handler?
>
> Two ways.  First, exceptions thrown from a signal handler can't be
> retries.

??

> Second, and more importantly, installing a signal handler in
> a library is a terrible idea.

The signal handler would be installed by main() before calling into the 
library.  You have to have a small amount of boiler plate code to set it 
up, but the libraries wouldn't have to be modified if they were already 
exception safe.

FWIW the libgcj java runtime environment uses this strategy for handling 
NullPointerExceptions and DivideByZeroError(sp?).  Since all that code 
for the most part follows the standard C++ ABIs, it is an example of 
this technique that has been deployed in many environments.

David Daney

