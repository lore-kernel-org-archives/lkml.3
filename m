Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965208Ab3DPUcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 16:32:18 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:49880 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965099Ab3DPUcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 16:32:17 -0400
Message-ID: <516DB548.7010703@gmail.com>
Date: Tue, 16 Apr 2013 13:32:08 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michael Witten <mfwitten@gmail.com>
CC: Pekka Enberg <penberg@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PROBLEM] perf requires python-devel to compile
References: <CAOJsxLHv17Ys3M7P5q25imkUxQW6LE_vABxh1N3Tt7Mv6Ho4iw@mail.gmail.com>            <87mwszb4s6.fsf@sejong.aot.lge.com>            <516CD300.6070201@gmail.com> <cd2c2e9aae554739b6bcd93513078f80-mfwitten@gmail.com>
In-Reply-To: <cd2c2e9aae554739b6bcd93513078f80-mfwitten@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/13 10:08 AM, Michael Witten wrote:
> You should probably disable python support more directly:
>
>    make NO_LIBPYTHON=1

sure, but I should not have to do anything. The intent of the existing 
auto-probing code is to figure out what is installed and build a binary 
with those capabilities. In this case not having python installed causes 
it to blow up.

>
> That being said, this issue was introduced with the following commit:
>
>    31160d7feab786c991780d7f0ce2755a469e0e5e
>
> namely due to:
>
>    ... Also fix an issue where _get_attempt was called with only
>    one argument. This prevented the error message from printing
>    the name of the variable that can be used to fix the problem.
>
> specifically:
>
>    -$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2)))
>    +$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2),$(1)))
>
> The "missing" argument was in fact missing on purpose; it's a signal
> that the error message should be skipped, because the failure was due
> to the default value, not the user-supplied value.
>
> That being said, I think there's room for improvement; for instance,
> the error handling should perhaps not belong there. I will look into
> it presently.

Thanks for the pointer. I'll take a look when I get some time.

David
