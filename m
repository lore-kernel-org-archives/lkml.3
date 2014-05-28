Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbaE1VxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:53:24 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:36527 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbaE1VxW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:53:22 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrWOOFhusn6MACs=o+TqqjQDXyTwVTe-iE_4bQcJu-ez=w@mail.gmail.com>
References: <1401279583-1027-1-git-send-email-pkern@google.com>
 <53864B66.8030100@amacapital.net> <53864E91.4060207@linux.intel.com>
 <CALCETrWd9dbBt03u5cpJx+p3D7NeT-d2_=kTg94CRGMq7ji7kQ@mail.gmail.com>
 <538652EA.3040606@linux.intel.com> <CALCETrWOOFhusn6MACs=o+TqqjQDXyTwVTe-iE_4bQcJu-ez=w@mail.gmail.com>
From: Philipp Kern <pkern@google.com>
Date: Wed, 28 May 2014 23:53:00 +0200
Message-ID: <CAA2ZrUSzXUp=uipjwCDLsXPOhPwp7m1oSfR8zdKJaQCgg2aoeQ@mail.gmail.com>
Subject: Re: [PATCH] x32: Mask away the x32 syscall bit in the ptrace codepath
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. J. Lu" <hjl.tools@gmail.com>, Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 11:43 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> However: are you sure that entry_64.S handles this?  It looks like
> tracesys has higher priority than badsys.  And strace can certainly
> see out-of-range syscalls. […]

Not only can it see them: It must see that this bit is set as that's
the only identifier it has to deduce that the binary is running in x32
mode.

Out of range syscall numbers certainly do not work for auditing right
now, hence my attempt to patch around it.

Kind regards and thanks
Philipp Kern
