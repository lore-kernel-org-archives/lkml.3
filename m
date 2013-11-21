Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab3KUU67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 15:58:59 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:37230 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3KUU64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 15:58:56 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
        Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthias Schniedermeyer <ms@citd.de>,
        Linux Containers <containers@lists.linux-foundation.org>
References: <87vc15mjuw.fsf@xmission.com>
	<CAJfpegvF89LzAvNB0h0otv7sKoS3rewZzQKAauQx3P+rCkCcSg@mail.gmail.com>
	<87iox38fkv.fsf@xmission.com> <87d2nb8dxy.fsf@xmission.com>
	<87iowyxpci.fsf_-_@xmission.com> <87d2n6xpan.fsf_-_@xmission.com>
	<20131103035406.GA8537@ZenIV.linux.org.uk>
	<87bo1u8vmf.fsf@xmission.com>
	<20131108213551.GR13318@ZenIV.linux.org.uk>
	<87fvr61qtg.fsf@xmission.com> <20131109084916.GA21413@infradead.org>
Date: Thu, 21 Nov 2013 12:58:44 -0800
In-Reply-To: <20131109084916.GA21413@infradead.org> (Christoph Hellwig's
	message of "Sat, 9 Nov 2013 00:49:16 -0800")
Message-ID: <878uwh8oaj.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/+wKr+HnBTwz+0g8rZ/roBuRVE9EeEFyw=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  3.0 XMDrug1234561 Drug references
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1484]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Christoph Hellwig <hch@infradead.org>
X-Spam-Relay-Country: 
Subject: Re: [REVIEW][PATCH 1/4] vfs: Don't allow overwriting mounts in the current mount namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Fri, Nov 08, 2013 at 02:17:31PM -0800, Eric W. Biederman wrote:
>> > Read what you've written a few lines above.  The part about target->i_mutex
>> > being held.
>> 
>> That works for the rename as unlink case but we don't hold
>> old_dentry->d_inode->i_mutex which is what is needed to prevent a mount
>> on the dentry we are renaming.
>
> It will be held in 3.13.

Only for files, not for directories.  And none of those locks turns out
to be good enough today to prevent the races between mount and rename.
With the result that when mount returns your mount point could be
located just about anywhere, and that is just considering renames of the
actual mountpoint itself.

Eric
