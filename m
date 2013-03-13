Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934250Ab3CMU1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:27:25 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:48366 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178Ab3CMU1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:27:24 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+55aFyawa76qCrCXnjYRf=U8xcEwV2UrqNV_J0Z-rVDrSgsHg@mail.gmail.com>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<CA+icZUVLsqXNEc4UTQp0dDG21sQb0xtFMDF9Lyq5Jy7Px0pPBQ@mail.gmail.com>
	<CA+icZUVn=3qcEDchYqUf2JqDBfPsN6Zxh+cJCDbUaOrkjg7uJg@mail.gmail.com>
	<CAJfpegu40UMTfofY0L20T69sqmPrvpCP53N-xzumgX5MrAZuJw@mail.gmail.com>
	<CA+icZUV=XoN=uUn7npU9Djnkr5DEuA0D42=HV_1n6WN4v2rQMA@mail.gmail.com>
	<CA+icZUXXrarmm3hYSxt7T2_sw+pmZycdmop5z4QCJ6=vMny9EQ@mail.gmail.com>
	<CA+icZUXzYGRU7deUyzgNBEfSkZf+-w6VLOewd+7R=RmZ21mTUg@mail.gmail.com>
	<CAJfpegu3cHatcoWYyYeA-w0+mtQUgiAVkqUOjLGrq9oxk7CcrQ@mail.gmail.com>
	<CA+icZUWqd4OfjxBKeOjqaPiVXOvBk9kLu1u1X_hiG9sbz1Eneg@mail.gmail.com>
	<20130313181251.GA6023@sgi.com>
	<5140C77E.7030206@openwrt.org>
	<CA+icZUUPTryfL9S2vHopPTcRkhV=Qxd1w_fh0mWbPrUE7Lw=zQ@mail.gmail.com>
	<87k3pbhy7o.fsf@xmission.com>
	<CA+55aFyawa76qCrCXnjYRf=U8xcEwV2UrqNV_J0Z-rVDrSgsHg@mail.gmail.com>
Date: Wed, 13 Mar 2013 21:27:22 +0100
Message-ID: <CA+icZUUmbik_+WXzhwYSV4X1aj=zT0nyyc76o5ZrYBpxAUp=Mw@mail.gmail.com>
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Felix Fietkau <nbd@openwrt.org>, Robin Holt <holt@sgi.com>,
        Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Neil Brown <neilb@suse.de>,
        Jordi Pujol <jordipujolp@gmail.com>, ezk@fsl.cs.sunysb.edu,
        David Howells <dhowells@redhat.com>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Miklos Szeredi <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 8:58 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Mar 13, 2013 at 12:54 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>>
>>> Hehe, I just checked my new kernel... that does not work (nothing in the logs).
>>> But I think it's good to see if the filesystem is registered/loaded.
>>
>> lsmod | grep overlayfs
>
> How about the compiled-in case? What's wrong with just using the
> obvious /proc/filesystems?
>

As I don't need OverlayFS in my daily life, I have it here built as a module.

Nevertheless, as module or built-in /me as an end-user wants to know
what's going on.
So, dmesg is normally my first weapon.

I grep-ed trrough a bit through all the filesystems in fs/ and it is
not handled unique.

"Loaded" BTW is not the right term in FS-folks-jargon: The functions
are called (un)register_filesystem().

$ dmesg | grep -i loaded
[    0.241037] vgaarb: loaded
[    0.241243] libata version 3.00 loaded.
[    0.358574] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 252)
[    0.368711] brd: module loaded
[    0.369832] loop: module loaded
[    0.650086] PM: Hibernation image not present or could not be loaded.
[    0.651150] Loaded X.509 cert 'Magrathea: Glacier signing key:
e75e3a59e59cb48db975ac12e21a905289ada56f'
[    1.788947] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    8.617549] lp: driver loaded but no devices found
[   10.490721] wmi: Mapper loaded
[   11.994985] iwlwifi 0000:01:00.0: loaded firmware version 18.168.6.1
[   73.885056] squashfs: loaded
[   81.345070] overlayfs: loaded

I am not sure whether those lines "blabla: module loaded" is true for
loop (block) it is a hardcoded printk-line.
I doubt...

CONFIG_BLK_DEV_LOOP=y

Last but not least, user-space apps like GRUB trigger fs loaded.
For me this is helpful.
You might be bored or whatever reason I can't or don't want to understand.

And just to have some fun about status informations:
Check your drm (kms) driver with date and version :-).
Stuff that is not maintained should be thrown out (yes, I had sent patches...).

- Sedat -

>              Linus
