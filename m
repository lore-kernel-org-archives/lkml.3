Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaEWHAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 03:00:24 -0400
Received: from bes.se.axis.com ([195.60.68.10]:43501 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbaEWHAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 03:00:23 -0400
Date: Fri, 23 May 2014 09:00:16 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: cris: arch-v32: drivers: axisflashmap.c:
 Cleaning up inconsistent NULL checks
Message-ID: <20140523070016.GG9198@axis.com>
References: <1400796009-12716-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400796009-12716-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 12:00:09AM +0200, Rickard Strandqvist wrote:
> Cleaning up inconsistent NULL checks.
> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.

... and is a false positive.

We can't enter this if-block unless ptable_head is set,
which is only set if main_mtd is set.

It might be useful to add it anyways, but there's a refactoring
needed for the axisflashmaps, so I'll keep it for then.

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
