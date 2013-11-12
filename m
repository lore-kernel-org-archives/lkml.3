Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab3KLJql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 04:46:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab3KLJqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 04:46:39 -0500
Date: Tue, 12 Nov 2013 10:46:28 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] tools lib traceevent: Add direct access to dynamic arrays
Message-ID: <20131112094628.GA1427@krava.brq.redhat.com>
References: <20131111160810.0ba9df7d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111160810.0ba9df7d@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 04:08:10PM -0500, Steven Rostedt wrote:
> 
> Jiri Olsa was writing a plugin for the cfg80211_tx_mlme_mgmt trace
> event, and was not able to get the implemented function working.
> The event's print fmt looks like:
> 
>    "netdev:%s(%d), ftype:0x%.2x", REC->name, REC->ifindex,
>             __le16_to_cpup((__le16 *)__get_dynamic_array(frame))
> 
> As there's no helper function for __le16_to_cpup(), Jiri was creating one
> with a plugin. But unfortunately, it would not work even though he set
> up the plugin correctly.
> 
> The problem is that the function parameters do not handle the helper
> function "__get_dynamic_array()", and that passes in a NULL pointer.
> 
> Adding PRINT_DYNAMIC_ARRAY direct support to eval_num_arg() allows the
> use of __get_dynamic_array() in function parameters.
> 
> Reported-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

cool, thanks

Tested-by: Jiri Olsa <jolsa@redhat.com>


jirka
