Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab3K0CXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:23:49 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56956 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab3K0CXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:23:47 -0500
Message-ID: <529557AF.8040501@hitachi.com>
Date: Wed, 27 Nov 2013 11:23:43 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: modules, add_kallsyms() && DEFINE_PER_CPU
References: <20131123201543.GA22148@redhat.com> <20131125172106.GA14516@redhat.com> <20131125172206.GD14516@redhat.com> <52946B42.40603@hitachi.com> <20131126174355.GB14028@redhat.com> <20131126174446.GD14028@redhat.com> <20131126175037.GE14028@redhat.com>
In-Reply-To: <20131126175037.GE14028@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/27 2:50), Oleg Nesterov wrote:
> On 11/26, Oleg Nesterov wrote:
>>
>> Note: this doesn't work for modules, but module's per-cpu data is
>> not visible for kallsyms_lookup_name() anyway.
> 
> Rusty, I am just curious if it makes sense to change this or not...
> 
> But DEFINE_PER_CPU'ed symbols are ignored by add_kallsyms(). I guess
> this is because is_core_symbol() requires "sh_flags & SHF_ALLOC".
> And probably because of INIT_OFFSET_MASK.

Oleg, I think you can do it by using is_module_percpu_address(). :)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


