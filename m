Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaEBVok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 17:44:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:39719 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbaEBVoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 17:44:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,974,1389772800"; 
   d="scan'208";a="426964582"
Message-ID: <536411C1.4040209@intel.com>
Date: Fri, 02 May 2014 14:44:33 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC/HACK] x86: Fast return to kernel
References: <210a076ea197ae384705d2c02cfff12a951a62f8.1399057218.git.luto@amacapital.net> <CA+55aFzfDgeFmzk18xJ+ZvCcm-qCsCtd4RrNxYi0CXdfNbZn_A@mail.gmail.com> <CA+55aFygkoYnJKdLas3WOq9q9pCEEk6mBOuj-zbLyLumdhStAA@mail.gmail.com> <alpine.DEB.2.02.1405022222570.6261@ionos.tec.linutronix.de> <CA+55aFyZr3YrNm1+p4XstNx-NY71LMuP1GyTeqettSdR2CufqQ@mail.gmail.com> <CALCETrW+vAuUq834kjo7Ot8JYqDqAdOts78oasm0vPP1wURnWg@mail.gmail.com> <CA+55aFzQiryYPsUTK-yS_rt=MGtzJZBBrj3waGq6Ez3GUqfMnw@mail.gmail.com> <53641035.4040202@intel.com> <CALCETrXP7-mtpVhFmM0Cw0pxHs3JpU8uYNJzxi1Qx6=QXW_Vrg@mail.gmail.com>
In-Reply-To: <CALCETrXP7-mtpVhFmM0Cw0pxHs3JpU8uYNJzxi1Qx6=QXW_Vrg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 02:42 PM, Andy Lutomirski wrote:
> 
> Hah -- I think I just faked both of you out :)
> 
> I don't think this has anything to do with the error code, and I think
> that the errorentry code already does more or less that: it pushes -1.
> 
> The real issue here is probably the magic 16-byte stack alignment when
> a non-stack-switching interrupt happens.
> 

Errorentry is when there *is* an error code pushed by the hardware.  The
other variant is zeroentry, which does generate a zero error code --
eventually.  The -1 means we didn't enter the kernel through a system call.

	-hpa

