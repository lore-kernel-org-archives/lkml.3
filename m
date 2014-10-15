Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaJOFaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 01:30:03 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:51749 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaJOFaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 01:30:00 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzOuVhvdDActs=AXr7ZvOkHyH-M2rKVun+Q6R0=r50bvg@mail.gmail.com>
References: <alpine.LRH.2.11.1410150158010.29573@namei.org>
	<CA+55aFzOuVhvdDActs=AXr7ZvOkHyH-M2rKVun+Q6R0=r50bvg@mail.gmail.com>
Date: Wed, 15 Oct 2014 07:29:59 +0200
X-Google-Sender-Auth: MWESBhARR1jooKNgprAJLJOJOrU
Message-ID: <CA+55aFwcqHx5W=tFaf0a6gb=1yH-GwARc=R0s2vwm14YBqrfhQ@mail.gmail.com>
Subject: Re: [GIT PULL] SELinux list corruption fix for 3.18
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Morris <jmorris@namei.org>
Cc: LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 7:27 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> No, the log is correct (the log always is, the back-merges can cause
> the trivial *diff* to be broken).

To add some details: the commits in there are

  f6ed66087648 Merge branch 'stable-3.18' of
git://git.infradead.org/users/pcmoore/selinux into f
  7c66bdc72bc3 selinux: fix inode security list corruption
  e7387395a07d selinux: normalize audit log formatting
  8497b78ecc9d selinux: cleanup error reporting in selinux_nlmsg_perm()
  6eb1ddc6bd3f selinux: make the netif cache namespace aware
  5e29532fed21 selinux: register nf hooks with single nf_register_hooks call
  82341ad9b962 selinux: fix a problem with IPv6 traffic denials in
selinux_ip_postroute()
  04e8d6ab1fa6 selinux: Permit bounded transitions under NO_NEW_PRIVS or NOSUID.

and all but the list corruption fix seem to just be duplicate commits
of things I have already gotten elsewhere. Somebody cherry-picking
commits and duplicating them?

So there are more things rotten in this tree than a back-merge.

            Linus
