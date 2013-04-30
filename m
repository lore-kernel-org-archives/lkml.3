Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489Ab3D3Asl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 20:48:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759443Ab3D3As3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 20:48:29 -0400
Message-ID: <517F14D1.3070307@redhat.com>
Date: Mon, 29 Apr 2013 20:48:17 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Pierre-Loup A. Griffais" <pgriffais@valvesoftware.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        sonnyrao@chromium.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: IO regression after ab8fabd46f on x86 kernels with high memory
References: <517B1153.8000401@valvesoftware.com> <517B2FB4.30605@redhat.com> <20130427024248.GA1229@cmpxchg.org> <517EEBD1.503@valvesoftware.com> <CA+55aFxcq44JsrrR5KKuT=DZQHCfOE3KHQrcD215T+deYesW2g@mail.gmail.com>
In-Reply-To: <CA+55aFxcq44JsrrR5KKuT=DZQHCfOE3KHQrcD215T+deYesW2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 06:03 PM, Linus Torvalds wrote:

> Seriously, you can compile yourself a 64-bit kernel and continue to
> use your 32-bit user-land. And you can complain to whatever distro you
> used that it didn't do that in the first place. But we're not going to
> bother with trying to tune PAE for some particular load. It's just not
> worth it to anybody.

I can think of one way to "tune PAE" that will help
avoid the breakage, and at the same time draw the
attention of users.

Limit the memory that a 32 bit PAE kernel uses, to
something small enough where the user will not
encounter random breakage.  Maybe 8 or 12GB?

It could also print out a friendly message, to
inform the user they should upgrade to a 64 bit
kernel to enjoy the use of all of their memory.

It is a bit of a heavy stick, but I suspect that
it would clue in all of the affected users.

If you have no objection to this, I'll whip up a
patch.

