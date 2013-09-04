Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935119Ab3IDOpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:45:22 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:48436 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934972Ab3IDOpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:45:17 -0400
Date: Wed, 4 Sep 2013 10:45:07 -0400
From: Tejun Heo <tj@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jan Kaluza <jkaluza@redhat.com>, davem@davemloft.net,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        eparis@redhat.com, rgb@redhat.com, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH v3 0/3] Send audit/procinfo/cgroup data in socket-level
 control message
Message-ID: <20130904144507.GA25788@mtj.dyndns.org>
References: <1377614400-27122-1-git-send-email-jkaluza@redhat.com>
 <1378275261-4553-1-git-send-email-jkaluza@redhat.com>
 <878uzdf2xp.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878uzdf2xp.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

On Wed, Sep 04, 2013 at 12:42:26AM -0700, Eric W. Biederman wrote:
> Can I just say ick, blech, barf, gag.

Gees, an awesome way to start the conversation.  If your gag response
is hyper-sensitive, go see a frigging doctor.  It's annoying because
you tend to go over the top while getting things wrong often enough.
Even if you don't agree, you don't have to start things this way.

> You don't require this information to be passed.  You are asking people
> to suport a lot of new code for the forseeable future.  The only advantage
> appears to be for short lived racy processes that don't even bother to
> make certain their message was acknowleged before exiting.

While I'm not sure whether this is *the* right appraoch, how is "we
have some pretty visible race conditions but it's probably okay" an
answer?  This affects auditing and logging directly and you're saying
"ah well, the program wasn't running long enough"?

> You sent this during the merge window which is the time for code
> integration and testing not new code.

What are you talking about?  It is *okay* to send new patches during
merge window even if it's headed for the next merge window.  Sending
patches to maintainers doesn't mean "this should go in right now".
Maintainers are of course free to delay response or ask for
pinging/resending later but it's just stupid to accuse patch
submitters for sending patches.  What the hell is that?

> By my count you have overflowed cb in struct sk_buff and are stomping on
> _skb_refdest.
> 
> If you are going to go crazy and pass things is there a reason you do
> not add a patch to pass the bsd SCM_CREDS?  That information seems more
> relevant in a security context and for making security decisions than
> about half the information you are passing.

You could have lost all the other paragraphs and just responded with
the above.  I don't think we can extend an existing struct but maybe
how information is packed can be adjusted.  That said, the proposed
split makes sense to me.

Thanks.

-- 
tejun
