Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbaLEViF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:38:05 -0500
Received: from ns.horizon.com ([71.41.210.147]:20587 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751855AbaLEViD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:38:03 -0500
Date: 5 Dec 2014 16:38:01 -0500
Message-ID: <20141205213801.3844.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: borntraeger@de.ibm.com
Subject: Re: [PATCH 1/9] kernel: Provide READ_ONCE and ASSIGN_ONCE
Cc: linux@horizon.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org
In-Reply-To: <CA+55aFzzEhbkoXnVGXAbq-HxejmWSyjMBN_aQM61J_zZLPXwAw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Of prefer it to match the put_user model, which is (val, ptr). But as long
> as there is your safety (and the whole point of the macro is that it
> figures out the type from the pointer), I guess it doesn't matter too much
> in practice.
> 
> I think my original suggestion also wrote it in lower case, since it
> actually works like a function (well, template, whatever). Again kind of
> like the user copy "functions".
> 
> But I don't care *that* strongly.

That's an excellent point.  But it means that Christian, you're free to
do whatever seems good to you.

I'm not rabid about it, either; I just figure that now is a good time
to think carefully about it.

Personally, after running through some different names that work
with (src,dst) order I'd try the pairs:

	READ_ONCE(var) / WRITE_ONCE(value,var)
or
	LOAD_ONCE(var) / STORE_ONCE(value,var)

Of the two, I think I prefer the latter, because that's what the
operations are called at the hardware level, so it's most evocative of
the actual semantics.  "Assignment" is a higher-level concept.

But as I said, whatever you think best.  I'd just like to advocate for
some actual thinking, because it's going to be all over the kernel and
a pain to change.
