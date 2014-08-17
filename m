Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaHQIoi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 04:44:38 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:42569 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaHQIog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 04:44:36 -0400
Message-ID: <53F06B6D.7050103@redhat.com>
Date: Sun, 17 Aug 2014 10:44:29 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, "Theodore Ts'o" <tytso@mit.edu>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Bandan Das <bsd@redhat.com>,
        Andrew Honig <ahonig@google.com>, KY Srinivasan <kys@microsoft.com>
Subject: Re: [PATCH v5 0/5] random,x86,kvm: Rework arch RNG seeds and get
 some from kvm
References: <cover.1406177531.git.luto@amacapital.net> <CALCETrXtLf3ZFtyrbwj29C=t3PcTxRT2AJWZCUHdKC3AYyUVAA@mail.gmail.com> <20140812191723.GI12871@thunk.org> <CALCETrVmviT=upxHfPfmLy2aUOKdCuCbNg9WZQcx6f=8T8vv=g@mail.gmail.com> <53EB1859.6030800@zytor.com> <20140813143209.GD6437@thunk.org> <CALCETrUQ8yRmmN1kbdCy99ae2+-Xp4caOBgrXvaQhCCUi=i0zg@mail.gmail.com> <53EBA435.3020207@zytor.com> <20140813182219.GE6437@thunk.org> <CALCETrVTsyq4u+G2Td7Gmi6pa6c1ePgavqN31mjo9_E5=7bGCg@mail.gmail.com>
In-Reply-To: <CALCETrVTsyq4u+G2Td7Gmi6pa6c1ePgavqN31mjo9_E5=7bGCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/08/2014 20:33, Andy Lutomirski ha scritto:
> As for doing arch_random_init after clone/migration, I think we'll
> need another KVM extension for that, since, AFAIK, we don't actually
> get notified that we were cloned or migrated.  That will be
> nontrivial.  Maybe we can figure that out at KS, too.

Migration doesn't need an arch_random_init, only cloning does.

MS has an ACPI-based specification for this they call the "VM Generation
ID", which QEMU should be implementing it sooner rather than later.  In
Linux we could add a generic notifier, and an x86 platform driver that
implements the VM Generation ID specification and invokes the notifier.

http://go.microsoft.com/fwlink/p/?LinkID=260709 (warning, .docx ahead)

KY, would you be interested in looking at this?

Paolo
