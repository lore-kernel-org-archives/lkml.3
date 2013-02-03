Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab3BCCO3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 21:14:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:41760 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab3BCCO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 21:14:27 -0500
Message-ID: <510DC830.70707@infradead.org>
Date: Sat, 02 Feb 2013 18:15:12 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: David Teigland <teigland@redhat.com>, akpm@linux-foundation.org,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Christine Caulfield <ccaulfie@redhat.com>, cluster-devel@redhat.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, eric paris <eparis@redhat.com>
Subject: Re: [PATCH] idr: fix a subtle bug in idr_get_next()
References: <1359163872-1949-1-git-send-email-tj@kernel.org> <1359163872-1949-11-git-send-email-tj@kernel.org> <20130128155723.GC16789@redhat.com> <20130129151317.GA11609@redhat.com> <20130130212417.GJ24014@redhat.com> <20130131235320.GN6824@mtj.dyndns.org> <20130201001841.GP6824@mtj.dyndns.org> <20130201174443.GC3812@redhat.com> <20130201180028.GC31863@mtj.dyndns.org> <20130202231048.GA3940@mtj.dyndns.org> <20130202231135.GB3940@mtj.dyndns.org>
In-Reply-To: <20130202231135.GB3940@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/13 15:11, Tejun Heo wrote:
> On Sat, Feb 02, 2013 at 03:10:48PM -0800, Tejun Heo wrote:
>> Fix it by ensuring proceeding to the next slot doesn't carry over the
>> unaligned offset - ie. use round_up(id + 1, slot_distance) instead of
>> id += slot_distance.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Reported-by: David Teigland <teigland@redhat.com>
>> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> David, can you please test whether the patch makes the skipped
> deletion bug go away?
> 
> Thanks!

Hugh, did you update the idr test suite or the radix-tree test suite?

Is there an idr test suite or module?  I have a kernel module source file
named idr_test.c by Eric Paris.

thanks,

-- 
~Randy
