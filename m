Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaAMWFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 17:05:14 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:55621 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaAMWFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 17:05:11 -0500
X-Nat-Received: from [202.181.97.72]:62080 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1389650639.10060
To: mszeredi@suse.cz, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org
Cc: miklos@szeredi.hu, viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, dhowells@redhat.com,
        zab@redhat.com, jack@suse.cz, luto@amacapital.net
Subject: Re: [PATCH 00/11] cross rename v3
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
	<201401132146.BAF65659.QJSOFVOtFHMOFL@I-love.SAKURA.ne.jp>
	<1389632933.16290.15.camel@tucsk.piliscsaba.szeredi.hu>
In-Reply-To: <1389632933.16290.15.camel@tucsk.piliscsaba.szeredi.hu>
Message-Id: <201401140703.ICH21836.HMJStQVFOFOLOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 14 Jan 2014 07:03:55 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 13012014 #7320531, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> Cross rename (A, B) is equivalent to plain rename(A, B) + plain rename
> (B, A) done as a single atomic operation.  If security module allows
> both then cross rename is allowed.  If at least one is denied then the
> cross rename is denied.

Yes, the functionality itself is fine. The problem is how LSM users check
their permissions for the functionality.

> 
> This is prepared for in "[PATCH 06/11] security: add flags to rename
> hooks" and actually done in "[PATCH 07/11] vfs: add cross-rename".
> 
> Security people are free to implement a explicit security check for
> cross rename, but I don't think that is in the scope of this patchset.
> 
I don't know how their permissions are checked, but I think that
swapping /A/B and /C/D should check not only

  Remove a name from directory A
  Add a name to directory C

but also

  Add a name to directory A
  Remove a name from directory C

using their security labels.

Without making changes to security/*/ directory, SELinux/SMACK/TOMOYO/AppArmor
might fail to check the latter permissions. Please get confirmation from LSM
people before you merge this change to linux-next tree.
