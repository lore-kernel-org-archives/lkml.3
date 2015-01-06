Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbbAFJeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 04:34:37 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:42737 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbbAFJec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 04:34:32 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUU4ALYvEq7SkUewnZytf62R0d9x+MVPvMrR0zzFf+-f3Q@mail.gmail.com>
References: <CA+icZUU4ALYvEq7SkUewnZytf62R0d9x+MVPvMrR0zzFf+-f3Q@mail.gmail.com>
Date: Tue, 6 Jan 2015 10:34:30 +0100
Message-ID: <CA+icZUXbbLE-z0SS=0rVnEYq5zFr1f4omOuSS7BL4OpAv0eagA@mail.gmail.com>
Subject: Re: Linux 3.19-rc3
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Dave Jones <davej@codemonkey.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Takashi Iwai <tiwai@suse.de>
Content-Type: multipart/mixed; boundary=047d7bb039469387f3050bf88344
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bb039469387f3050bf88344
Content-Type: text/plain; charset=UTF-8

On Tue, Jan 6, 2015 at 5:49 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> [ Please CC me I am not subscribed to LKML ]
>
> [ QUOTE ]
>
> On Mon, Jan 05, 2015 at 05:46:15PM -0800, Linus Torvalds wrote:
>  > It's a day delayed - not because of any particular development issues,
>  > but simply because I was tiling a bathroom yesterday. But rc3 is out
>  > there now, and things have stayed reasonably calm. I really hope that
>  > implies that 3.19 is looking good, but it's equally likely that it's
>  > just that people are still recovering from the holiday season.
>  >
>  > A bit over three quarters of the changes here are drivers - mostly
>  > networking, thermal, input layer, sound, power management. The rest is
>  > misc - filesystems, core networking, some arch fixes, etc. But all of
>  > it is pretty small.
>  >
>  > So go out and test,
>
> This has been there since just before rc1. Is there a fix for this
> stalled in someones git tree maybe ?
>
> [    7.952588] WARNING: CPU: 0 PID: 299 at kernel/sched/core.c:7303
> __might_sleep+0x8d/0xa0()
> [    7.952592] do not call blocking ops when !TASK_RUNNING; state=1
> set at [<ffffffff910a0f7a>] prepare_to_wait+0x2a/0x90
> [    7.952595] CPU: 0 PID: 299 Comm: systemd-readahe Not tainted
> 3.19.0-rc3+ #100
> [    7.952597]  0000000000001c87 00000000720a2c76 ffff8800b2513c88
> ffffffff915b47c7
> [    7.952598]  ffffffff910a3648 ffff8800b2513ce0 ffff8800b2513cc8
> ffffffff91062c30
> [    7.952599]  0000000000000000 ffffffff91796fb2 000000000000026d
> 0000000000000000
> [    7.952600] Call Trace:
> [    7.952603]  [<ffffffff915b47c7>] dump_stack+0x4c/0x65
> [    7.952604]  [<ffffffff910a3648>] ? down_trylock+0x28/0x40
> [    7.952606]  [<ffffffff91062c30>] warn_slowpath_common+0x80/0xc0
> [    7.952607]  [<ffffffff91062cc0>] warn_slowpath_fmt+0x50/0x70
> [    7.952608]  [<ffffffff910a0f7a>] ? prepare_to_wait+0x2a/0x90
> [    7.952610]  [<ffffffff910a0f7a>] ? prepare_to_wait+0x2a/0x90
> [    7.952611]  [<ffffffff910867ed>] __might_sleep+0x8d/0xa0
> [    7.952614]  [<ffffffff915b8ea9>] mutex_lock_nested+0x39/0x3e0
> [    7.952616]  [<ffffffff910a77ad>] ? trace_hardirqs_on+0xd/0x10
> [    7.952617]  [<ffffffff910a0fac>] ? prepare_to_wait+0x5c/0x90
> [    7.952620]  [<ffffffff911a63e0>] fanotify_read+0xe0/0x5b0
> [    7.952622]  [<ffffffff91090801>] ? sched_clock_cpu+0xc1/0xd0
> [    7.952624]  [<ffffffff91242459>] ? selinux_file_permission+0xb9/0x130
> [    7.952626]  [<ffffffff910a14d0>] ? prepare_to_wait_event+0xf0/0xf0
> [    7.952628]  [<ffffffff91162513>] __vfs_read+0x13/0x50
> [    7.952629]  [<ffffffff911625d8>] vfs_read+0x88/0x140
> [    7.952631]  [<ffffffff911626e7>] SyS_read+0x57/0xd0
> [    7.952633]  [<ffffffff915bd952>] system_call_fastpath+0x12/0x17
>
> [ /QUOTE ]
>
> I am seeing a similiar call-trace/warning.
> It is reproducible when running fio (latest: v2.2.4) while my loop-mq
> tests (see block.git#for-next)
>
> Some people tend to say it's coming from the linux-aio area [1], but I
> am not sure.
> 1st I thought this is a Linux-next problem but I am seeing it also
> with my rc-kernels.
> For parts of aio there is a patch discussed in [2].
> The experimental patchset of Ken from [3] made the "aio" call-trace go
> away here.
>
> I tried also a patch pending in peterz/queue.git#sched/core from Eric Sandeen.
> It's "check for stack overflow in ___might_sleep".
> Unfortunately, it did not help in case of my loop-mq tests.
> ( BTW, this is touching ___might_sleep() (note: triple-underscore VS.
> affected __might_sleep() <--- double-underscrore). )
>
> Let me hear your feedback.
>
> Have more fun!
>
> - Sedat -
>
> [1] http://marc.info/?l=linux-aio&m=142033318411355&w=2
> [2] http://marc.info/?l=linux-aio&m=142035799514685&w=2
> [3] http://evilpiepirate.org/git/linux-bcache.git/log/?h=aio_ring_fix
> [4] http://git.kernel.org/cgit/linux/kernel/git/peterz/queue.git/patch/?id=48e615e4c3ebed488fecb6bfb40b372151f62db2

[ CC Takashi ]

>From [1]:
...

Just "me too" (but overlooked until recently).

The cause is a mutex_lock() call right after prepare_to_wait() with
TASK_INTERRUPTIBLE in fanotify_read().

static ssize_t fanotify_read(struct file *file, char __user *buf,
    size_t count, loff_t *pos)
{
....
while (1) {
prepare_to_wait(&group->notification_waitq, &wait, TASK_INTERRUPTIBLE);
mutex_lock(&group->notification_mutex);

I saw Peter already fixed a similar code in inotify_user.c by commit
e23738a7300a (but interestingly for a different reason, "Deal with
nested sleeps").  Supposedly a similar fix would be needed for
fanotify_user.c.
...

Can you explain why do you think the problem is in sched-fanotify?

I tried to do such a "similiar" (quick) fix analog to the mentioned
"sched, inotify: Deal with nested sleeps" patch from Peter.
If I did correct... It does not make the call-trace go away here.

- Sedat -

[1] http://marc.info/?l=linux-kernel&m=142053231023575&w=2

--047d7bb039469387f3050bf88344
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-sched-fanotify-Deal-with-nested-sleeps.patch"
Content-Disposition: attachment; 
	filename="0001-sched-fanotify-Deal-with-nested-sleeps.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i4l2sti10

RnJvbSA1NDQ1NDA0ZTc2ODY1Mzc3MWZhY2E5NzcwNzU1MzQwMjAwZmU4YjZjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDYgSmFuIDIwMTUgMDk6NTE6NTQgKzAxMDAKU3ViamVjdDogW1BBVENIXSBzY2hl
ZDogZmFub3RpZnk6IERlYWwgd2l0aCBuZXN0ZWQgc2xlZXBzCgotLS0KIGZzL25vdGlmeS9mYW5v
dGlmeS9mYW5vdGlmeV91c2VyLmMgfCA5ICsrKysrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDUgaW5z
ZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9ub3RpZnkvZmFub3Rp
ZnkvZmFub3RpZnlfdXNlci5jIGIvZnMvbm90aWZ5L2Zhbm90aWZ5L2Zhbm90aWZ5X3VzZXIuYwpp
bmRleCBjOTkxNjE2Li42NWU5NmUyIDEwMDY0NAotLS0gYS9mcy9ub3RpZnkvZmFub3RpZnkvZmFu
b3RpZnlfdXNlci5jCisrKyBiL2ZzL25vdGlmeS9mYW5vdGlmeS9mYW5vdGlmeV91c2VyLmMKQEAg
LTE0LDYgKzE0LDcgQEAKICNpbmNsdWRlIDxsaW51eC90eXBlcy5oPgogI2luY2x1ZGUgPGxpbnV4
L3VhY2Nlc3MuaD4KICNpbmNsdWRlIDxsaW51eC9jb21wYXQuaD4KKyNpbmNsdWRlIDxsaW51eC93
YWl0Lmg+CiAKICNpbmNsdWRlIDxhc20vaW9jdGxzLmg+CiAKQEAgLTI1OSwxNSArMjYwLDE1IEBA
IHN0YXRpYyBzc2l6ZV90IGZhbm90aWZ5X3JlYWQoc3RydWN0IGZpbGUgKmZpbGUsIGNoYXIgX191
c2VyICpidWYsCiAJc3RydWN0IGZzbm90aWZ5X2V2ZW50ICprZXZlbnQ7CiAJY2hhciBfX3VzZXIg
KnN0YXJ0OwogCWludCByZXQ7Ci0JREVGSU5FX1dBSVQod2FpdCk7CisJREVGSU5FX1dBSVRfRlVO
Qyh3YWl0LCB3b2tlbl93YWtlX2Z1bmN0aW9uKTsKIAogCXN0YXJ0ID0gYnVmOwogCWdyb3VwID0g
ZmlsZS0+cHJpdmF0ZV9kYXRhOwogCiAJcHJfZGVidWcoIiVzOiBncm91cD0lcFxuIiwgX19mdW5j
X18sIGdyb3VwKTsKIAorCWFkZF93YWl0X3F1ZXVlKCZncm91cC0+bm90aWZpY2F0aW9uX3dhaXRx
LCAmd2FpdCk7CiAJd2hpbGUgKDEpIHsKLQkJcHJlcGFyZV90b193YWl0KCZncm91cC0+bm90aWZp
Y2F0aW9uX3dhaXRxLCAmd2FpdCwgVEFTS19JTlRFUlJVUFRJQkxFKTsKIAogCQltdXRleF9sb2Nr
KCZncm91cC0+bm90aWZpY2F0aW9uX211dGV4KTsKIAkJa2V2ZW50ID0gZ2V0X29uZV9ldmVudChn
cm91cCwgY291bnQpOwpAQCAtMjg5LDcgKzI5MCw3IEBAIHN0YXRpYyBzc2l6ZV90IGZhbm90aWZ5
X3JlYWQoc3RydWN0IGZpbGUgKmZpbGUsIGNoYXIgX191c2VyICpidWYsCiAKIAkJCWlmIChzdGFy
dCAhPSBidWYpCiAJCQkJYnJlYWs7Ci0JCQlzY2hlZHVsZSgpOworCQkJd2FpdF93b2tlbigmd2Fp
dCwgVEFTS19JTlRFUlJVUFRJQkxFLCBNQVhfU0NIRURVTEVfVElNRU9VVCk7CiAJCQljb250aW51
ZTsKIAkJfQogCkBAIC0zMTgsOCArMzE5LDggQEAgc3RhdGljIHNzaXplX3QgZmFub3RpZnlfcmVh
ZChzdHJ1Y3QgZmlsZSAqZmlsZSwgY2hhciBfX3VzZXIgKmJ1ZiwKIAkJYnVmICs9IHJldDsKIAkJ
Y291bnQgLT0gcmV0OwogCX0KKwlyZW1vdmVfd2FpdF9xdWV1ZSgmZ3JvdXAtPm5vdGlmaWNhdGlv
bl93YWl0cSwgJndhaXQpOwogCi0JZmluaXNoX3dhaXQoJmdyb3VwLT5ub3RpZmljYXRpb25fd2Fp
dHEsICZ3YWl0KTsKIAlpZiAoc3RhcnQgIT0gYnVmICYmIHJldCAhPSAtRUZBVUxUKQogCQlyZXQg
PSBidWYgLSBzdGFydDsKIAlyZXR1cm4gcmV0OwotLSAKMi4yLjEKCg==
--047d7bb039469387f3050bf88344--
