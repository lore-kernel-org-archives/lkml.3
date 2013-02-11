Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759087Ab3BKTj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:39:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758344Ab3BKTj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:39:26 -0500
Message-ID: <511948E8.5030404@redhat.com>
Date: Mon, 11 Feb 2013 20:39:20 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: memcmp_nta: add timing-attack secure memcmp
References: <cover.1360528614.git.dborkman@redhat.com> <e73de7873eadcd7a1922535359c46caf25cbf0a2.1360528614.git.dborkman@redhat.com> <51193A79.9090907@amacapital.net>
In-Reply-To: <51193A79.9090907@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 07:37 PM, Andy Lutomirski wrote:
> On 02/10/2013 02:00 PM, Daniel Borkmann wrote:
>> If you need to compare a password or a hash value, the timing of the
>> comparison function can give valuable clues to the attacker. Let's
>> say the password is 123456 and the attacker tries abcdef. If the
>> comparision function fails at the first byte without looking at the
>> other bytes, then the attacker can measure the difference in runtime
>> and deduce which byte was wrong, reducing the attack space from
>> exponential to polynomial. [Daniel J. Bernstein]
>>
>> Therefore add memcmp_nta ({n}o {t}iming {a}ttacks) in order to avoid
>> such scenarios and to facilitate development by providing a generic
>> function for (e.g.) the crypto and networking subsystems.
>>
>> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
>> ---
>
> I read this as "compare memory with non-temporal access".  Perhaps
> something like "memcpy_constant_time" would be less confusing.

You probably mean "memcmp_constant_time".

Well, this could probably be misinterpreted, that for every possible input
it will take only O(1), which of course it doesn't. It's simply that for both
results (``equals to'', ``does not equal to'') it will take the same amount of
*operations* to achieve this in order to not leak any time information of a
successful or not successful comparison, where the attacker could draw
conclusions if he might have gotten parts of the hash/key/.. right or wrong.
