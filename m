Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171Ab3FCP7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:59:48 -0400
Received: from mail.candelatech.com ([208.74.158.172]:45604 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759090Ab3FCP7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:59:45 -0400
Message-ID: <51ACBD6A.1030304@candelatech.com>
Date: Mon, 03 Jun 2013 08:59:38 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Joe Lawrence <joe.lawrence@stratus.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: Please add to stable:  module: don't unlink the module until
 we've removed all exposure.
References: <51A8E884.1080009@candelatech.com> <87ehclumhr.fsf@rustcorp.com.au> <alpine.DEB.2.02.1306022212200.10003@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1306030724230.19647@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1306031012460.22652@jlaw-desktop.mno.stratus.com>
In-Reply-To: <alpine.DEB.2.02.1306031012460.22652@jlaw-desktop.mno.stratus.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 07:17 AM, Joe Lawrence wrote:

>>> Hi Rusty,
>>>
>>> I had pointed Ben (offlist) to that bugzilla entry without realizing
>>> there were other earlier related fixes in this space.  Re-viewing bz-
>>> 58011, it looks like it was opened against 3.8.12, while Ben and myself
>>> had encountered module loading problems in versions 3.9 and
>>> 3.9.[1-3].  I can update the bugzilla entry to add a comment noting commit
>>> a49b7e82 "kobject: fix kset_find_obj() race with concurrent last
>>> kobject_put()".
>>>
>>> That said, it doesn't appear that commit 944a1fa "module: don't unlink the
>>> module until we've removed all exposure" has not made it into any stable
>>> kernel.  On my system, applying this on top of 3.9 resolved a module
>>> unload/load race that would occasionally occur on boot (two video adapters
>>> of the same make, the module unloads for whatever reason and I see "module
>>> is already loaded" and "sysfs: cannot create duplicate filename
>>> '/module/mgag200'" messages every 5-10% instances.)  I have logs if you
>>> were interested in these warnings/crashes.

It at least works around the problem for me as well.  But, a more rare
migration/[0-3] (I think) related lockup still exists in 3.9.4 for me,
so I will also try applying that other kobject patch and continue testing
today...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

