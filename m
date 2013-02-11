Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848Ab3BKShu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 13:37:50 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:50966 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758777Ab3BKShs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 13:37:48 -0500
Message-ID: <51193A79.9090907@amacapital.net>
Date: Mon, 11 Feb 2013 10:37:45 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Daniel Borkmann <dborkman@redhat.com>
CC: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: memcmp_nta: add timing-attack secure memcmp
References: <cover.1360528614.git.dborkman@redhat.com> <e73de7873eadcd7a1922535359c46caf25cbf0a2.1360528614.git.dborkman@redhat.com>
In-Reply-To: <e73de7873eadcd7a1922535359c46caf25cbf0a2.1360528614.git.dborkman@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2013 02:00 PM, Daniel Borkmann wrote:
> If you need to compare a password or a hash value, the timing of the
> comparison function can give valuable clues to the attacker. Let's
> say the password is 123456 and the attacker tries abcdef. If the
> comparision function fails at the first byte without looking at the
> other bytes, then the attacker can measure the difference in runtime
> and deduce which byte was wrong, reducing the attack space from
> exponential to polynomial. [Daniel J. Bernstein]
> 
> Therefore add memcmp_nta ({n}o {t}iming {a}ttacks) in order to avoid
> such scenarios and to facilitate development by providing a generic
> function for (e.g.) the crypto and networking subsystems.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> ---

I read this as "compare memory with non-temporal access".  Perhaps
something like "memcpy_constant_time" would be less confusing.

--Andy
