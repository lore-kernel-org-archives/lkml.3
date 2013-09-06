Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984Ab3IFQLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:11:24 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:38371 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410Ab3IFQLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:11:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130905195802.GA9260@quack.suse.cz>
References: <20130905195802.GA9260@quack.suse.cz>
Date: Fri, 6 Sep 2013 09:11:18 -0700
X-Google-Sender-Auth: ZN0T0DiN0_1lTOzq3sI9eWQhWLc
Message-ID: <CA+55aFytAMNADORn4FfUO620OvLdiMRNVhYbVuCFnWgo4kpvjQ@mail.gmail.com>
Subject: Re: [GIT PULL] Ext3, reiserfs, udf & isofs fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 12:58 PM, Jan Kara <jack@suse.cz> wrote:
>
> udf/isofs changes to refuse mounting fs rw instead of mounting it
> ro automatically which makes eject button work as expected for all media (see
> the changelog for why userspace should be ok with this change).

Pulled. However, these are kind of odd.

For trying _remount_ something read-only, isofs returns the logical
EROFS error code.

But for trying to mount it in the first place, it returns EACCES,
which sounds insane. It's not a permission problem - no amount of
permissions will ever make it work.

UDF always does EACCES, regardless of mount/remount.

Is there some fundamental reason for the insane error code? Does user
space do the wrong thing if we were to just always return "EROFS"
which makes much more sense?

                 Linus
