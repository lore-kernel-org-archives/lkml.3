Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab3LMBkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 20:40:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab3LMBka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 20:40:30 -0500
Date: Thu, 12 Dec 2013 17:42:20 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>,
        "Theodore Ts'o" <tytso@mit.edu>, vegard.nossum@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
Message-ID: <20131213014220.GB11068@kroah.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
 <20131212190659.GG13547@thunk.org>
 <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
 <20131213002523.GA20706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131213002523.GA20706@redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 07:25:23PM -0500, Dave Jones wrote:
> On Thu, Dec 12, 2013 at 01:13:41PM -0800, Kees Cook wrote:
> 
>  > - who will keep adding these triggers going forward?
> 
> also..
> 
> - Who will test the existing triggers are doing the right thing when related code changes.

And:
  - how do you determine an "expoit attempt" from "userspace program
    doing something stupid" / "corrupted filesytem mounted"?

I really don't like this, it means that our normal error handling for
userspace data will suddenly all have CVE entries on them over time.
How is that helpful to anyone?

Think ahead in 10-20 years, what is the code paths going to look like
then?  Horrible...

greg k-h
