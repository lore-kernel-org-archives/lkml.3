Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaCYKam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 06:30:42 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:56429 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaCYKak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 06:30:40 -0400
Message-ID: <53315ACA.2070203@hitachi.com>
Date: Tue, 25 Mar 2014 19:30:34 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        fche@redhat.com, mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH -tip v8 19/26] kprobes: Show blacklist entries via debugfs
References: <20140305115843.22766.8355.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140305120056.22766.10704.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140324161909.5b8f854d@gandalf.local.home>
In-Reply-To: <20140324161909.5b8f854d@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/03/25 5:19), Steven Rostedt wrote:
> On Wed, 05 Mar 2014 21:00:56 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
> 
>>  kernel/kprobes.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++-------
>>  1 file changed, 53 insertions(+), 8 deletions(-)
>>
>> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
>> index a21b4e6..3214289 100644
>> --- a/kernel/kprobes.c
>> +++ b/kernel/kprobes.c
>> @@ -2249,6 +2249,46 @@ static const struct file_operations debugfs_kprobes_operations = {
>>  	.release        = seq_release,
>>  };
>>  
>> +/* kprobes/blacklist -- shows which functions can not be probed */
>> +static void *kprobe_blacklist_seq_start(struct seq_file *m, loff_t *pos)
>> +{
>> +	return seq_list_start(&kprobe_blacklist, *pos);
>> +}
>> +
>> +static void *kprobe_blacklist_seq_next(struct seq_file *m, void *v, loff_t *pos)
>> +{
>> +	return seq_list_next(v, &kprobe_blacklist, pos);
>> +}
>> +
> 
> Can modules use NOKPROBE_SYMBOL() and have items being added to the
> list as this is being read? That is, do we need locks?

At this point, no, the NOKPROBE_SYMBOL()s in module are just ignored.

> Also, are items removed. I need to go back and look at the
> implementation of NOKPROBE_SYMBOL(), I'm just writing this as I think
> about it ;-)

Actually, I've introduced a lock with module NOKPROBE_SYMBOL() support in
the next patch. :)
I'd like to split it because module blacklist support involves module
subsystem update.

Thank you!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


