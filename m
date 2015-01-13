Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbbAMTct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:32:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbbAMTcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:32:48 -0500
Message-ID: <54B572CA.9060607@redhat.com>
Date: Tue, 13 Jan 2015 14:32:26 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 04/11] x86,fpu: defer FPU restore until return to
 userspace
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-5-git-send-email-riel@redhat.com> <20150113175804.GA29851@redhat.com>
In-Reply-To: <20150113175804.GA29851@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/13/2015 12:58 PM, Oleg Nesterov wrote:
> On 01/11, riel@redhat.com wrote:
>> 
>> Defer restoring the FPU state, if so desired, until the task
>> returns to userspace.
> 
> And yet another concern ;) Although I feel that I am totally
> confused and probably wrong.
> 
>> --- a/arch/x86/include/asm/fpu-internal.h +++
>> b/arch/x86/include/asm/fpu-internal.h @@ -382,6 +382,7 @@ static
>> inline void drop_init_fpu(struct task_struct *tsk) else 
>> fxrstor_checking(&init_xstate_buf->i387); } +
>> clear_thread_flag(TIF_LOAD_FPU); }
> 
> OK, but shouldn't (say) restore_user_xstate() clear TIF_LOAD_FPU
> too? Otherwise, can't switch_fpu_finish() restore the wrong context
> later?

I address restore_user_xstate and save_user_xstate later in the
patch series. Once I have all the code working, I should refactor
that, in order to get a cleanly bisectable series.

> Or. Perhaps switch_fpu_finish() should do nothing if fpu.has_fpu ==
> T, I dunno.

One of the later patches in the series implements that.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUtXLKAAoJEM553pKExN6DCksH/iSAOJ4rqvDsBBY+VG5ZtQEK
7fo5bK1HQb0X8yeJPoR8rSg3PzqHjV1v+eU4d/OWEJHV7U9zxWedn+BRv8DrVZvo
1f1QqHY9ORZD0/NVZRJxlNBBqvUijUE1POTFixZVhU/t0MuWFG0+4a7BgY5B6RIa
/hZ4XcZ9fnTpN3cOSIEIOHCT90xZuUMwopRX/7ad8QRhqLaoH0MXqspAEMi8321b
4xwQUw1wD6OtCqWk1fG5dfF69F8ZrSGgNilUudwMeBEg4NODbVis6jw6iOZnjM+3
juZZXZ49LdYTlw5erjPVoZJ3kXZbdT1cIa81+LPDot/uKyAx5j6IKmM4ENQusw0=
=OHgf
-----END PGP SIGNATURE-----
