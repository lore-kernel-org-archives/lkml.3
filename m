Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaLCOT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:19:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbaLCOTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:19:25 -0500
Date: Wed, 3 Dec 2014 14:19:22 +0000
From: Joe Thornber <thornber@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: zhangxiao <xiao.zhang@windriver.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] The DM_BUFIO_HASH_BITS is defined as 20, any plan to
 make it flexible?
Message-ID: <20141203141921.GB6993@debian>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	zhangxiao <xiao.zhang@windriver.com>, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, agk@redhat.com
References: <547D7BC6.6070708@windriver.com>
 <20141202140015.GB5985@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141202140015.GB5985@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 09:00:17AM -0500, Mike Snitzer wrote:
> On Tue, Dec 02 2014 at  3:43am -0500,
> zhangxiao <xiao.zhang@windriver.com> wrote:
> 
> > Hi Experts,
> > 
> > See drivers/md/dm-bufio.c as below:
> >   50 /*
> >   51  * Buffer hash
> >   52  */
> >   53 #define DM_BUFIO_HASH_BITS      20
> >   54 #define DM_BUFIO_HASH(block) \
> >   55         ((((block) >> DM_BUFIO_HASH_BITS) ^ (block)) & \
> >   56          ((1 << DM_BUFIO_HASH_BITS) - 1))
> > "drivers/md/dm-bufio.c" 1854L, 45375C
> > 
> > DM_BUFIO_HASH_BITS was defined as 20 and it maybe not fit for some
> > use case with limited resources. Do we have any plan to make it more
> > flexible? Like module parameter or something else?
> 
> No immediate plans.

That hash table has been replaced with a red/black tree.

https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.19&id=4e420c452b11edf9d510c8180ac66f529e5b6206

