Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab3LMAZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 19:25:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab3LMAZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 19:25:47 -0500
Date: Thu, 12 Dec 2013 19:25:23 -0500
From: Dave Jones <davej@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, vegard.nossum@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>,
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
Message-ID: <20131213002523.GA20706@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Kees Cook <keescook@chromium.org>, Theodore Ts'o <tytso@mit.edu>,
	vegard.nossum@oracle.com, LKML <linux-kernel@vger.kernel.org>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Alan Cox <alan@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	James Morris <james.l.morris@oracle.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
 <20131212190659.GG13547@thunk.org>
 <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 01:13:41PM -0800, Kees Cook wrote:

 > - who will keep adding these triggers going forward?

also..

- Who will test the existing triggers are doing the right thing when related code changes.

We could add something to tests/ maybe for each exploit() addition, to make sure some
new change isn't introducing an oopsable (or worse!) bug in the actual exploit test.

It does mean someone needs to be regularly running said tests though.
As history has shown, things like nx_test have been broken for months at a time without
anyone complaining.  Perhaps Fenguang Wu can add something to the daily test runs if
we add an over all "make test-secure" target or similar.

	Dave

