Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab3KNSCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 13:02:20 -0500
Received: from mail.eperm.de ([89.247.134.16]:51772 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab3KNSCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 13:02:11 -0500
From: Stephan Mueller <smueller@chronox.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
        sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Thu, 14 Nov 2013 19:01:58 +0100
Message-ID: <3127174.i8ueAho43m@tauon>
User-Agent: KMail/4.11.3 (Linux/3.11.7-200.fc19.x86_64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <5284AB17.5050802@ladisch.de>
References: <2579337.FPgJGgHYdz@tauon> <27146362.bQgmetPpTV@tauon> <5284AB17.5050802@ladisch.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 14. November 2013, 11:51:03 schrieb Clemens Ladisch:

Hi Clemens,

>Stephan Mueller wrote:
>> Am Mittwoch, 13. November 2013, 12:51:44 schrieb Clemens Ladisch:
>>> (And any setting that increases accesses to main memory is likey to
>>> introduce more entropy due to clock drift between the processor and
>>> the memory bus.  Or where do you assume the entropy comes from?)
>> 
>> You nailed it. When I disable the caches using the CR0 setting, I get
>> a massive increase in variations and thus entropy.
>
>Now this would be an opportunity to use the number of main memory
>accesses to estimate entropy.  (And when you're running out of the
>cache, i.e., deterministically, is there any entropy?)
>

I seem to have found the root cause with my bare metal tester, but I am 
yet unable to make sense of it.

I will report back with more analyses.


>An attacker would not try to detect patterns; he would apply knowledge
>of the internals.

I do not buy that argument, because if an attacker can detect or deduce 
the internals of the CPU, he surely can detect the state of the 
input_pool or the other entropy pools behind /dev/random. And then, 
/dev/random is not so entropic any more for that attacker.
>
>Statistical tests are useful only for detecting the absence of entropy,
>not for the opposite.

Again, I fully agree. But it is equally important to understand that 
entropy is relative. And all I want and all I care about is that an 
attacker has only the knowledge and ability to make measurements that 
are less precise than 1 bit.

Ciao
Stephan
