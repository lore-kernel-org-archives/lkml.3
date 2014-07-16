Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030626AbaGPHX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:23:27 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36599 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759384AbaGPHXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:23:25 -0400
Date: Wed, 16 Jul 2014 10:23:16 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, kvm@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        x86@kernel.org, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/4] random,x86,kvm: Add and use MSR_KVM_GET_RNG_SEED
Message-ID: <20140716072315.GW18167@minantech.com>
References: <cover.1405477965.git.luto@amacapital.net>
 <20140716064110.GV18167@minantech.com>
 <53C62563.6050106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C62563.6050106@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 09:10:27AM +0200, Daniel Borkmann wrote:
> On 07/16/2014 08:41 AM, Gleb Natapov wrote:
> >On Tue, Jul 15, 2014 at 07:48:06PM -0700, Andy Lutomirski wrote:
> >>virtio-rng is both too complicated and insufficient for initial rng
> >>seeding.  It's far too complicated to use for KASLR or any other
> >>early boot random number needs.  It also provides /dev/random-style
> >>bits, which means that making guest boot wait for virtio-rng is
> >>unacceptably slow, and doing it asynchronously means that
> >>/dev/urandom might be predictable when userspace starts.
> >>
> >>This introduces a very simple synchronous mechanism to get
> >>/dev/urandom-style bits.
> >
> >Why can't you use RDRAND instruction for that?
> 
> You mean using it directly? I think simply for the very same reasons
> as in c2557a303a ...
So you trust your hypervisor vendor more than you trust your CPU vendor? :)

--
			Gleb.
