Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965094Ab3DPRQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:16:43 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:62338 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965069Ab3DPRQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:16:42 -0400
MIME-Version: 1.0
In-Reply-To: <87mwszb4s6.fsf@sejong.aot.lge.com>
References: <CAOJsxLHv17Ys3M7P5q25imkUxQW6LE_vABxh1N3Tt7Mv6Ho4iw@mail.gmail.com>
	<87mwszb4s6.fsf@sejong.aot.lge.com>
Date: Tue, 16 Apr 2013 20:16:36 +0300
X-Google-Sender-Auth: lwSjtKzjYPqMS8BHUuhF-Xbf4-w
Message-ID: <CAOJsxLHc+dKyKWLqpe95Pi_18+pyPZROLz5irtg22qnB3s1doQ@mail.gmail.com>
Subject: Re: [PROBLEM] perf requires python-devel to compile
From: Pekka Enberg <penberg@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Michael Witten <mfwitten@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 16, 2013 at 5:14 AM, Namhyung Kim <namhyung@kernel.org> wrote:
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
>  endef
>  _ge_attempt = $(if $(get-executable),$(get-executable),$(_gea_warn)$(call _gea_err,$(2)))
>  _gea_warn = $(warning The path '$(1)' is not executable.)
> -_gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
> +_gea_err  = $(if $(1),$(warning Please set '$(1)' appropriately))
>
>  # try-cc
>  # Usage: option = $(call try-cc, source-to-build, cc-options, msg)

I considered this myself but I think this needs to fixed at a higher
level and keep the error out.

                        Pekka
