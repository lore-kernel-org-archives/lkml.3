Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084AbaKSVRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:17:52 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38900 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587AbaKSVRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:17:49 -0500
Date: Wed, 19 Nov 2014 16:17:44 -0500 (EST)
Message-Id: <20141119.161744.1661940121298888832.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] situation with csum_and_copy_... API
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFyQR2gOzEDROcWFcQzLvTjOxyJRjFJXJ03JB5knd-Gsgg@mail.gmail.com>
References: <20141118212307.GU7996@ZenIV.linux.org.uk>
	<20141119.153136.867017618826698045.davem@davemloft.net>
	<CA+55aFyQR2gOzEDROcWFcQzLvTjOxyJRjFJXJ03JB5knd-Gsgg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Nov 2014 13:17:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 19 Nov 2014 12:40:53 -0800

> On Wed, Nov 19, 2014 at 12:31 PM, David Miller <davem@davemloft.net> wrote:
>>
>> But that is just my opinion, and yes I do acknowledge that we've had
>> serious holes in this area in the past.
> 
> The serious holes have generally been exactly in the "upper layers
> already check" camp, and then it turns out that some odd ioctl or
> other thing ends up doing something odd and interesting.
> 
> If Al has actual performance profiles showing that the access_ok() is
> a real problem, then fine. As a low-level optimization, I agree with
> it. But not as a "let's just drop them, and make the security rules be
> non-local and subtle, and require people to know the details of the
> whole call-chain".
> 
> Seeing a "__get_user()" and just being able to glance up in the same
> function and seeing the "access_ok()" is just a good safety net. And
> means that people don't have to waste time thinking about or looking
> for where the hell the security net really is.

Fair enough.
