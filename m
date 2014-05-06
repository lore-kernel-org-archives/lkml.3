Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaEFQag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 12:30:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38208 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbaEFQae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 12:30:34 -0400
Message-ID: <53690D97.50401@zytor.com>
Date: Tue, 06 May 2014 09:28:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org
CC: linux-mm@kvack.org, torvalds@linux-foundation.org, mgorman@suse.de,
        mingo@kernel.org, steven@uplinklabs.net, riel@redhat.com,
        david.vrabel@citrix.com, akpm@linux-foundation.org,
        peterz@infradead.org, xemul@parallels.com
Subject: Re: [patch 2/2] mm: pgtable -- Require X86_64 for soft-dirty tracker
References: <20140425081030.185969086@openvz.org> <20140425082042.848656782@openvz.org>
In-Reply-To: <20140425082042.848656782@openvz.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 01:10 AM, Cyrill Gorcunov wrote:
> Tracking dirty status on 2 level pages requires very ugly macros
> and taking into account how old the machines who can operate
> without PAE mode only are, lets drop soft dirty tracker from
> them for code simplicity (note I can't drop all the macros
> from 2 level pages by now since _PAGE_BIT_PROTNONE and
> _PAGE_BIT_FILE are still used even without tracker).
> 
> Linus proposed to completely rip off softdirty support on
> x86-32 (even with PAE) and since for CRIU we're not planning
> to support native x86-32 mode, lets do that.
> 
> (Softdirty tracker is relatively new feature which mostly used
>  by CRIU so I don't expect if such API change would cause problems
>  on userspace).

I have to wonder which one is more likely to actually matter on whatever
legacy 32-bit are going to remain.  This pretty much comes down to what
kind of advanced features are going to matter in deep embedded
applications in the future: checkpoint/restart or NUMA.  My guess is
that it is actually checkpoint/restart...

How much does it actually simplify to leave this feature in for PAE?  I
could care less about non-PAE... NX has pretty much killed that off cold.

	-hpa


