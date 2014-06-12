Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552AbaFLG5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 02:57:50 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:39930 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbaFLG5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 02:57:49 -0400
Message-ID: <53994F67.9030106@hitachi.com>
Date: Thu, 12 Jun 2014 15:57:43 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: Re: [PATCH ftrace/core  2/2] ftrace, kprobes: Support IPMODIFY
 flag to find IP modify conflict
References: <20140610105001.8732.93502.stgit@kbuild-fedora.novalocal> <20140610105014.8732.43086.stgit@kbuild-fedora.novalocal> <1402408435.1676.13.camel@leonhard> <5397B0A1.7060401@hitachi.com> <87tx7rao6p.fsf@sejong.aot.lge.com> <53991E85.70109@hitachi.com> <871tuuad02.fsf@sejong.aot.lge.com>
In-Reply-To: <871tuuad02.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/12 14:54), Namhyung Kim wrote:
> On Thu, 12 Jun 2014 12:29:09 +0900, Masami Hiramatsu wrote:
>> NO, ftrace_lookup_ip() returns NULL if the hash is empty, so adding
>> !ftrace_hash_empty() is meaningless :)
>>
>> Actually, here I intended to have 3 meanings for the new/old_hash arguments,
>> - If it is NULL, it hits all
>> - If it is EMPTY_HASH, it hits nothing
>> - If it has some entries, it hits those entries.
>>
>> And in ftrace.c(__ftrace_hash_rec_update), AFAICS, ops->filter_hash has only
>> 2 meanings,
>> - If it is EMPTY_HASH or NULL, it hits all
>> - If it has some entries, it hits those entries.
> 
> Then I found an unrelated issue during review.
> 
> It seems that checking NULL other_hash for the 'all' case in
> __ftrace_hash_rec_update() is not sufficient.  It should check
> EMPTY_HASH case too, but then it ends up removing the check at all since
> it can be covered in ftrace_lookup_ip().

I guessed that was just for speeding up by skipping ftrace_lookup_ip().
(but I'm not sure how much it improves...)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

However, I'd like to ask Steven his Ack.

Thank you,

> 
> Thanks,
> Namhyung
> 
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 13885590a184..8bd7aa69a479 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1545,7 +1545,7 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
>  			 * Only the filter_hash affects all records.
>  			 * Update if the record is not in the notrace hash.
>  			 */
> -			if (!other_hash || !ftrace_lookup_ip(other_hash, rec->ip))
> +			if (!ftrace_lookup_ip(other_hash, rec->ip))
>  				match = 1;
>  		} else {
>  			in_hash = !!ftrace_lookup_ip(hash, rec->ip);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


