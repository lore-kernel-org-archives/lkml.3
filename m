Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729Ab3GDHUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 03:20:20 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:64912 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933686Ab3GDHUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 03:20:18 -0400
X-AuditID: 9c93017e-b7c04ae00000295f-38-51d522304cd0
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Hyeoncheol Lee <cheol.lee@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCHSET 00/12] tracing/uprobes: Add support for more fetch methods
References: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
	<51D51B88.5000406@hitachi.com>
Date: Thu, 04 Jul 2013 16:20:15 +0900
In-Reply-To: <51D51B88.5000406@hitachi.com> (Masami Hiramatsu's message of
	"Thu, 04 Jul 2013 15:51:52 +0900")
Message-ID: <87txkazt8w.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Thu, 04 Jul 2013 15:51:52 +0900, Masami Hiramatsu wrote:
> (2013/07/03 21:35), Namhyung Kim wrote:
>> Hello,
>> 
>> This patchset implements memory (address), stack[N], deference,
>> bitfield and retval (it needs uretprobe tho) fetch methods for
>> uprobes.  It's based on the previous work [1] done by Hyeoncheol Lee.
>> 
>> Now kprobes and uprobes have their own fetch_type_tables and, in turn,
>> memory and stack access methods.  Other fetch methods are shared.
>> 
>> For the dereference method, I added a new argument to fetch functions.
>> It's because for uprobes it needs to know whether the given address is
>> a file offset or a virtual address in an user process.  For instance,
>> in case of fetching from a memory directly (like @offset) it should
>> convert the address (offset) to a virtual address of the process, but
>> if it's a dereferencing, the given address already has the virtual
>> address.
>
> Thanks Namhyung,
> I agree that uprobe requires a special (file-relative) dereference
> code. I'll look into the basic implementation after fixing current
> dynamic-event related bugs. :)
> (I see, this one should be updated to the latest tree, after
>  merge window is closed)

Yes, I'm catching up the changes.  I'll resend v2 after -rc1 released.

Thanks,
Namhyung
