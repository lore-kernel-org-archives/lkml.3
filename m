Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab3IDVEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 17:04:09 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:35328 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab3IDVEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 17:04:06 -0400
X-Greylist: delayed 1436 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Sep 2013 17:04:06 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21031.39606.16374.72229@quad.stoffel.home>
Date: Wed, 4 Sep 2013 16:40:22 -0400
From: "John Stoffel" <john@stoffel.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH] dcache: Translating dentry into pathname without taking
 rename_lock
In-Reply-To: <52278970.2080803@hp.com>
References: <1378321523-40893-1-git-send-email-Waiman.Long@hp.com>
	<52278970.2080803@hp.com>
X-Mailer: VM 8.2.0b under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Waiman" == Waiman Long <waiman.long@hp.com> writes:

Waiman> In term of AIM7 performance, this patch has a performance boost of
Waiman> about 6-7% on top of Linus' lockref patch on a 8-socket 80-core DL980.

Waiman> User Range          |   10-100  | 200-10000 | 1100-2000 |
Waiman> Mean JPM w/o patch  | 4,365,114 | 7,211,115 | 6,964,439 |
Waiman> Mean JPM with patch | 3,872,850 | 7,655,958 | 7,422,598 |
Waiman> % Change            |  -11.3%   |   +6.2%   |   +6.6%   |

This -11% impact is worisome to me, because at smaller numbers of
users, I would still expect the performance to go up.  So why the big
drop?  

Also, how is the impact of these changes on smaller 1 socket, 4 core
systems?  Just because it helps a couple of big boxes, doesn't mean it
won't hurt the more common small case.

John
