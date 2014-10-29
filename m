Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbaJ2UU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 16:20:29 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:42397 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111AbaJ2UU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 16:20:26 -0400
Message-ID: <1414614013.5330.90.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [GIT PULL] Fix for Integrity subsystem null pointer deref
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        James Morris <jmorris@namei.org>
Date: Wed, 29 Oct 2014 16:20:13 -0400
In-Reply-To: <CALCETrU1S94M1L-UM5Rg91J4kGjJRFLiPxce5aAnPPJVeitQ_A@mail.gmail.com>
References: <alpine.LRH.2.11.1410291450290.28213@namei.org>
	 <CALCETrUskFJY6hd9OCN_N1645VZ6zfwbGAuSEJNt6F_FPUi3gg@mail.gmail.com>
	 <1414587599.5330.50.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <CALCETrWpHXp=7u2777ANJjxQ5rRqmutnEwf76dLX2s_LXf87pQ@mail.gmail.com>
	 <20141029183612.GI6890@mwanda>
	 <CALCETrU1S94M1L-UM5Rg91J4kGjJRFLiPxce5aAnPPJVeitQ_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102920-0029-0000-0000-000005400450
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 11:51 -0700, Andy Lutomirski wrote: 
> On Wed, Oct 29, 2014 at 11:36 AM, Dan Carpenter
> <dan.carpenter@oracle.com> wrote:
> > On Wed, Oct 29, 2014 at 09:23:45AM -0700, Andy Lutomirski wrote:
> >> I have no idea what the semantics are.  All I'm saying is that it
> >> looks like the code still accesses memory past the end of the buffer.
> >> The buffer isn't a null pointer, so the symptom is different, but it
> >> may still be a security bug.
> >>
> >> --Andy
> >
> > It only reads one byte into the struct "xattr_data->type" so checking
> > for non-zero is sufficient and the patch is fine.
> 
> Indeed.  Still... eww.  I don't like code that, upon local inspection,
> is apparently wrong, even though it's coincidentally correct due to
> some other far away condition.

No, the code may be incomplete, but definitely not wrong.

Mimi

