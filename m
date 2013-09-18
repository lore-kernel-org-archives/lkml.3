Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab3IRNHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:07:45 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:38589 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3IRNHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:07:43 -0400
Date: Wed, 18 Sep 2013 10:07:35 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Waiman Long <Waiman.Long@hp.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Support for Openembedded/Yocto -dbg packages
Message-ID: <20130918130735.GC2240@ghostprotocols.net>
References: <1379493790-9554-1-git-send-email-ricardo.ribalda@gmail.com>
 <20130918092444.GA2778@gmail.com>
 <CAPybu_2GBymhgxHmtJu63pT2t8ge84EA9Ww54r9mGOA5KH7Hww@mail.gmail.com>
 <CAPybu_2Wf_p-jo2X4VzSBXrfy3DnHY4PeOvNVLfeoGRFfbDwRA@mail.gmail.com>
 <20130918101801.GO12926@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918101801.GO12926@twins.programming.kicks-ass.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 18, 2013 at 12:18:01PM +0200, Peter Zijlstra escreveu:
> On Wed, Sep 18, 2013 at 12:02:12PM +0200, Ricardo Ribalda Delgado wrote:
> > Perhaps this is even more clear than v2:

> > len = snprintf(file, size, "%s", symbol_conf.symfs);
> > size -= len;
> > file += len;
> > len = snprintf(file, MIN(size,(last_slash - dso->long_name) + 2),
> > "%s",  dso->long_name);
> > size -= len;
> > file += len;
> > len = snprintf(file, size, ".debug%s",  last_slash);

> len = 0;

> len += snprintf(str + len, size - len, ...);
> len += snprintf(str + len, size - len, ...);

And avoid snprintf like the plague, use scnprintf instead...  See
e7f01d1e3d8d501deb8abeaa269d5d48a703b8b0 for details :-)

- Arnaldo
