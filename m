Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab3BVENb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 23:13:31 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:42956 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab3BVENa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 23:13:30 -0500
Message-ID: <5126F067.4040707@hp.com>
Date: Thu, 21 Feb 2013 23:13:27 -0500
From: Waiman Long <Waiman.Long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] dcache: make Oracle more scalable on large systems
References: <1361299859-27056-1-git-send-email-Waiman.Long@hp.com> <20130221233818.GM26694@dastard> <m2bobdxl1i.fsf@firstfloor.org>
In-Reply-To: <m2bobdxl1i.fsf@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 07:13 PM, Andi Kleen wrote:
> Dave Chinner<david@fromorbit.com>  writes:
>
>> On Tue, Feb 19, 2013 at 01:50:55PM -0500, Waiman Long wrote:
>>> It was found that the Oracle database software issues a lot of call
>>> to the seq_path() kernel function which translates a (dentry, mnt)
>>> pair to an absolute path. The seq_path() function will eventually
>>> take the following two locks:
>> Nobody should be doing reverse dentry-to-name lookups in a quantity
>> sufficient for it to become a performance limiting factor. What is
>> the Oracle DB actually using this path for?
> Yes calling d_path frequently is usually a bug elsewhere.
> Is that through /proc ?
>
> -Andi
>
>
A sample strace of Oracle indicates that it opens a lot of /proc 
filesystem files such as the stat, maps, etc many times while running. 
Oracle has a very detailed system performance reporting infrastructure 
in place to report almost all aspect of system performance through its 
AWR reporting tool or the browser-base enterprise manager. Maybe that is 
the reason why it is hitting this performance bottleneck.

Regards,
Longman
