Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbaDCSYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:24:07 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:62724 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbaDCSYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:24:02 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy1dm_CoTv+tihQ+m54G3gR9siOngurHsuKf9W3k1sKKw@mail.gmail.com>
References: <20140403164911.GE24119@htj.dyndns.org>
	<CA+55aFy1dm_CoTv+tihQ+m54G3gR9siOngurHsuKf9W3k1sKKw@mail.gmail.com>
Date: Thu, 3 Apr 2014 11:24:00 -0700
X-Google-Sender-Auth: MNykvTvzG-qUj3LOxA30UqldDkU
Message-ID: <CA+55aFwBm202pchEH9A6vbJVdar9-T35pBF44cCt7FNjmno9sQ@mail.gmail.com>
Subject: Re: [GIT PULL] cgroup changes for v3.15-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        cgroups@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2014 at 11:11 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And the "bool *new_sb_created" argument really makes *zero* sense to
> kernfs_mount(). It was added to fix a namespace refcount leak, BUT
> kernfs_mount() DOES NOT TAKE A NAMESPACE PARAMETER!

Let me clarify that: the only reason I can see for why you'd care
about whether a new sb has been created is because the new sb needs a
namespace refcount.

Now, *if* there is some other reason to care, then the
"new_sb_created" argument may make sense even for kernfs_mount(). I
just don't see it. But if I'm wrong about that, then my alternate
resolution is wrong. However, as far as I can tell, anything else
should be properly refcounted by the mounting logic, and the "ns"
parameter is the only thing that needs to be handled by the caller
because it has that stupid opaque pointer that doesn't know its own
type.

Could that perhaps be fixed? If kernfs_mount_ns() could just do the
proper "grab" on the "void *ns" directly, all of the stupid
"new_sb_created" crud could just go away, even for kernfs_mount_ns().

                  Linus
