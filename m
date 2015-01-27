Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbbA0KGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:06:52 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:6215 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbbA0KGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:06:49 -0500
X-IronPort-AV: E=Sophos;i="5.09,473,1418083200"; 
   d="scan'208";a="221812956"
Message-ID: <54C76334.2080003@citrix.com>
Date: Tue, 27 Jan 2015 10:06:44 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: Andy Lutomirski <luto@amacapital.net>, <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, <paulmck@linux.vnet.ibm.com>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        <konrad.wilk@oracle.com>, Ingo Molnar <mingo@redhat.com>,
        Luis Rodriguez <Mcgrof@suse.com>, Borislav Petkov <bp@suse.de>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v5 2/2] x86/xen: allow privcmd hypercalls to be preempted
 on 64-bit
References: <1422323467-16713-1-git-send-email-mcgrof@do-not-panic.com> <1422323467-16713-3-git-send-email-mcgrof@do-not-panic.com> <54C75BD60200007800059BDD@mail.emea.novell.com>
In-Reply-To: <54C75BD60200007800059BDD@mail.emea.novell.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/01/15 08:35, Jan Beulich wrote:
>>>> On 27.01.15 at 02:51, <mcgrof@do-not-panic.com> wrote:
> 
> Even if David told you this would be acceptable, I have to question
> an abstract model of fixing issues on only 64-bit kernels - this may
> be acceptable for distro purposes, but seems hardly the right
> approach for upstream. If 32-bit ones are to become deliberately
> broken, the XEN config option should become dependent on !X86_32.

I'd rather have something omitted (keeping the current behaviour) than
something that has not been tested at all.

Obviously it would be preferable to to fix both 32-bit and 64-bit x86
(and ARM as well) but I'm not going to block an important bug fix for
the majority use case (64-bit x86).

David
