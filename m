Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab3GKXSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 19:18:25 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:51489 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab3GKXSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:18:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130711093928.24490f06@endymion.delvare>
References: <20130711102724.51608a4ace419b6d42591257@canb.auug.org.au>
 <20130711075700.21d8482c@endymion.delvare> <20130711165343.f921e147403570508939f2df@canb.auug.org.au>
 <20130711093928.24490f06@endymion.delvare>
From: Paul Gortmaker <paul.gortmaker@gmail.com>
Date: Thu, 11 Jul 2013 19:17:52 -0400
Message-ID: <CAP=VYLrNH8pZJUPyfZCtLGGQn_ZcBWbNynSHrwYpeKmqqE6Bsg@mail.gmail.com>
Subject: Re: linux-next: rebase of the jdelvare-hwmon quilt series
To: Jean Delvare <khali@linux-fr.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 3:39 AM, Jean Delvare <khali@linux-fr.org> wrote:
> On Thu, 11 Jul 2013 16:53:43 +1000, Stephen Rothwell wrote:
>> On Thu, 11 Jul 2013 07:57:00 +0200 Jean Delvare <khali@linux-fr.org> wrote:
>> > On Thu, 11 Jul 2013 10:27:24 +1000, Stephen Rothwell wrote:
>> > > Why have you just rebased the jdelvare-hwmon series
>> > > (http://khali.linux-fr.org/devel/linux-3/jdelvare-hwmon/)?  You have
>> > > just invalidated your testing and made it likely that Linus will blast
>> > > you if you ask him to pull your patches.  Your whole series was already
>> > > based after v3.10 (i.e. released or rebased after the merge window
>> > > opened), so why move it again?
>> >
>> > I'm quite confused by this complaint of yours. I do not have the
>> > feeling that I rebased anything or invalidated any testing. And I don't
>> > think I did anything different this time from the way I have been
>> > proceeding for years.
>>
>> Probably not, I guess I have been getting more sensitive lately.
>> However, you have changed the base of your quilt series.  This means that
>> you have included more changes from Linus' tree into your tree, thus any
>> testing you have done previously may be invalidated by those changes.
>
> And then what? Linus will end up merging these patches into his
> up-to-date tree anyway. Me staying on an old tree is not going to help
> anything. I am precisely trying to stick to Linus' tree as much as

Actually, the above is not quite true.  It isn't about staying on an _old_
tree, but staying on a baseline that matches where your testing took
place.  This matters when people are trying to track down problems
with git bisect -- since the merge will also record what your baseline
was, and assumes your patches work and were tested on that baseline.

If you rebase to a new baseline, and don't fully re-test there, then the
bisect will most likely point at one of your patches as broken.  Yet, if
you didn't rebase, then all your patches will "pass" bisect test, and the
_merge_ commit will be called the failure -- which tells us that something
new in the tree since your baseline has caused breakage in your
subsystem.  That can be a critical bit of information.

In this merge window, there has already been several examples where
Linus has been annoyed by people changing their baseline last minute.

https://lkml.org/lkml/2013/7/7/86

> possible, precisely to me sure that 1* merging my patches will be a
> trivial operation for Linus and 2* I can detect and fix any build or
> run-time issue before Linus merges my patches.
>
> Isn't linux-next itself rebased on Linus's latest tree every day for
> exactly that reason?
>
>> > I had only 2 hwmon patches for Linus for this merge window:
>> >   hwmon-lm63-drop-redundant-safety.patch
>> >   hwmon-lm90-drop-redundant-safety.patch
>>
>> Yeah, sorry, but I was complaining to several people today.
>>
>> > They have been in
>> > http://khali.linux-fr.org/devel/linux-3/jdelvare-hwmon/ (and thus in
>> > linux-next) continuously since May 19th so I'd say they received pretty
>> > good testing. I did not touch them, I did not even have to refresh them.
>>
>> Actually, those patches only hit linux-next on July 9 (my time), when the
>> were based on v3.10-6005-gd2b4a64.
>
> Hmm, that would mean I forgot to update my public series when I
> accepted them. That's embarrassing and I apologize for that, this
> should not happen. My tree is seeing so little change these days, it
> can stay for weeks without a change, so if I forget to export once, it
> can take long before the omission is repaired.
>
>> Then today you changed the base of
>> your series to v3.10-8587-g496322b and added another patch.
>
> Yes I did. I always do that.

This is the crux of what Stephen is complaining about here.  You do
not want to always be doing this.

>
>> > 3 days ago I added these 2 patches to the hwmon-for-linus branch of my
>> > staging tree:
>> > http://git.kernel.org/cgit/linux/kernel/git/jdelvare/staging.git/log/?h=hwmon-for-linus
>> > and asked Linux to pull from it.
>>
>> Which is probably when they hit linux-next.
>
> I suppose so, yes. Updating my public patch series is a preliminary
> step to preparing my staging tree for Linus to pull from.
>
>> > Yesterday I reviewed a new (trivial) hwmon patch, and I accepted it, so
>> > it was added to http://khali.linux-fr.org/devel/linux-3/jdelvare-hwmon/ as
>> > hwmon-w83792d-update-module-author.patch (and thus went to linux-next.)
>>
>> And I have no problem with maintainers making judgement calls about
>> simple patches during the merge window.
>
> FWIW I would have accepted the patch even if it was not trivial and it
> would have gone in linux-next just the same. The only difference is
> whether I consider the patch for this merge window or only for the next.

The linux-next tree should not see "new" commits during the two week
window of the merge window -- only content for the active merge window
should be in linux-next during the merge window.  Once the rc1 tag has
been completed, then you can add new content.  This has been something
that Stephen broadcasts regularly for each merge window start.

So there is nothing wrong with accepting the patch, but if it isn't destined
for this merge window, then it should not be forwarded to linux-next until
after rc1 gets tagged.

>
> Is there a policy to not include new patches in linux-next during a
> merge window if the patch is for the next merge window? If so I wasn't
> aware of it. I always considered that the earlier a patch gets in
> linux-next, the better.

Yes, see above.

>
>> It all seems a bit trivial when we are talking about 2 patches, but it is
>> the process that is important.
>
> I'm fine respecting any process in place, but at this point I still do
> not understand how what I did is supposed to be wrong or problematic. I
> can't believe you are asking me to not rebase my quilt series on
> Linus's latest kernel tree every now and then, to make sure it still
> applies cleanly. This is exactly what quilt is good for.

This is what you'll get in trouble for.  Here is another example.

http://marc.info/?l=linux-kernel&m=137331580204926&w=2

Unless you have a concrete reason for changing your baseline, and
then retest it there, you shouldn't be changing it.

>
> So please tell me exactly what you expect from me. Was I supposed to
> base my patches on v3.10 rather than following Linus's v3.11
> development tree until I sent my pull request? This would put the
> merging burden on his (and your) shoulders instead of mine, which seems

Yes, if you did the above, you would be fine.  Many times Linus has said
that people should not worry about "protecting" him from merges.  And
if you are really concerned, you can do a local "test-merge" yourself, and
give hints about what he might run into, and even a sample merge on
a separate branch, that he can look at if required.

Hope that helps clarify things,
Paul.
--

> wrong. And if so, what am I supposed to do after Linus has actually
> pulled my changes? What if I need to send a second round of patches
> during the merge window?
>
> Confused,
> --
> Jean Delvare
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
