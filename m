Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbaGDBA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 21:00:59 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:55857 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbaGDBA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 21:00:58 -0400
Message-ID: <53B5FCC3.8010303@hitachi.com>
Date: Fri, 04 Jul 2014 10:00:51 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: probe_event_disable()->synchronize_sched()
References: <20140627170116.GA18298@redhat.com> <20140627170136.GA18319@redhat.com> <87k37z54lu.fsf@sejong.aot.lge.com> <20140630184828.GA24594@redhat.com> <20140701193147.GA32492@redhat.com> <53B4EE21.2040203@hitachi.com> <87lhsa51kg.fsf@sejong.aot.lge.com>
In-Reply-To: <87lhsa51kg.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/03 16:44), Namhyung Kim wrote:
> Hi Masami,
> 
> On Thu, 03 Jul 2014 14:46:09 +0900, Masami Hiramatsu wrote:
>> One possible scenario is here; someone disables an event and tries to remove
>> it (both will be done by different syscalls). If we don't synchronize
>> the first disabling, the event flag set disabled, but the event itself
>> is not disabled. Thus event handler is still possible to be running
>> somewhere when it is removed.
> 
> But, IIUC both of disable and remove path are protected by event_mutex.
> So one cannot see the case of disabled event flag but enabled event, no?

No, the flag is not protect the trace event handler itself.
I meant that running handlers and the flag was not synchronized.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


