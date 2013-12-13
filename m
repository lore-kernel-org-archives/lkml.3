Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab3LMPzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:55:40 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23327 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab3LMPzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:55:35 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18aqW27ZlloVxMA0TNVzZwsKTa77aKFszM=
X-DKIM: OpenDKIM Filter v2.0.1 titan 449A64F1D12
Date: Fri, 13 Dec 2013 10:55:23 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ryan Mallon <rmallon@gmail.com>, Kees Cook <keescook@chromium.org>,
        "Theodore Ts'o" <tytso@mit.edu>, vegard.nossum@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
Message-ID: <20131213155523.GC2609@titan.lakedaemon.net>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
 <20131212190659.GG13547@thunk.org>
 <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
 <52AA4BC8.1080207@gmail.com>
 <20131213130648.GA10870@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213130648.GA10870@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 02:06:48PM +0100, Ingo Molnar wrote:
...
> In future the exploit() code could trigger actual active defensive 
> measures, such as immediately freezing all tasks of that UID and 
> blocking further fork()s/exec()s of that UID.
> 
> Depending on how critical the security of the system is, such active 
> measures might still be a preferable outcome even if there's a chance 
> of false positives. (Such active measures that freeze the UID will 
> also help with forensics, if the attack is indeed real.)

I would recommend adding the CVSS score or some other quantifiable
attribute to the exploit() call, eg:

	exploit("CVE-2011-4330", 72);

Or, optionally, maintaining a lut of CVE -> severity number.  Then the
user can decide how to respond to different levels of exploits.

So, >80 freezes all tasks of the UID, email user
    >30, <80 emails user
    <30 just logs it.

I'm swagging this, my point is the user needs a concrete, configurable
way to be alerted / respond.

thx,

Jason.
