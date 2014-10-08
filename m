Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbaJHVaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 17:30:18 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:49265 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbaJHVaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 17:30:16 -0400
Date: Wed, 8 Oct 2014 14:30:00 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Richard Leitner <me@g0hl1n.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        richard.leitner@skidata.com
Subject: Re: [RFC] avoid (theoretical) conflicts of input device file names
Message-ID: <20141008213000.GC15198@dtor-ws>
References: <20141008224245.601a1339@frodo>
 <20141008224929.290e6403@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008224929.290e6403@frodo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Wed, Oct 08, 2014 at 10:49:29PM +0200, Richard Leitner wrote:
> Hi,
> currently I discovered the possibility that device file numbers of the input
> subsystem could go negative when the signed int "border" is passed. To fix
> this behaviour I sent a patch a few minutes ago.
> 
> But as the subject says there is currently the (theoretical) possibility that
> the same input device file name is given out twice. This can happen if the
> "input_no" variable had an overflow (due to the fact this is at least at 2^32
> I call the issue theoretical). If such a case occurs a -EEXISTS is returned at
> the creation of the file.
> 
> IMHO it would be a good idea to check if the chosen input device file name
> is valid at the point it is created (which is currently input_allocate_device).
> So you can just increment and check it again until there's a valid number/name
> found for it.
> 
> I'm pretty new to the input subsystem, so what do you think about it?
> Any comments/ideas? Would there be a better place to do such checking?

I do not think it is worth checking. Yes, theoretically you can wrap
around, but practically instantiating at least 2^32 devices will take
too long. If ever it becomes a concern my very distant future relatives
will move the counter to 64 or 128 bit and call it a day.

Thanks.

-- 
Dmitry
