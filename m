Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3HaEQa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 00:16:30 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:58580 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab3HaEQ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 00:16:29 -0400
Date: Fri, 30 Aug 2013 23:16:26 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation/memory-barriers: fix a error that
 mistakes a CPU notion in Section Transitivity
To: larmbr <nasa4836@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        dhowells@redhat.com, nasa4836@gmail.com
In-Reply-To: <20130827103422.GA17355@larmbr-lcx> (from nasa4836@gmail.com on
	Tue Aug 27 05:34:22 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1377922586.2737.149@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 05:34:22 AM, larmbr wrote:
> The memory-barriers document may has a error in Section TRANSITIVITY.
> 
> For transitivity, see a example below, given that
> 
> * CPU 2's load from X follows CPU 1's store to X, and
>   CPU 2's load from Y preceds CPU 3's store to Y.

I'd prefer somebody with a better understanding of this code review it  
before merging. I'm not a memory barrier semantics expert, I can't tell  
you if this _is_ a bug.

> +The key point is that CPU 1's storing 1 to X preceds CPU 2's loading  
> 1

precedes

> +from X, and CPU 2's loading 0 from Y preceds CPU 3's storing 1 to Y,

precedes

> +which implies a ordering that the general barrier in CPU 2  
> guarantees:

an ordering

> +all store and load operations must happen before those after the  
> barrier
> +with respect to view of CPU 3, which constrained by a general  
> barrier, too.

the view of (or possibly "from the point of view of", the current  
phrasing is awkward)

which is constrained

Rob