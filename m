Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaI2DyE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 23:54:04 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:42360 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaI2DyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 23:54:03 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Waiman Long <Waiman.Long@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v4 1/2] perf tool: encapsulate dsos list head into struct dsos
References: <1411573540-8765-1-git-send-email-Waiman.Long@hp.com>
	<1411573540-8765-2-git-send-email-Waiman.Long@hp.com>
	<20140926140625.GA3879@kernel.org>
Date: Mon, 29 Sep 2014 12:54:00 +0900
In-Reply-To: <20140926140625.GA3879@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Fri, 26 Sep 2014 11:06:25 -0300")
Message-ID: <87h9zrhyjr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and Waiman,

On Fri, 26 Sep 2014 11:06:25 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Sep 24, 2014 at 11:45:39AM -0400, Waiman Long escreveu:
>> This is a precursor patch to enable long name searching of DSOs
>> using the rbtree. In this patch, a new dsos structure is created
>> which contains only a list head structure for the moment. The new
>> dsos structure is used, in turn, in the machine structure for the
>> user_dsos and kernel_dsos fields. Only the following 3 dsos functions
>> are modified to accept the new dsos structure parameter instead
>> of list_head:
>>  - dsos__add()
>>  - dsos__find()
>>  - __dsos__findnew()
>> 
>> Because of the need to find out the corresponding dsos structure to
>> properly call dsos__add() in dso__load_sym() of util/symbol-elf.c,
>> a new dsos field is also added to the dso structure.
>
> Argh, yeah, that is unfortunate that we need to add entries that deep
> inside dso__load_syms() :-\

But it seems we can use map->groups->machine to find out the head/root
of the dsos..

Thanks,
Namhyung
