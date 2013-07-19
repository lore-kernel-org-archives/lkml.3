Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934918Ab3GSAul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 20:50:41 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:38200 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933632Ab3GSAuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 20:50:40 -0400
MIME-Version: 1.0
In-Reply-To: <51E88AEF.8040701@gmail.com>
References: <CALCETrVioVM=pdCU3WhU6qDtGQyqML=btBRZ5+aV6bASj9GkOQ@mail.gmail.com>
 <51E88AEF.8040701@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 18 Jul 2013 17:50:19 -0700
Message-ID: <CALCETrXnVBPNGGTQQoXnpEmjXHxbhiWx+4RuMVQLRG5sfMpofA@mail.gmail.com>
Subject: Re: [RFC / musing] Scoped exception handling in Linux userspace?
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 5:40 PM, David Daney <ddaney.cavm@gmail.com> wrote:
> On 07/18/2013 05:26 PM, Andy Lutomirski wrote:
>>
>> Windows has a feature that I've wanted on Linux forever: stack-based
>> (i.e. scoped) exception handling.  The upshot is that you can do,
>> roughly, this (pseudocode):
>>
>> int callback(...)
>> {
>>    /* Called if code_that_may_fault faults.  May return "unwind to
>> landing pad", "propagate the fault", or "fixup and retry" */
>> }
>>
>> void my_function()
>> {
>>    __hideous_try_thing(callback) {
>>      code_that_may_fault();
>>    } blahblahblah {
>>      landing_pad_code();
>>    }
>> }
>
>
> How is this different than throwing exceptions from a signal handler?

Two ways.  First, exceptions thrown from a signal handler can't be
retries.  Second, and more importantly, installing a signal handler in
a library is a terrible idea.

--Andy
