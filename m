Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbaGCHoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:44:19 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:41301 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbaGCHoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:44:18 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei\(Jovi\)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt\@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: probe_event_disable()->synchronize_sched()
References: <20140627170116.GA18298@redhat.com>
	<20140627170136.GA18319@redhat.com>
	<87k37z54lu.fsf@sejong.aot.lge.com>
	<20140630184828.GA24594@redhat.com>
	<20140701193147.GA32492@redhat.com> <53B4EE21.2040203@hitachi.com>
Date: Thu, 03 Jul 2014 16:44:15 +0900
In-Reply-To: <53B4EE21.2040203@hitachi.com> (Masami Hiramatsu's message of
	"Thu, 03 Jul 2014 14:46:09 +0900")
Message-ID: <87lhsa51kg.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Thu, 03 Jul 2014 14:46:09 +0900, Masami Hiramatsu wrote:
> One possible scenario is here; someone disables an event and tries to remove
> it (both will be done by different syscalls). If we don't synchronize
> the first disabling, the event flag set disabled, but the event itself
> is not disabled. Thus event handler is still possible to be running
> somewhere when it is removed.

But, IIUC both of disable and remove path are protected by event_mutex.
So one cannot see the case of disabled event flag but enabled event, no?

Thanks,
Namhyung
