Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228Ab3CIBXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 20:23:34 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:60203 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab3CIBXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 20:23:33 -0500
Message-ID: <513A8F13.3070402@hitachi.com>
Date: Sat, 09 Mar 2013 10:23:31 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: oskar.andero@sonymobile.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "anil.s.keshavamurthy@intel.com" <anil.s.keshavamurthy@intel.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "Lekanovic, Radovan" <Radovan.Lekanovic@sonymobile.com>,
        =?ISO-8859-1?Q?=22Davidsson=2C_Bj=F6rn=22?= 
	<Bjorn.Davidsson@sonymobile.com>
Subject: Re: Re: [PATCH] Kprobes blacklist: Conditionally add x86-specific
 symbols
References: <1362653070-24035-1-git-send-email-oskar.andero@sonymobile.com> <513967BD.9010602@hitachi.com> <20130308131534.GI26148@caracas.corpusers.net>
In-Reply-To: <20130308131534.GI26148@caracas.corpusers.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/03/08 22:15), oskar.andero@sonymobile.com wrote:
> On 05:23 Fri 08 Mar     , Masami Hiramatsu wrote:
>> (2013/03/07 19:44), oskar.andero@sonymobile.com wrote:
>>> From: Bjorn Davidsson <bjorn.davidsson@sonymobile.com>
>>>
>>> The kprobes blacklist contains x86-specific symbols.
>>> Looking for these in kallsyms takes unnecessary time
>>> during startup on non-X86 platform.
>>> Added #ifdef CONFIG_X86 around them.
>>
>> Right. however, it might be better break that into
>> common and arch-specific lists, because there may be
>> other arch-specific non-probe-able functions on each
>> architecture...
> 
> Ok. You mean adding, for instance, a kprobe_blacklist_arch[] in arch/x86
> somewhere or did you have something else in mind? I guess we preferably want
> to get rid of the #ifdef.

Yes, we can have symbol tables (const char *arch_kprobes_blacksyms[],
common_kprobes_blacksyms[]) to list it up, and when initializing
the blacklist table, we can check whether kprobes_blacklist == NULL
and initialize it.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


