Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab3K0IUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 03:20:49 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:65318 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3K0IUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 03:20:48 -0500
X-AuditID: 9c93017d-b7b24ae000002834-03-5295ab5fc29e
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt\@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: modules, add_kallsyms() && DEFINE_PER_CPU
References: <20131123201543.GA22148@redhat.com>
	<20131125172106.GA14516@redhat.com>
	<20131125172206.GD14516@redhat.com> <52946B42.40603@hitachi.com>
	<20131126174355.GB14028@redhat.com>
	<20131126174446.GD14028@redhat.com>
	<20131126175037.GE14028@redhat.com> <529557AF.8040501@hitachi.com>
Date: Wed, 27 Nov 2013 17:20:47 +0900
In-Reply-To: <529557AF.8040501@hitachi.com> (Masami Hiramatsu's message of
	"Wed, 27 Nov 2013 11:23:43 +0900")
Message-ID: <87r4a2qmqo.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Wed, 27 Nov 2013 11:23:43 +0900, Masami Hiramatsu wrote:
> (2013/11/27 2:50), Oleg Nesterov wrote:
>> On 11/26, Oleg Nesterov wrote:
>>>
>>> Note: this doesn't work for modules, but module's per-cpu data is
>>> not visible for kallsyms_lookup_name() anyway.
>> 
>> Rusty, I am just curious if it makes sense to change this or not...
>> 
>> But DEFINE_PER_CPU'ed symbols are ignored by add_kallsyms(). I guess
>> this is because is_core_symbol() requires "sh_flags & SHF_ALLOC".
>> And probably because of INIT_OFFSET_MASK.
>
> Oleg, I think you can do it by using is_module_percpu_address(). :)

It seems the function only works for a translated address like
is_kernel_percpu_address() does.  But we want to check a not-yet-
translated symbol address, right?

Thanks,
Namhyung
