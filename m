Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab3IOS26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 14:28:58 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:65268 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab3IOS24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 14:28:56 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130914233903.GD3444@free.fr>
References: <CA+icZUUkJgeUaJmNzAZQysV9dUHzwPzU7k3pn8vrThSD780xaQ@mail.gmail.com>
	<CACW0xKV-jh2Zfz1-s0xX-NxYBixEF8Hf90jEbo0oouFE18CdyQ@mail.gmail.com>
	<CA+icZUW6Z+exg9wm_up3wta9qX6Wp5WUZa-n+1q8a98-Kt-7Zg@mail.gmail.com>
	<20130914233903.GD3444@free.fr>
Date: Sun, 15 Sep 2013 20:28:54 +0200
Message-ID: <CA+icZUXihARzNZPPHw8X+-xpwxumKBBHcPSPL4hUM1mRSQ9DaQ@mail.gmail.com>
Subject: Re: scripts/config: fix variable substitution command
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: =?UTF-8?Q?Cl=C3=A9ment_Chauplannaz?= <chauplac@gmail.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thorsten Glaser <tg@mirbsd.de>
Content-Type: multipart/mixed; boundary=f46d043c7c5699f29c04e67042f3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d043c7c5699f29c04e67042f3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 15, 2013 at 1:39 AM, Yann E. MORIN <yann.morin.1998@free.fr> wr=
ote:
> Sedat, All,
>
> On 2013-09-14 16:43 +0200, Sedat Dilek spake thusly:
>> On Sat, Sep 14, 2013 at 4:21 PM, Cl=C3=A9ment Chauplannaz <chauplac@gmai=
l.com> wrote:
>> > 2013/9/14 Sedat Dilek <sedat.dilek@gmail.com>:
> [--SNIP--]
>> >> So, can you point me/us to the correct commit with subject, please?!
>> >
>> > My apologies for that mistake. The initial commit, as present in Linus=
 tree, is:
>> > 83e8b90e1d2cc5ff5d2443f2486c2d786a4997ce - scripts/config: use sed's
>> > POSIX interface
>> >
>> > Thus, the commit message for this patch should read:
>> > scripts/config: fix variable substitution command
>> >
>> > Commit 83e8b90e1d2cc5ff5d2443f2486c2d786a4997ce ("scripts/config: use =
sed's
>> > POSIX interface") accidentally changed the separator between sed `s' c=
ommand
>> > and its parameters from ':' to '/'.
>> >
>> > Revert this change.
>> >
>> > Reported-and-tested-by: Linus Walleij <linus.walleij@linaro.org>
>> > Signed-off-by: Clement Chauplannaz <chauplac@gmail.com>
>> > Signed-off-by: Michal Marek <mmarek@suse.cz>
>> >
>>
>> What means "pending" [1]?
>
> The current script had a latent bug that would trigger when the user want
> to set a string that contains a colon ':'.
>
> This behaviour was changed by Cl=C3=A9ment, and the bug was then about st=
rings
> with a '/' instead. This was a regression for some users.
>
> The behaviour was then reverted to break on strings containing ':'.
>
> What is pending is a final fix that will fix both cases.
>
>> Pending in sense of "we are working on it" or in the sense of
>> "exists-but-not-published".
>
> The final fix is trivial and identified, so I guess that Cl=C3=A9ment has=
 yet
> had time to send the patch.
>
>> I did not found a hint on the offline linux-kbuild ML.
>
> That would be Michal's suggestion there:
>     http://marc.info/?l=3Dlinux-kbuild&m=3D137907001305533&w=3D2
>

I talked with Thorsten (MirBSD and Debian developer) and he suggested:

$ sed -e "s^A$before^A$after^A" "$infile" >"$tmpfile" <--- see
attached Text-File

NOTE: Control character "^A" <--- ASCII 0x01 aka SOH (Start Of Heading)

- Sedat -

P.S.: Note2myself: vi/vim: Insert-mode: Ctrl-v Ctrl-a

>> BTW, the GIT repo of Yann is not browsable (which is sh*t for checking
>> commits quickl, I don't want to be forced to checkout).
>
> Yes, I know about that one. I've already notified the gitorious guys
> about the issue, they supposedly fixed it, but it is broken again.
>
> I will re-open my ticket in a moment.
>
> Regards,
> Yann E. MORIN.
>
> --
> .-----------------.--------------------.------------------.--------------=
------.
> |  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspi=
racy: |
> | +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___         =
      |
> | +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There i=
s no  |
> | http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspir=
acy.  |
> '------------------------------^-------^------------------^--------------=
------'

--f46d043c7c5699f29c04e67042f3
Content-Type: application/octet-stream; name=Text-File
Content-Disposition: attachment; filename=Text-File
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hlmlc8aw0

c2VkIC1lICJzASRiZWZvcmUBJGFmdGVyASIgIiRpbmZpbGUiID4iJHRtcGZpbGUiCg==
--f46d043c7c5699f29c04e67042f3--
