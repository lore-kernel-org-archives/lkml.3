Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380AbaE1WhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:37:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:5267 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932362AbaE1WhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:37:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,931,1392192000"; 
   d="scan'208";a="438279117"
Message-ID: <5386651D.9080001@linux.intel.com>
Date: Wed, 28 May 2014 15:37:17 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Philipp Kern <pkern@google.com>, Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. J. Lu" <hjl.tools@gmail.com>, Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] x32: Mask away the x32 syscall bit in the ptrace codepath
References: <1401279583-1027-1-git-send-email-pkern@google.com> <53864B66.8030100@amacapital.net> <53864E91.4060207@linux.intel.com> <CALCETrWd9dbBt03u5cpJx+p3D7NeT-d2_=kTg94CRGMq7ji7kQ@mail.gmail.com> <538652EA.3040606@linux.intel.com> <CALCETrWOOFhusn6MACs=o+TqqjQDXyTwVTe-iE_4bQcJu-ez=w@mail.gmail.com> <CAA2ZrUSzXUp=uipjwCDLsXPOhPwp7m1oSfR8zdKJaQCgg2aoeQ@mail.gmail.com>
In-Reply-To: <CAA2ZrUSzXUp=uipjwCDLsXPOhPwp7m1oSfR8zdKJaQCgg2aoeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 02:53 PM, Philipp Kern wrote:
> On Wed, May 28, 2014 at 11:43 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> However: are you sure that entry_64.S handles this?  It looks like
>> tracesys has higher priority than badsys.  And strace can certainly
>> see out-of-range syscalls. […]
> 
> Not only can it see them: It must see that this bit is set as that's
> the only identifier it has to deduce that the binary is running in x32
> mode.

Yes... keep in mind the ABI is a local property: just because the binary
is running in x32 mode doesn't mean it can't access x86-64 or i386
system calls (or similar for x86-64 processes.)  A process started in
i386 mode can transition to long mode and execute x86-64 or x32 system
calls, too.

	-hpa

