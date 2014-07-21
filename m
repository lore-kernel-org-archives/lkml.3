Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaGUBmG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 21:42:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59612 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaGUBmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 21:42:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+xx2exZdD64mXWzmvVUzBrFUOg-kZ5E4+tvKAuGTKW4w@mail.gmail.com>
References: <1405373897-31671-1-git-send-email-keescook@chromium.org>
	<1405373897-31671-7-git-send-email-keescook@chromium.org>
	<CACVXFVOnxjXjnKRWg7sv425POLSS96kAxxEohtLqj4dvcxnRyg@mail.gmail.com>
	<CAGXu5j+xx2exZdD64mXWzmvVUzBrFUOg-kZ5E4+tvKAuGTKW4w@mail.gmail.com>
Date: Mon, 21 Jul 2014 09:42:00 +0800
Message-ID: <CACVXFVMk5hTAvMgL0V2ycy-P=LCtOktimw5Hst+aFYLS6jewXw@mail.gmail.com>
Subject: Re: [PATCH 6/7] firmware_class: add "fd" input file
From: Ming Lei <ming.lei@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <james.l.morris@oracle.com>,
        David Howells <dhowells@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-firmware@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 1:43 AM, Kees Cook <keescook@chromium.org> wrote:
> On Sat, Jul 19, 2014 at 8:04 PM, Ming Lei <ming.lei@canonical.com> wrote:
>> On Tue, Jul 15, 2014 at 5:38 AM, Kees Cook <keescook@chromium.org> wrote:
>>> As an alternative to loading bytes from the "data" blob when reading
>>> firmware, let kernel read from an fd, so that the LSM can reason about
>>> the origin of firmware contents during userspace on-demand loading.
>>
>> From user space view, maybe it is better to keep previous usage and just
>> check if loading is from 'data' blob or fd in 'echo 0 > loading' of
>> firmware_loading_store(), then the 'fd' usage becomes very similar with
>> before.
>
> I don't think this is a good idea because otherwise there isn't a good
> way to have an "atomic" check of the firmware contents. What does it

Could you share why 'atomic' check is necessary? As we know, it isn't
real atomic, :-).

> means to write to "fd" several times, then write "data" a little,
> before writing "loading", etc? I originally wrote the patch series

That depends how firmware loader supports these cases, and won't
be difficult to handle them.

For non-fd userspace interface, it is very flexible to be capable of
supporting to load firmware data from multiple images, or in flight.
With single 'fd' interface, it won't be possible any more.

> requiring the "loading" piece, and it ended up being very complicated
> due to needing to switch the memory buffer logic back and forth.
> Everything is much much cleaner if "fd" is single-shot, and not part
> of the loading/data interface semantics.

You might not avoid the 'loading' piece completely, how does
the userspace handle non-exist firmware image? The reasonable
way is to abort the loading from userspace via 'echo -1 > loading'
since userspace already sees that, and you may choose to let kernel
side handle that, but your current patch doesn't support it yet.

Thanks,
