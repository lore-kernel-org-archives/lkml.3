Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaAMRIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:08:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37862 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbaAMRIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:08:04 -0500
Message-ID: <1389632933.16290.15.camel@tucsk.piliscsaba.szeredi.hu>
Subject: Re: [PATCH 00/11] cross rename v3
From: Miklos Szeredi <mszeredi@suse.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: miklos@szeredi.hu, viro@ZenIV.linux.org.uk,
        linux-security-module@vger.kernel.org, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com,
        zab@redhat.com, jack@suse.cz, luto@amacapital.net
Date: Mon, 13 Jan 2014 18:08:53 +0100
In-Reply-To: <201401132146.BAF65659.QJSOFVOtFHMOFL@I-love.SAKURA.ne.jp>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
	 <201401132146.BAF65659.QJSOFVOtFHMOFL@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-13 at 21:46 +0900, Tetsuo Handa wrote:
> Miklos Szeredi wrote:
> > Please consider for -next (3.14).
> 
> Excuse me, but did you explain to CONFIG_SECURITY_PATH=y users?

No, sorry.

> I don't see changes in TOMOYO and AppArmor directories.
> TOMOYO might want to use new keyword like "file swapname"
> rather than using "file rename" for cross rename operation.

Cross rename (A, B) is equivalent to plain rename(A, B) + plain rename
(B, A) done as a single atomic operation.  If security module allows
both then cross rename is allowed.  If at least one is denied then the
cross rename is denied.

This is prepared for in "[PATCH 06/11] security: add flags to rename
hooks" and actually done in "[PATCH 07/11] vfs: add cross-rename".

Security people are free to implement a explicit security check for
cross rename, but I don't think that is in the scope of this patchset.

Thanks,
Miklos


