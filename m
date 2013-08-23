Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab3HWKBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 06:01:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab3HWKBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 06:01:39 -0400
Date: Fri, 23 Aug 2013 06:01:35 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        Joe Jin <joe.jin@oracle.com>, Mikulas Patocka <mpatocka@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>
Subject: Re: dm: allow error target to replace either bio-based and
 request-based targets
Message-ID: <20130823100135.GA29137@redhat.com>
References: <5214CC25.1070307@oracle.com>
 <alpine.LRH.2.02.1308211041180.10797@file01.intranet.prod.int.rdu2.redhat.com>
 <52157C6E.6080406@oracle.com>
 <20130822201900.GB22556@redhat.com>
 <20130823001750.GA29366@redhat.com>
 <5216D3A2.8020209@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5216D3A2.8020209@ce.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22 2013 at 11:14pm -0400,
Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> Hello Mike,
> 
> On 08/23/13 09:17, Mike Snitzer wrote:
> >> I do like the idea of a single error target that is hybrid (supports
> >> both bio-based and request-based) but the DM core would need to be
> >> updated to support this.
> >>
> >> Specifically, we'd need to check if the device (and active table) is
> >> already bio-based or request-based and select the appropriate type.  If
> >> it is a new device, default to selecting bio-based.
> >>
> >> There are some wrappers and other logic thoughout DM core that will need
> >> auditing too.
> > 
> > Here is a patch that should work for your needs (I tested it to work
> > with 'dmsetup wipe_table' on both request-based and bio-based devices):
> 
> How about moving the default handling in dm_table_set_type() outside of
> the for-each-target loop, like the modified patch below?
> 
> For example, if a table has 2 targets, hybrid and request_based,
> and live_md_type is DM_TYPE_NONE, the table should be considered as
> request_based, not inconsistent.
> Though the end result is same as such a table is rejected by other
> constraint anyway, I think it's good to keep the semantics clean
> and error messages consistent.
> 
> I.e. for the above case, the error message should be
> "Request-based dm doesn't support multiple targets yet",
> not "Inconsistent table: different target types can't be mixed up".

Hi,

Looks good, I'll fold your changes in and add your Signed-off-by.

Thanks,
Mike
