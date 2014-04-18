Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbaDRRK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:10:29 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:48014 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaDRRK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:10:26 -0400
Date: Fri, 18 Apr 2014 13:10:22 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Andreas Gruenbacher <agruen@linbit.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH 1/8] idr: fix overflow bug for the max-high layer
Message-ID: <20140418171022.GB23576@htj.dyndns.org>
References: <1397825404-12039-1-git-send-email-laijs@cn.fujitsu.com>
 <1397825404-12039-2-git-send-email-laijs@cn.fujitsu.com>
 <20140418162930.GC12515@htj.dyndns.org>
 <CACvQF52ArOfCNw6b4YdUrb-Uwhj=BDw_Quaj7ou9TmT+psei0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF52ArOfCNw6b4YdUrb-Uwhj=BDw_Quaj7ou9TmT+psei0A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2014 at 01:08:46AM +0800, Lai Jiangshan wrote:
> On Sat, Apr 19, 2014 at 12:29 AM, Tejun Heo <tj@kernel.org> wrote:
> > Hello,
> 
> Hi,
> 
> Should I resend the patch with your updated changelog?
> Or something else I need to do?

Yeah, please resend with the description updated.

> >> static void test5(void)
> >> {
> >>       int id;
> >>       DEFINE_IDR(test_idr);
> >> #define TEST5_START ((1<<27)+42) /* use the highest layer */
> >>
> >>       printk(KERN_INFO "Start test5\n");
> >>       id = idr_alloc(&test_idr, (void *)1, TEST5_START, 0, GFP_KERNEL);
> >>       BUG_ON(id != TEST5_START);
> >>       TEST_BUG_ON(idr_replace(&test_idr, (void *)2, TEST5_START) != (void *)1);
> >>       idr_destroy(&test_idr);
> >>       printk(KERN_INFO "End of test5\n");
> >> }
> 
> Does the above testing code need to be kept in the changelog.

Yeah, why not?  It makes what's failing very clear.

Thanks.

-- 
tejun
