Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab3AUXLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 18:11:38 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:44682 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838Ab3AUXLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 18:11:36 -0500
Date: Mon, 21 Jan 2013 18:11:30 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>, mszeredi@suse.cz
Subject: Re: jbd2: don't wake kjournald unnecessarily
Message-ID: <20130121231130.GB12410@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Sedat Dilek <sedat.dilek@gmail.com>, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-next <linux-next@vger.kernel.org>, mszeredi@suse.cz
References: <CA+icZUWOvk5i+XY22xdZYuxu=Vy3fG2QxJStEgNFQVS4u55y-w@mail.gmail.com>
 <CA+icZUUzNYE9QAh_p7=ZNuvZbxRPCb9zd4k7+aW-hv34mQWz=A@mail.gmail.com>
 <20130121104733.GE5588@quack.suse.cz>
 <CA+icZUVy-=jJkRsEKmX+ZGRjiGr4wwp3pqdxuLCRHeqW_H0x9Q@mail.gmail.com>
 <CA+icZUVAP4ArN+j34GTUwMxte5DtLPJSrLmK9T6Na8Qy+aM0Rg@mail.gmail.com>
 <20130121140738.GI5588@quack.suse.cz>
 <CA+icZUXLcdnNPvA9o8d5msOQ0MkMci8mPXujLZ3zcYjYcVZ7JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUXLcdnNPvA9o8d5msOQ0MkMci8mPXujLZ3zcYjYcVZ7JQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 12:04:32AM +0100, Sedat Dilek wrote:
> 
> Beyond the FUSE/LOOP fun, will you apply this patch to your linux-next GIT tree?
> 
> Feel free to add...
> 
>      Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> 
> A similiar patch for JBD went through your tree into mainline (see [1] and [2]).

I'm not at all convinced that this patch has anything to do with your
problem.  I don't see how it could affect things, and I believe you
mentioned that you saw the problem even with this patch applied?  (I'm
not sure; some of your messages which you sent were hard to
understand, and you mentioned something about trying to send messages
when low on sleep :-).

In any case, the reason why I haven't pulled this patch into the ext4
tree is because I was waiting for Eric and some of the performance
team folks at Red Hat to supply some additional information about why
this commit was making a difference in performance for a particular
proprietary, closed source benchmark.

I'm very suspicious about applying patches under the "cargo cult"
school of programming.  ("We don't understand why it makes a
difference, but it seems to be good, so bombs away!" :-)

Regards,

					- Ted
