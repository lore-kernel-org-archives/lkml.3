Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3IKDUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 23:20:44 -0400
Received: from ozlabs.org ([203.10.76.45]:50834 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab3IKDUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 23:20:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Frantisek Hrbata <fhrbata@redhat.com>
Cc: Kyle McMartin <kyle@infradead.org>, linux-kernel@vger.kernel.org,
        jstancek@redhat.com, keescook@chromium.org,
        peter.oberparleiter@de.ibm.com, linux-arch@vger.kernel.org,
        arnd@arndb.de, mgahagan@redhat.com, agospoda@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2 4/4] kernel: add support for init_array constructors
In-Reply-To: <20130910132834.GF2259@localhost.localdomain>
References: <1378305776-3644-1-git-send-email-fhrbata@redhat.com> <1378305776-3644-5-git-send-email-fhrbata@redhat.com> <87vc2e66kr.fsf@rustcorp.com.au> <20130906175118.GB2332@localhost.localdomain> <20130906180751.GD25882@merlin.infradead.org> <87d2oi6bl0.fsf@rustcorp.com.au> <20130909162814.GA2288@localhost.localdomain> <878uz544si.fsf@rustcorp.com.au> <20130910132834.GF2259@localhost.localdomain>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 11 Sep 2013 11:22:59 +0930
Message-ID: <8761u83z0k.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frantisek Hrbata <fhrbata@redhat.com> writes:
> On Tue, Sep 10, 2013 at 03:05:57PM +0930, Rusty Russell wrote:
>> Frantisek Hrbata <fhrbata@redhat.com> writes:
>> > On Mon, Sep 09, 2013 at 10:44:03AM +0930, Rusty Russell wrote:
>> >> Kyle McMartin <kyle@infradead.org> writes:
>> >> > On Fri, Sep 06, 2013 at 07:51:18PM +0200, Frantisek Hrbata wrote:
>> >> >> > > v2: - reuse mod->ctors for .init_array section for modules, because gcc uses
>> >> >> > >       .ctors or .init_array, but not both at the same time
>> >> >> > >
>> >> >> > > Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
>> >> >> > 
>> >> >> > Might be nice to document which gcc version changed this, so people can
>> >> >> > choose whether to cherry-pick this change?
>> >> >> 
>> >> >> Thank you for pointing this out. As per gcc git this was introduced by commit
>> >> >> ef1da80 and released in 4.7 version.
>> >> >> 
>> >> >> $ git describe --contains ef1da80
>> >> >> gcc-4_7_0-release~4358
>> >> >> 
>> >> >> Do you want me to post v3 with this info included in the descrition?
>> >> >> 
>> >> >
>> >> > It actually depends on the combination of binutils/ld and gcc you use, not
>> >> > simply which gcc version you use. :/
>> >> 
>> >> Indeed, and seems it was binutils 20110507 which actually handled it
>> >> properly.
>> >> 
>> >> AFAICT it's theoretically possible to have .ctors and .init_array in a
>> >> module.  Unlikely, but the patch should check for both and refuse to
>> >> load the module in that case.  Otherwise weird things would happen.
>> >
>> > I'm not sure if coexistence of .ctors and .init_array sections should result in
>> > denial of module, but I for sure know nothing about this :). Could you maybe
>> > privide one example of the "weird thing"?
>> 
>> Well, if we have both ctors and init_array, and we only call the ctors,
>> part of the module will be uninitialized.
>> 
>> I was thinking about something like the following (based on your
>> previous patch).
>> 
>> Thoughts?
>> Rusty.
>
> Thank you Rusty, from what I can say it looks ok to me. So I would go with this
> version. Is there anything that needs to be done to consider this as the
> correct version of the 4/4 patch? Meaning should we repost this as v3 or could
> your version of the patch be picked as you posted it?

Take that as posted.  I could push it through my tree, but I think
you'll want to keep them all together.

Cheers,
Rusty.
