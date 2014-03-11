Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbaCKUVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 16:21:52 -0400
Received: from one.firstfloor.org ([193.170.194.197]:50946 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755766AbaCKUVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 16:21:50 -0400
Date: Tue, 11 Mar 2014 21:21:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@redhat.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, eranian@google.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/8] perf, tools: Add --branch-history option to report
 v2
Message-ID: <20140311202149.GS22728@two.firstfloor.org>
References: <1393561352-23448-1-git-send-email-andi@firstfloor.org>
 <1393561352-23448-4-git-send-email-andi@firstfloor.org>
 <20140307131940.GB13974@krava.brq.redhat.com>
 <20140311003154.GP22728@two.firstfloor.org>
 <20140311152501.GB19393@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140311152501.GB19393@krava.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 04:25:02PM +0100, Jiri Olsa wrote:
> On Tue, Mar 11, 2014 at 01:31:54AM +0100, Andi Kleen wrote:
> > > this is *same* as parse_branch_mode function and seems to be not needed,
> > > I think both branch-stack and branch-history options could be handled
> > > by OPT_BOOLEAN
> > 
> > They can't because the type checker requires bool, and these variables
> > are tristate (UNSET, TRUE, FALSE)
> > 
> > -Andi
> 
> hum, I can see only 2 states there (please check patch below).. what do I miss?

-1 means undefined. Your patch changes things that the override would
happen even if the user explicitely set these options. It's not
equivalent.


-Andi
