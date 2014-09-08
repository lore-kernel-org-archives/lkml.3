Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaIHDRO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 23:17:14 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:36917 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbaIHDRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 23:17:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140908012025.GF5061@mtj.dyndns.org>
References: <20140908012025.GF5061@mtj.dyndns.org>
Date: Sun, 7 Sep 2014 20:17:11 -0700
X-Google-Sender-Auth: 9gVIpvJ0SXxhoip7fHTyhVbkorw
Message-ID: <CA+55aFw+L1EUDEmAATDtGj_ngHos842jHLddAszboRy4b0pn2A@mail.gmail.com>
Subject: Re: [GIT PULL] cgroup fixes for v3.17-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 7, 2014 at 6:20 PM, Tejun Heo <tj@kernel.org> wrote:
>
>                   While this is a userland visible
> behavior change, given the craziness of allowing '\n' and its
> implications, I believe the change is justified.

Tejun, absolutely nothing "justifies" things if they break. Not "bad
design", not "craziness". Even security issues should be worked around
without breaking, if at all possible,

However, "userland visible" is only relevant _if_ things break.
Presumably nobody actually uses '\n' in a cgroup name. And if nothing
breaks, you don't need the excuses.

In other words, I'll happily pull this, but your excuses for it are
wrong-headed. There is no "crazyness justifies this". That's crap. But
the argument of "nobody does this, so let's fix it before anybody
_starts_ doing it" is perfectly valid - with the deep and implicit
understanding that if it turns out somebody *does* do it, the change
gets reverted asap.

People need to understand this. "Theoretical ABI breakage" is entirely
irrelevant. Nobody cares. But any _actual_ ABI breakage is a complete
no-no.

So next time you realize "ok, this could break things", don't make
excuses. Look for alternatives (maybe the name can be escaped, for
example), or take the approach of "let's hopw nobody notices".

None of this "the interface is crazy, so we can change it".  Because
that is pure and utter BS. Whether the interface is crazy or not is
*entirely* irrelevant to whether it can be changed or not. The only
thing that matters is whether people actually _trigger_ the issue you
have in reality, not whether the issue is crazy.

See the difference?

                 Linus
