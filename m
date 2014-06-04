Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbaFDVUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:20:20 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:33012 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaFDVUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:20:18 -0400
MIME-Version: 1.0
In-Reply-To: <538E7C20.2060407@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
	<1401833185-10347-8-git-send-email-alexis.berlemont@gmail.com>
	<538E7C20.2060407@gmail.com>
Date: Wed, 4 Jun 2014 23:20:17 +0200
Message-ID: <CAMesUR48d0U86m_Kzsy4HES68KCaLJg8s+i+aoB=hBE-rP9z4A@mail.gmail.com>
Subject: Re: [PATCH 07/32] perf kbuild: remove useless #ifdef directives
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, sam@ravnborg.org,
        Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 3:53 AM, David Ahern <dsahern@gmail.com> wrote:
> missing commit message as to why the ifdef directives useless.
>

If I remember well, after having rebased Jiri Olsa's patches on the
current branch. The build procedure was not working correctly. So, the
first commits tried to fix the issues. The ifdef directives were no
more needed because they were moved elsewhere in more recent versions
(I think Jiri Olsa's patches were released in April 2013)

I now understand that these changes should have been integrated into
jiri's rebased commits. I will fix that.

> if I build perf after applying this patch and I don't have devel code for
> tui and gui will it still build?
>

Sidenote: after having applied _all_ the patches. If you build perf
and you don't have the tui / gui devel code, the absence of headers
will be detected by features test
(linux/tools/perf/config/features-checks/*) and the .config will be
updated accordingly. So, at build time, it should be ok. By the way, I
updated the non-regression procedure (available through the target
build-test); many .config files were automatically generated in
linux/tools/perf/tests/configs thanks a python script (which relies on
kconfiglib):
* for each option, there is a .config file in which the option is disabled
* a minimal .config file (nearly everything disabled) and a defconfig
/ allyesconfig file are  also tested.

Alexis.

> David
>
>
> On 6/3/14, 4:06 PM, Alexis Berlemont wrote:
>>
>> ---
>>   tools/perf/ui/setup.c | 8 --------
>>   1 file changed, 8 deletions(-)
>>
>> diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
>> index 66ecd08..cb69740 100644
>> --- a/tools/perf/ui/setup.c
>> +++ b/tools/perf/ui/setup.c
>> @@ -71,20 +71,16 @@ void setup_browser(bool fallback_to_pager)
>>
>>         switch (use_browser) {
>>         case 2:
>> -#if defined(CONFIG_GUI) || !defined(CONFIG_KBUILD)
>>                 if (setup_gtk_browser() == 0)
>>                         break;
>>                 printf("GTK browser requested but could not find %s\n",
>>                        PERF_GTK_DSO);
>>                 sleep(1);
>> -#endif
>>                 /* fall through */
>> -#if defined(CONFIG_TUI) || !defined(CONFIG_KBUILD)
>>         case 1:
>>                 use_browser = 1;
>>                 if (ui__init() == 0)
>>                         break;
>> -#endif
>>                 /* fall through */
>>         default:
>>                 use_browser = 0;
>> @@ -100,16 +96,12 @@ void exit_browser(bool wait_for_ok __maybe_unused)
>>   {
>>         switch (use_browser) {
>>         case 2:
>> -#if defined(CONFIG_GUI) || !defined(CONFIG_KBUILD)
>>                 exit_gtk_browser(wait_for_ok);
>>                 break;
>> -#endif
>>
>> -#if defined(CONFIG_TUI) || !defined(CONFIG_KBUILD)
>>         case 1:
>>                 ui__exit(wait_for_ok);
>>                 break;
>> -#endif
>>
>>         default:
>>                 break;
>>
>
