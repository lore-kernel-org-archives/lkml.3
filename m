Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782Ab3BLKXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:23:38 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:33984 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755677Ab3BLKXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:23:36 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Daniel Borkmann <borkmann@iogearbox.net>
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: memcmp_nta: add timing-attack secure memcmp
References: <cover.1360528614.git.dborkman@redhat.com>
	<e73de7873eadcd7a1922535359c46caf25cbf0a2.1360528614.git.dborkman@redhat.com>
	<87zjzallp5.fsf@mid.deneb.enyo.de> <5119777E.6030005@iogearbox.net>
Date: Tue, 12 Feb 2013 11:23:29 +0100
In-Reply-To: <5119777E.6030005@iogearbox.net> (Daniel Borkmann's message of
	"Mon, 11 Feb 2013 23:58:06 +0100")
Message-ID: <87y5et7rvi.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Borkmann:

> On 02/11/2013 08:00 PM, Florian Weimer wrote:
>> * Daniel Borkmann:
>
> Thanks for your feedback, Florian!
>
>>> + * memcmp_nta - memcmp that is secure against timing attacks
>>
>> It's not providing an ordering, so it should not have "cmp" in the
>> name.
>
> I agree. What would you suggest? Probably, it would make sense to
> integrate this into the Linux crypto API and name it sth like ...
>
>   crypto_mem_verify(const void *,const void *,__kernel_size_t)
>
> ... which returns:
>
>   == 0 - mem regions equal each other
>   != 0 - mem regions do not equal each other

crypto_mem_equal or crypto_mem_equals should be fine.  Or anything
else which matches an existing function name with similar function.

>>> +	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--)
>>> +		res |= (*su1 ^ *su2);
>>
>> The compiler could still short-circuit this loop.  Unlikely at
>> present, but this looks like a maintenance hazard.
>
> So then better we leave out '|' as a possible candidate and rewrite it as:
>
> +	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--)
> +		res += (*su1 ^ *su2);

That will cause false matches for long inputs.

If we had only four platforms to support, I would write this function
in assembler because it will be considerably easier to read.
