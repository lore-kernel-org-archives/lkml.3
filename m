Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbaE2NFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:05:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048AbaE2NFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:05:20 -0400
From: Steve Grubb <sgrubb@redhat.com>
To: linux-audit@redhat.com
Cc: Andy Lutomirski <luto@amacapital.net>, Eric Paris <eparis@redhat.com>,
        "H. J. Lu" <hjl.tools@gmail.com>,
        "security@kernel.org" <security@kernel.org>,
        Philipp Kern <pkern@google.com>, Greg Kroah-Hartman <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH v2 2/2] audit: Mark CONFIG_AUDITSYSCALL BROKEN and update help text
Date: Thu, 29 May 2014 09:05:12 -0400
Message-ID: <127406715.ZrfKfg88o4@x2>
Organization: Red Hat
User-Agent: KMail/4.12.5 (Linux/3.14.4-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <CALCETrWr+_fo=q+LBT-WLJGXLWK6vEeFa=KC=LSMYehi=c-r4A@mail.gmail.com>
References: <cover.1401327752.git.luto@amacapital.net> <1401329367.13555.25.camel@localhost> <CALCETrWr+_fo=q+LBT-WLJGXLWK6vEeFa=KC=LSMYehi=c-r4A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 28, 2014 07:40:57 PM Andy Lutomirski wrote:
> >>  - It assumes that syscall numbers are between 0 and 2048.
> >>
> > There could well be a bug here.  Not questioning that.  Although that
> > would be patch 1/2
> 
> Even with patch 1, it still doesn't handle large syscall numbers -- it
> just assumes they're not audited.

All syscalls must be auditable. Meaning that if an arch goes above 2048, then 
we'll need to do some math to get it to fall back within the range.


> >>  - It's unclear whether it's supposed to be reliable.
> >>
> > Unclear to whom?
> 
> To me.
> 
> If some inode access or selinux rule triggers an audit, is the auditsc
> code guaranteed to write an exit record?  And see below...

It should or indicate that it could not.

-Steve
