Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbaJHUth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:49:37 -0400
Received: from relay05.alfahosting-server.de ([109.237.142.241]:53412 "EHLO
	relay05.alfahosting-server.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172AbaJHUtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:49:35 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Oct 2014 16:49:34 EDT
X-Spam-DCC: : 
Date: Wed, 8 Oct 2014 22:49:29 +0200
From: Richard Leitner <me@g0hl1n.net>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        richard.leitner@skidata.com
Subject: [RFC] avoid (theoretical) conflicts of input device file names
Message-ID: <20141008224929.290e6403@frodo>
In-Reply-To: <20141008224245.601a1339@frodo>
References: <20141008224245.601a1339@frodo>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Checker-Version: clamassassin 1.2.4 with ClamAV 0.97.3/19486/Wed Oct  8 18:37:03 2014
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
currently I discovered the possibility that device file numbers of the input
subsystem could go negative when the signed int "border" is passed. To fix
this behaviour I sent a patch a few minutes ago.

But as the subject says there is currently the (theoretical) possibility that
the same input device file name is given out twice. This can happen if the
"input_no" variable had an overflow (due to the fact this is at least at 2^32
I call the issue theoretical). If such a case occurs a -EEXISTS is returned at
the creation of the file.

IMHO it would be a good idea to check if the chosen input device file name
is valid at the point it is created (which is currently input_allocate_device).
So you can just increment and check it again until there's a valid number/name
found for it.

I'm pretty new to the input subsystem, so what do you think about it?
Any comments/ideas? Would there be a better place to do such checking?

regards,
richard

