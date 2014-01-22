Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbaAVB47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 20:56:59 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:34035 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbaAVB4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 20:56:55 -0500
MIME-Version: 1.0
In-Reply-To: <87ha8w50s9.fsf@rustcorp.com.au>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
 <1390339396-3479-32-git-send-email-paul.gortmaker@windriver.com> <87ha8w50s9.fsf@rustcorp.com.au>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 21 Jan 2014 20:56:24 -0500
X-Google-Sender-Auth: lmLEMuRe5eXRspOhppDqna06m64
Message-ID: <CAP=VYLrqs_EkpCZ5mhD3C+FygR7Ekg1Cp_2T4npxa0c9dj-C-g@mail.gmail.com>
Subject: Re: [PATCH 31/73] module: relocate module_init from init.h to module.h
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 7:16 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Paul Gortmaker <paul.gortmaker@windriver.com> writes:
>> Modular users will always be users of init functionality, but
>> users of init functionality are not necessarily always modules.
>>
>> Hence any functionality like module_init and module_exit would
>> be more at home in the module.h file.  And module.h should
>> explicitly include init.h to make the dependency clear.
>>
>> We've already done all the legwork needed to ensure that this
>> move does not cause any build regressions due to implicit
>> header file include assumptions about where module_init lives.
>>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
>
> Want to delete the extraneous semicolons, for bonus points? :)
>
>> +#define module_init(x)       __initcall(x);

I would if I could, but as I was discussing on irc with hpa about a
week ago, there are ~600 users of module_init who are relying on
that extra ";" that we need to fix 1st...  :-)    [on my todo list!]

Thanks for the review; much appreciated,
Paul.
--

> ...
>> +#define module_exit(x)       __exitcall(x);
>
> Cheers,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
