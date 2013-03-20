Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab3CTPXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:23:30 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:57337 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab3CTPX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:23:29 -0400
Message-ID: <5149D467.7030908@gmail.com>
Date: Wed, 20 Mar 2013 19:23:19 +0400
From: Lijo Antony <lijo.kernel@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Borislav Petkov <bp@alien8.de>, Ben Skeggs <bskeggs@redhat.com>,
        Lucas Stach <dev@lynxeye.de>, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@linux.ie>
Subject: Re: [Nouveau] nouveau lockdep splat
References: <20130304211608.GD22274@pd.tnic>  <1362501052.1933.2.camel@antimon> <20130319202432.GC4570@pd.tnic> <1363725620.3413.29.camel@thor.lan> <5149589D.6090403@gmail.com>
In-Reply-To: <5149589D.6090403@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 10:35 AM, Lijo Antony wrote:
> I think this is same as https://lkml.org/lkml/2013/3/16/143 (btw, git
> bisect in that mail is incorrect). While investigating, I found this
> issue was introduced during 3.9 merge window. For me this comes when I
> connect my TV via HDMI.

FWIW, git bisect gave this log,

git bisect start 'drivers/gpu/'
# good: [e450fcc6669705ef49784080ac6dd8513df37763] drm/tegra: Add list 
of framebuffers to debugfs
git bisect good e450fcc6669705ef49784080ac6dd8513df37763
# bad: [6dbe51c251a327e012439c4772097a13df43c5b8] Linux 3.9-rc1
git bisect bad 6dbe51c251a327e012439c4772097a13df43c5b8
# good: [bab588fcfb6335c767d811a8955979f5440328e0] Merge tag 'soc' of 
git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect good bab588fcfb6335c767d811a8955979f5440328e0
# good: [be88298b0a3f771a4802f20c5e66af74bfd1dff1] drm/tilcdc: only 
build on arm
git bisect good be88298b0a3f771a4802f20c5e66af74bfd1dff1
# bad: [4d53233a36fdda567cd4d080e27e1ee4b669ddd1] drm: don't use 
idr_remove_all()
git bisect bad 4d53233a36fdda567cd4d080e27e1ee4b669ddd1
# good: [9afa3195b96da7d2320ec44d19fbfbded7a15571] Merge branch 
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial
git bisect good 9afa3195b96da7d2320ec44d19fbfbded7a15571
# good: [496ad9aa8ef448058e36ca7a787c61f2e63f0f54] new helper: 
file_inode(file)
git bisect good 496ad9aa8ef448058e36ca7a787c61f2e63f0f54
# bad: [d895cb1af15c04c522a25c79cc429076987c089b] Merge branch 
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect bad d895cb1af15c04c522a25c79cc429076987c089b
# bad: [fffddfd6c8e0c10c42c6e2cc54ba880fcc36ebbb] Merge branch 
'drm-next' of git://people.freedesktop.org/~airlied/linux
git bisect bad fffddfd6c8e0c10c42c6e2cc54ba880fcc36ebbb

-lijo
