Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbaAQWwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 17:52:42 -0500
Received: from relay1.sgi.com ([192.48.179.29]:33275 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbaAQWwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 17:52:38 -0500
Date: Fri, 17 Jan 2014 16:52:50 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC PATCHv2 1/2] Add mm flag to control THP
Message-ID: <20140117225250.GA17626@sgi.com>
References: <1bc8f911363af956b37d8ea415d734f3191f1c78.1389905087.git.athorlton@sgi.com>
 <20140117200923.GA15234@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140117200923.GA15234@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 09:09:23PM +0100, Oleg Nesterov wrote:
> On 01/16, Alex Thorlton wrote:
> >
> > +	case PR_GET_THP_DISABLE:
> > +		error = put_user(test_bit(MMF_THP_DISABLE,
> > +				 &me->mm->flags),
> > +				 (int __user *) arg2);
> > +		break;
> 
> Do we really want put_user?
> 
> 	error = test_bit(MMF_THP_DISABLE);
> 
> can work too and looks simpler (and to me simpler to use in userspace).

That makes sense.  I'll change that; definitely easier to use from
userspace that way.

- Alex
