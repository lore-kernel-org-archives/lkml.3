Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab3G3B2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 21:28:21 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:48958 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3G3B2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 21:28:19 -0400
Message-ID: <51F716AF.1040206@hitachi.com>
Date: Tue, 30 Jul 2013 10:28:15 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] tracing: Change remove_event_file_dir() to clear
 "d_subdirs"->i_private
References: <20130726172551.GA3632@redhat.com> <51F6392C.8000806@hitachi.com> <20130729142158.GA9338@redhat.com>
In-Reply-To: <20130729142158.GA9338@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/29 23:21), Oleg Nesterov wrote:
> On 07/29, Masami Hiramatsu wrote:
>>
>> (2013/07/27 2:25), Oleg Nesterov wrote:
>>> Change remove_event_file_dir() to clear ->i_private for every
>>> file we are going to remove.
>>
>> Oleg, I think this should be done first.
>>
>> AFAICS, your former patches depend strongly on this change.
>> Without this, they don't work as you expected, and it may
>> prevent git-bisect.
> 
> Why?
> 
> v2 specially does this in the last change for bisecting/etc.
> 
> 1-4 change f_op->read/write to check i_private != NULL but until
> this final patch i_private == NULL is not possible.

Ah, OK. So 1-4 changes still remain refcount code, then
it is safe, just i_private != NULL are added. I misread.


>> I see, including this patch also breaks current ftrace.
> 
> Could you clarify?

Yes, let me add reviewed-by tags ;)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


