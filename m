Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab3F2HUV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 03:20:21 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:51850 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3F2HUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 03:20:20 -0400
Date: Sat, 29 Jun 2013 09:20:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: jbaron@akamai.com
Cc: rostedt@goodmis.org, andi@firstfloor.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Subject: Re: [PATCH 0/3] static keys: fix test/set races
Message-ID: <20130629072016.GA14746@gmail.com>
References: <cover.1372457176.git.jbaron@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1372457176.git.jbaron@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* jbaron@akamai.com <jbaron@akamai.com> wrote:

> Hi,
> 
> As pointed out by Andi Kleen, some static key users can be racy because they
> check the value of the key->enabled, and then subsequently update the branch
> direction. A number of call sites have 'higher' level locking that avoids this
> race, but the usage in the scheduler features does not. See:
> http://lkml.indiana.edu/hypermail/linux/kernel/1304.2/01655.html

But that's not an issue at all - switching the scheduler features is for 
development and debugging only, and in some cases higher level locking 
would be needed to solve it 'properly', beyond what the keys API could 
give ...

So this is pretty pointless, sorry, please don't complicate this facility.

Thanks,

	Ingo
