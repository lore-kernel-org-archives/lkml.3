Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbaGPHKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:10:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334AbaGPHKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:10:42 -0400
Message-ID: <53C62563.6050106@redhat.com>
Date: Wed, 16 Jul 2014 09:10:27 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>
CC: Andy Lutomirski <luto@amacapital.net>, kvm@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        x86@kernel.org, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/4] random,x86,kvm: Add and use MSR_KVM_GET_RNG_SEED
References: <cover.1405477965.git.luto@amacapital.net> <20140716064110.GV18167@minantech.com>
In-Reply-To: <20140716064110.GV18167@minantech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 08:41 AM, Gleb Natapov wrote:
> On Tue, Jul 15, 2014 at 07:48:06PM -0700, Andy Lutomirski wrote:
>> virtio-rng is both too complicated and insufficient for initial rng
>> seeding.  It's far too complicated to use for KASLR or any other
>> early boot random number needs.  It also provides /dev/random-style
>> bits, which means that making guest boot wait for virtio-rng is
>> unacceptably slow, and doing it asynchronously means that
>> /dev/urandom might be predictable when userspace starts.
>>
>> This introduces a very simple synchronous mechanism to get
>> /dev/urandom-style bits.
 >
> Why can't you use RDRAND instruction for that?

You mean using it directly? I think simply for the very same reasons
as in c2557a303a ...
