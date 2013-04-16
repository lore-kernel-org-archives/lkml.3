Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab3DPE0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 00:26:48 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:56495 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3DPE0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 00:26:47 -0400
Message-ID: <516CD300.6070201@gmail.com>
Date: Mon, 15 Apr 2013 21:26:40 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Michael Witten <mfwitten@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PROBLEM] perf requires python-devel to compile
References: <CAOJsxLHv17Ys3M7P5q25imkUxQW6LE_vABxh1N3Tt7Mv6Ho4iw@mail.gmail.com> <87mwszb4s6.fsf@sejong.aot.lge.com>
In-Reply-To: <87mwszb4s6.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/15/13 7:14 PM, Namhyung Kim wrote:
>> Makefile:755: The path '/usr/bin/python-config' is not executable.
>> Makefile:755: *** Please set 'PYTHON_CONFIG' appropriately.  Stop.
>>
>> The problem is that I didn't have python-devel package installed and
>> get-executable-or-default decides to error out instead of letting the
>> Makefile disable Python support.
>
> Right.  I think the get-executable-or-default should not error out in
> this case but just emit a warning and keep building.
>
> Does following patch fix your problem?
>
> -----------8<-------------8<-------------
> diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
> index 8ef3bd30a549..3b8036f8aca4 100644
> --- a/tools/perf/config/utilities.mak
> +++ b/tools/perf/config/utilities.mak
> @@ -177,7 +177,7 @@ $(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2),$(1)))
>   endef
>   _ge_attempt = $(if $(get-executable),$(get-executable),$(_gea_warn)$(call _gea_err,$(2)))
>   _gea_warn = $(warning The path '$(1)' is not executable.)
> -_gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
> +_gea_err  = $(if $(1),$(warning Please set '$(1)' appropriately))

In this case you don't want a warning, you just want python support 
disabled and move on. I've been getting around this in a minimal install 
of F18 in a VM using PYTHON_CONFIG=/bin/false; haven't had time to 
search for the proper solution.

David


