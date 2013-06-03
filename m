Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420Ab3FCQ7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:59:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759128Ab3FCQ66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:58:58 -0400
Message-ID: <51ACCB43.50803@redhat.com>
Date: Mon, 03 Jun 2013 18:58:43 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi.kivity@gmail.com>, kvm <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: fix sil/dil/bpl/spl in the mod/rm fields
References: <1369924555-30216-1-git-send-email-pbonzini@redhat.com> <51A7717D.6030203@redhat.com> <51A77FA8.6010007@redhat.com> <CAEbWaiqg765n5jSz7+8_O-44j5NoTMhKVnN-ev7daSHBoR6Tiw@mail.gmail.com> <20130603164057.GQ24773@redhat.com>
In-Reply-To: <20130603164057.GQ24773@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/06/2013 18:40, Gleb Natapov ha scritto:
>> > Won't work, vmx won't let you enter in such a configuration.
> 
> Why? It is possible to have NULL descriptor in 32bit mode with vmx. But
> we do not usually intercept #GP while executing 32bit mode, so we will
> have to track if there is artificial NULL selector and enables #GP
> interception and then emulate on every #GP.

Yes, that's what I had in mind.  Of course for invalid CS you do have to
emulate.

>> > Maybe you can detect the exact code sequence (%eip, some instructions,
>> > register state) and clear %fs and %gs.
> My be we can set dpl to rpl unconditionally on a switch from 16 to 32
> bit. The only problem I can see with it is that if a guest enters user
> mode without explicitly reload the segment it will be accessible by a
> user mode code, but I am not sure it is well defined what dpl of a 16
> bit segment is after transition to 32 bit mode anyway, so it would be
> crazy to do so.

That too, or just set it to 3.  But perhaps the #GP interception
wouldn't be too hard.

Paolo
