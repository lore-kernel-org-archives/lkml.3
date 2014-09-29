Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbaI2SKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:10:07 -0400
Received: from mail.kernel.org ([198.145.19.201]:34178 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168AbaI2SKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:10:04 -0400
Date: Mon, 29 Sep 2014 15:09:59 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v4 1/2] perf tool: encapsulate dsos list head into struct
 dsos
Message-ID: <20140929180959.GG3879@kernel.org>
References: <1411573540-8765-1-git-send-email-Waiman.Long@hp.com>
 <1411573540-8765-2-git-send-email-Waiman.Long@hp.com>
 <20140926140625.GA3879@kernel.org>
 <87h9zrhyjr.fsf@sejong.aot.lge.com>
 <5429971F.9050405@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5429971F.9050405@hp.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 29, 2014 at 01:30:07PM -0400, Waiman Long escreveu:
> On 09/28/2014 11:54 PM, Namhyung Kim wrote:
> >On Fri, 26 Sep 2014 11:06:25 -0300, Arnaldo Carvalho de Melo wrote:
> >>Em Wed, Sep 24, 2014 at 11:45:39AM -0400, Waiman Long escreveu:
> >>>This is a precursor patch to enable long name searching of DSOs
> >>>using the rbtree. In this patch, a new dsos structure is created
> >>>which contains only a list head structure for the moment. The new
> >>>dsos structure is used, in turn, in the machine structure for the
> >>>user_dsos and kernel_dsos fields. Only the following 3 dsos functions
> >>>are modified to accept the new dsos structure parameter instead
> >>>of list_head:
> >>>  - dsos__add()
> >>>  - dsos__find()
> >>>  - __dsos__findnew()
> >>>
> >>>Because of the need to find out the corresponding dsos structure to
> >>>properly call dsos__add() in dso__load_sym() of util/symbol-elf.c,
> >>>a new dsos field is also added to the dso structure.
> >>Argh, yeah, that is unfortunate that we need to add entries that deep
> >>inside dso__load_syms() :-\
> >But it seems we can use map->groups->machine to find out the head/root
> >of the dsos..

> There are 2 dsos at the machine structure level - user_dsos and kernel_dsos.
> In this particular case, it should be kernel_dsos. I can remove the dsos
> pointer and hardcode it to use the kernel_dsos if you guys think it is
> acceptable.

Yes, I think that if we have already how to obtain the head/root where
we want to insert things from structures present at that point in the
code, no need to add it to the per-dso data structure.

Thanks to Namhyung for finding an existing way of getting to the needed
data structures.

- Arnaldo
