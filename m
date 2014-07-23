Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbaGWJrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:47:21 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51016 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757597AbaGWJrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:47:17 -0400
Message-Id: <1406108835.2603.144733749.2407B407@webmail.messagingengine.com>
X-Sasl-Enc: yN+HpT5NYj2FLyBAoA66nECwIrRY0o4udyYaTYpYXQSd 1406108835
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: George Spelvin <linux@horizon.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-c420910d
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Date: Wed, 23 Jul 2014 11:47:15 +0200
In-Reply-To: <20140722225950.GU25291@thunk.org>
References: <20140721112102.19300.qmail@ns.horizon.com>
 <1405956426.2319.37.camel@localhost>
 <1405990940.28229.4.camel@localhost> <20140722044409.GE24960@thunk.org>
 <1406022592.2407.9.camel@localhost> <20140722225950.GU25291@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 23, 2014, at 00:59, Theodore Ts'o wrote:
> But why would you need to use GRND_RANDOM in your scenario, and accept
> your application potentially getting stalled and stuck in amber for
> perhaps hours?  If you are going to accept your application stalling
> like that, you can do the pointer arithmatic.  It's really not hard,
> and someone who can't do that, again, shouldn't be allowd anywhere
> near crypto code in the first place (and if they are, they'll probably
> be making lots of other, equally fatal if not more so, newbie
> mistakes).

I favored the idea of having a non-failing non-partial-read getrandom
syscall. But I am with you if it often causes long stalls that we should
stick to the old semantics.

Thanks,
Hannes

