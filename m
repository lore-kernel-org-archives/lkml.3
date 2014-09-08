Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaIHH6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 03:58:48 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:38564 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbaIHH6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 03:58:47 -0400
From: Nix <nix@esperi.org.uk>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [3.16.1 REGRESSION]: Simtec Entropy Key (cdc-acm) broken in 3.16
References: <878um4tg09.fsf@spindle.srvr.nix>
	<1409569752.24385.12.camel@linux-fkkt.site>
	<874mwnosz1.fsf@spindle.srvr.nix>
	<1409903983.9532.0.camel@linux-fkkt.site>
	<8761h2nlk4.fsf@spindle.srvr.nix>
	<1410160901.11338.16.camel@linux-fkkt.site>
Emacs: if it payed rent for disk space, you'd be rich.
Date: Mon, 08 Sep 2014 08:58:44 +0100
In-Reply-To: <1410160901.11338.16.camel@linux-fkkt.site> (Oliver Neukum's
	message of "Mon, 08 Sep 2014 09:21:41 +0200")
Message-ID: <87sik2czm3.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: spindle 1290; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 Sep 2014, Oliver Neukum said:

> On Fri, 2014-09-05 at 16:17 +0100, Nix wrote:
>> On 5 Sep 2014, Oliver Neukum verbalised:
>> 
>> > On Fri, 2014-09-05 at 00:40 +0100, Nix wrote:
>> >> I'm working around this confusing morass by rebooting into each test
>> >> kernel, unplugging and replugging the entropy key if it was fubared,
>> >> then rebooting into the same kernel again and seeing if it was still
>> >> fubared. But this is not terribly fast, particularly not on a headless
>> >> compact-flash-based Geode box which doesn't even complete booting
>> >> without the entropy source which this bug cuts off :) so it'll be
>> >> sometime tomorrow before I can get this bisection done, I'm afraid.
>> >
>> > Ugh. My sympathies. I cannot suggest a better method, I am afraid.
>> 
>> Well, that method doesn't work. I've found pairs of kernels (e.g.
>> 59a3d4c3631e553357b7305dc09db1990aa6757c and
>> b05d59dfceaea72565b1648af929b037b0f96d7f) where each kernel works on its
>> own (rebooting from that kernel into the same kernel keeps a working
>> key, so I would normally assume that each kernel is OK) but rebooting
>> from the first into the second yields a broken one if it was working
>> before (so one of them must, in fact, be broken, but I have no clue
>> which one).
>> 
>> So I can't figure out how to bisect this.
>> 
>> Any suggestions as to what failure-test I might use, or what other
>> methods I might use to figure out what's going wrong? Not knowing
>> anything about USB doesn't help here. I don't know for sure that this is
>> a cdc-acm problem -- bisecting just the cdc-acm driver was fruitless --
>> so it might be something more generally USBish.
>
> Do your kernels work if you start with a known good kernel e.g.
> 3.15 and then reboot?

That case works -- aha, so I could orchestrate it by going

3.15 -> test -> test -> reset to 3.15 -> test -> test ...

i.e. a triple reboot cycle. Should have thought of that.

God, what a pain :)

I'll give it a try tonight.

-- 
NULL && (void)
