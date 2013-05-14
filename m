Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab3ENPEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:04:16 -0400
Received: from mx2.parallels.com ([199.115.105.18]:49956 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463Ab3ENPEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:04:15 -0400
Message-ID: <5192523B.7030805@parallels.com>
Date: Tue, 14 May 2013 19:03:23 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Oskar Andero <oskar.andero@sonymobile.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Radovan Lekanovic <radovan.lekanovic@sonymobile.com>,
        David Rientjes <rientjes@google.com>,
        Dave Chinner <david@fromorbit.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC PATCH 0/2] return value from shrinkers
References: <1368454595-5121-1-git-send-email-oskar.andero@sonymobile.com>
In-Reply-To: <1368454595-5121-1-git-send-email-oskar.andero@sonymobile.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 06:16 PM, Oskar Andero wrote:
> Hi,
> 
> In a previous discussion on lkml it was noted that the shrinkers use the
> magic value "-1" to signal that something went wrong.
> 
> This patch-set implements the suggestion of instead using errno.h values
> to return something more meaningful.
> 
> The first patch simply changes the check from -1 to any negative value and
> updates the comment accordingly.
> 
> The second patch updates the shrinkers to return an errno.h value instead
> of -1. Since this one spans over many different areas I need input on what is
> a meaningful return value. Right now I used -EBUSY on everything for consitency.
> 
> What do you say? Is this a good idea or does it make no sense at all?
> 
> Thanks!
> 

Right now me and Dave are completely reworking the way shrinkers
operate. I suggest, first of all, that you take a look at that cautiously.

On the specifics of what you are doing here, what would be the benefit
of returning something other than -1 ? Is there anything we would do
differently for a return value lesser than 1?

So far, shrink_slab behaves the same, you are just expanding the test.
If you really want to push this through, I would suggest coming up with
a more concrete reason for why this is wanted.

