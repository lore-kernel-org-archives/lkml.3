Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3EHL5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 07:57:33 -0400
Received: from mx2.parallels.com ([199.115.105.18]:46753 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab3EHL5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 07:57:32 -0400
Message-ID: <518A3DDC.1090905@parallels.com>
Date: Wed, 8 May 2013 15:58:20 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Tony Lindgren <tony@atomide.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [GIT PULL] SLAB changes for v3.10
References: <alpine.LFD.2.03.1305070936320.2383@kernel.org> <20130508003022.GS28721@atomide.com> <20130508042422.GU28721@atomide.com> <20130508051602.GV28721@atomide.com> <CAOJsxLEB2gSWefNHNeKfxv9Hp=H9PG0bGgTcUPE4abz3fv_fxw@mail.gmail.com>
In-Reply-To: <CAOJsxLEB2gSWefNHNeKfxv9Hp=H9PG0bGgTcUPE4abz3fv_fxw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 10:20 AM, Pekka Enberg wrote:
>> > Hmm it's actually CONFIG_PROVE_LOCKING=y that causes the problem,
>> > not CONFIG_DEBUG_SPINLOCK=y. CONFIG_DEBUG_SPINLOCK=y was just selected
>> > by CONFIG_PROVE_LOCKING=y in my non-booting .config. I can now fix my
>> > non-booting .config by removing PROVE_LOCKING and DEBUG_SPINLOCK,
>> > but I cannot break my other working .config by adding PROVE_LOCKING
>> > and DEBUG_SPINLOCK. Hmm.
> That's almost certainly a slab bootstrap issue. Lockdep et al just
> change struct sizes which is why the problem shows up. Is this with
> SLAB or SLUB? Christoph, Glauber, care to take a look?
> 
>>>> >> > 

My first guess is that it hit a NULL cache. Being a NULL pointer
dereference, the thing among all that has the biggest chances of being
NULL and accessed unconditionally is the cache pointer itself.

Due to the size being too big. But if that were the case, he would have
hit the WARN_ON recently introduced:

                if (WARN_ON_ONCE(size > KMALLOC_MAX_SIZE))
                        return NULL;


Is this WARN hit ?
