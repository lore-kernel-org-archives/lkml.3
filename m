Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbbAMUGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:06:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbbAMUGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:06:22 -0500
Message-ID: <54B57AAC.6020903@redhat.com>
Date: Tue, 13 Jan 2015 15:06:04 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 04/11] x86,fpu: defer FPU restore until return to
 userspace
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-5-git-send-email-riel@redhat.com> <20150113171134.GA27519@redhat.com> <54B55BE7.1020107@redhat.com> <20150113182239.GA30475@redhat.com> <20150113183003.GB30475@redhat.com>
In-Reply-To: <20150113183003.GB30475@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/13/2015 01:30 PM, Oleg Nesterov wrote:
> On 01/13, Oleg Nesterov wrote:
>> 
>> But yes, I think we need the per-cpu "in_kernel_fpu" and
>> irq_fpu_usable() must die. Please look at
>> http://marc.info/?l=linux-kernel&m=14096628660929

This link does not work for me. I wonder if that email is not
on the marc.info node I managed to send my http request to...

> Plus I think we need this to fix the race with
> math_state_restore()... Please see
> http://marc.info/?l=linux-kernel&m=140992479607206
> 
> Unfortunately I forgot other problems I found in this area... And I
> completely forgot the plan I had in mind ;)

That I can certainly merge into my series.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUtXqsAAoJEM553pKExN6DESsH/iVrj6VEpV1gqyxB7T0cC0wr
UWjPP5OyV2JRkOronbl1iA9YMhN5WUfhvdWph4nauL0nR+IOip2qRqCmQN6NG4yj
A9u3NTDzKpXCBaBf+Ub5yPBv/QESvGomxUQmEYYdgxW6OfZtp0apouSPIhCAwWMq
XPKVXyjl0AH30+tV9oMnhhnXuwdG+ojNDFK8xeMG15gBPP8LncVYkmlgTeD4Kzca
VPw83KxFqNekEA7TPboBkjqDEfckT8tTsutlOMWmBnyI51duuMX3qc4xoJfCdmNB
+f8TYL0Y/7RKF2RS9qDXZRk1fakQHbzCaswpRIs7522zj49tkrGi4AFmUaOZ+0k=
=7eRE
-----END PGP SIGNATURE-----
