Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaEAVP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:15:57 -0400
Received: from one.firstfloor.org ([193.170.194.197]:58387 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbaEAVPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:15:55 -0400
Date: Thu, 1 May 2014 23:15:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/7] x86: Add support for rd/wr fs/gs base
Message-ID: <20140501211554.GH2382@two.firstfloor.org>
References: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
 <1398723161-21968-5-git-send-email-andi@firstfloor.org>
 <535FED4D.5000703@amacapital.net>
 <20140429233950.GE2382@two.firstfloor.org>
 <53608180.5070800@zytor.com>
 <CALCETrVQiZPb1M183Fq61dbFAjnJScuB2y+rdH8BQ+yp-MO+Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVQiZPb1M183Fq61dbFAjnJScuB2y+rdH8BQ+yp-MO+Mw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If usergs == kernelgs, then ebx will always be 1 and we'll never end
> up in paranoid_userspace.

You may miss a reschedule in this obscure case. It shouldn't really
happen because loading a kernel pointer is not useful for user space.

Doesn't seem like a real issue to me.

We only happen need to handle it to avoid crashing.

> Alternatively, what if the paranoid entry checked whether we're coming
> from userspace at the very beginning and, if so, just jumped to the
> non-paranoid entry?

That would work, but I doubt it would be worth it.

-Andi
