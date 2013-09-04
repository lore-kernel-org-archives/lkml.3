Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762866Ab3IDPUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:20:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163Ab3IDPUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:20:33 -0400
Date: Wed, 4 Sep 2013 11:20:22 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jan Kaluza <jkaluza@redhat.com>, davem@davemloft.net,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        eparis@redhat.com, tj@kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH v3 0/3] Send audit/procinfo/cgroup data in socket-level
 control message
Message-ID: <20130904152022.GD28517@madcap2.tricolour.ca>
References: <1377614400-27122-1-git-send-email-jkaluza@redhat.com>
 <1378275261-4553-1-git-send-email-jkaluza@redhat.com>
 <878uzdf2xp.fsf@xmission.com>
 <20130904145830.GC28517@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904145830.GC28517@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 10:58:30AM -0400, Richard Guy Briggs wrote:
> On Wed, Sep 04, 2013 at 12:42:26AM -0700, Eric W. Biederman wrote:
> > Jan Kaluza <jkaluza@redhat.com> writes:
> > > this patchset against net-next (applies also to linux-next) adds 3 new types
> > > of "Socket"-level control message (SCM_AUDIT, SCM_PROCINFO and SCM_CGROUP).
> 
> > By my count you have overflowed cb in struct sk_buff and are stomping on
> > _skb_refdest.
> 
> For patch1/3 I count 56/48, then for patch3 I get 48/48.  Jan, you might
> do the conversion to a pointer in patch1/3 to avoid bisect breakage.

Wait, that __aligned(8) is for cb[48], not for the contents.

For patch1/3 I count 28/48 on 32-bit, 36/48 on 64-bit (or would that be
56 by default on 64-bit arches without aligned specified?), then for
patch3 I get 24/48 on 32 and 40/48 on 64 (or again 48/48 by default?).

> > Eric
> 
> - RGB

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer
Kernel Security
AMER ENG Base Operating Systems
Remote, Ottawa, Canada
Voice: +1.647.777.2635
Internal: (81) 32635
Alt: +1.613.693.0684x3545
