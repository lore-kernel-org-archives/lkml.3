Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaHOT1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:27:16 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:44199 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaHOT1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:27:14 -0400
MIME-Version: 1.0
In-Reply-To: <87ha1d8u6o.fsf@rustcorp.com.au>
References: <8c275067bad7333e82cb80c993ce23216f41002e.1408065737.git.luto@amacapital.net>
 <87ha1d8u6o.fsf@rustcorp.com.au>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 15 Aug 2014 12:26:52 -0700
Message-ID: <CALCETrUxfxNv5E1=Fo8TGEwBeb=7Xz6ZcZHKouon=wh5iMuScw@mail.gmail.com>
Subject: Re: [PATCH] module: Clean up ro/nx after early module load failures
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 11:49 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>> The commit
>>
>>     4982223e51e8 module: set nx before marking module MODULE_STATE_COMING.
>>
>> introduced a regression: if a module fails to parse its arguments or
>> if mod_sysfs_setup fails, then the module's memory will be freed
>> while still read-only.  Anything that reuses that memory will crash
>> as soon as it tries to write to it.
>
> Thanks, good catch.

Catching it was easy.  Figuring out wtf was happening to my poor
computer, on the other hand... :)

>
> Applied,
> Rusty.



-- 
Andy Lutomirski
AMA Capital Management, LLC
