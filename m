Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab3EVPDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 11:03:47 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:50773 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756306Ab3EVPDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 11:03:45 -0400
Date: Wed, 22 May 2013 11:03:35 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tejun Heo <tj@kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Message-ID: <20130522150335.GC2777@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Paolo Bonzini <pbonzini@redhat.com>, Tejun Heo <tj@kernel.org>,
	"James E.J. Bottomley" <JBottomley@parallels.com>,
	Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
 <519C674A.50700@redhat.com>
 <20130522093249.GC3466@mtj.dyndns.org>
 <519C959A.3090100@redhat.com>
 <20130522100212.GE3466@mtj.dyndns.org>
 <519C9CBC.3050003@redhat.com>
 <20130522134134.GA15189@mtj.dyndns.org>
 <519CD234.40608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519CD234.40608@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo,

I'll probably regret butting my head into this, but it might be
helpful if you talk about your particular use case which is driving
your desire to make these changes.  For example, what do you think the
SG_IO whitelist _should_ be used, and why should it be made more
general?  What's the use case that is being impaired by the current
state of how sg_io whitelists are being handled?

Secondly, when you are trying to get a security vulnerability fixed,
it's helpful if you give the precise nature of the problem, and what
the an attacker can do with it.  I think you are worried that if an
attacker has read-only access, they can still send the UNMAP command
which may (since it is advisory) result in a block no longer
containing valid data, such that a read will return zero's or some
other undefined garbage.   Yes?

Now consider that if this is a high-priority fix, it's important to
make the patch as small as possible, since distributions (like your
employer) may want to backport the patch to older kernels.  And
distribution release engineers will appreciate things if the patch is
as small as possible, making the _minimum_ necessary changes to fix
said security exposure.  Generally, a series of 14 patches is __not__
the minimum necessary patch.

Finally, please consider that your attitude is not going to win
friends and influence people.  I don't know if the capability to work
well with upstream developers (people which ***other*** Red Hat
engineers have had no problems work with, and which I can attest,
through personal experience, are very reasonable engineers who are
easy to work with), is something which is a part of your performance
review process.  But if it isn't, it probably should be, since the
ability to listen to review feedback is going to be important for your
long term career prospects, no matter whether it is with the Linux
kernel, some other open source project, or even a proprietary softare
project.

Regards,

					- Ted
