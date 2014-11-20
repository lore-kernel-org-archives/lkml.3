Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbaKTGcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 01:32:05 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59803 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaKTGcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 01:32:02 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: "Liang\, Kan" <kan.liang@intel.com>
Cc: "acme\@kernel.org" <acme@kernel.org>,
        "jolsa\@redhat.com" <jolsa@redhat.com>,
        "a.p.zijlstra\@chello.nl" <a.p.zijlstra@chello.nl>,
        "eranian\@google.com" <eranian@google.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        "paulus\@samba.org" <paulus@samba.org>,
        "ak\@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH V4 1/3] perf tools: enable LBR call stack support
References: <1416346617-3577-1-git-send-email-kan.liang@intel.com>
	<1416346617-3577-2-git-send-email-kan.liang@intel.com>
	<87r3wzpt4o.fsf@sejong.aot.lge.com>
	<37D7C6CF3E00A74B8858931C1DB2F07701671D25@SHSMSX103.ccr.corp.intel.com>
Date: Thu, 20 Nov 2014 15:32:00 +0900
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F07701671D25@SHSMSX103.ccr.corp.intel.com>
	(Kan Liang's message of "Wed, 19 Nov 2014 14:32:08 +0000")
Message-ID: <871toypelb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014 14:32:08 +0000, Kan Liang wrote:
>> On Tue, 18 Nov 2014 16:36:55 -0500, kan liang wrote:
>> > +			if (attr->exclude_user) {
>> > +				attr->exclude_user = 0;
>> > +
>> > +				pr_warning("LBR callstack option is only available"
>> > +					   " to get user callchain information."
>> > +					   " Force exclude_user to 0.\n");
>> > +			}
>> 
>> I'm not sure what's in a higher priority - maybe I missed earlier discussion.
>> IOW what about this?
>> 
>> 			if (attr->exclude_user) {
>> 				pr_warning("LBR callstack option is only available"
>> 					   " to get user callchain information.\n");
>
> I think either is fine. I'd like to add more info "Falling back to framepointers."
> based on your changes.
> So the user know what they will get then.
>
> What do you think?

Looks good to me.  But I still slightly prefer not to override user
settings.  But it's not a strong opinion though - I'd like to here from
others.

Thanks,
Namhyung


>
> pr_warning("LBR callstack option is only available"
> 	         " to get user callchain information."
> 	          " Falling back to framepointers.\n");
>
> pr_ warning ("Cannot use LBR callstack with branch stack"
>                 " Falling back to framepointers.\n");
