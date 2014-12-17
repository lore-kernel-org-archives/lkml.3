Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbaLQOyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 09:54:52 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:42338 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaLQOyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 09:54:50 -0500
Date: Wed, 17 Dec 2014 06:54:46 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [BUG, linux-next] spawn PID 1 without CLONE_FS, wireless inop
Message-ID: <20141217145446.GA3895@newt.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Takashi Iwai <tiwai@suse.de>, Al Viro <viro@ZenIV.linux.org.uk>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20141216125615.GZ22149@ZenIV.linux.org.uk>
 <20141216132821.GA22149@ZenIV.linux.org.uk>
 <20141216140952.GA1224@hudson.localdomain>
 <20141216142542.GC22149@ZenIV.linux.org.uk>
 <20141216144610.GA1219@hudson.localdomain>
 <20141216150518.GD22149@ZenIV.linux.org.uk>
 <20141216152626.GA1228@hudson.localdomain>
 <20141216162716.GE22149@ZenIV.linux.org.uk>
 <20141216200351.GA1126@newt.localdomain>
 <s5h61dabeka.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h61dabeka.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi,

On Wed, Dec 17, 2014 at 02:17:57PM +0100, Takashi Iwai wrote:
> At Tue, 16 Dec 2014 12:03:51 -0800,
> Jeremiah Mahler wrote:
> > 
> > Al Viro,
[...]
> > > 
> > > OK, so the root is on sda6, it's been mounted before those attempts to
> > > load firmware and init has been chrooted into it, while init_fs got left
> > > behind.  And that "chrooted into" has happened without pivot_root(2) (or
> > > it would've been caught by chroot_fs_refs() in sys_pivot_root()) and
> > > not from the "no /init on initramfs" codepath (you do have it there).
> > > 
> > > OK, it's probably unsalvagable, then.  Pity, since it means that PID 1 and
> > > kernel threads _must_ share ->fs, for the sake of usable ->fs->root, which
> > > is asking for trouble.  And it means that we still need a sane solution for
> > > nfsd folks...
> > > 
> > > Anyway, dropped that stuff from for-next (and for-linus, obviously), with
> > > apologies all around.
> > 
> > On a totally different machine, an Acer C720, the sound quit working.
> > I bisected that one and it pointed to this same commit.  However this
> > one doesn't involve loading firmware or any of that stuff.  Attached
> > are the good/bad dmesg logs.
> 
> Did you mean HD-audio stuff?  The bad case shows the error
> 
> [    2.122849] hda-i915: get_power symbol get fail
> [    2.122856] snd_hda_intel 0000:00:03.0: Error request power-well from i915
> 
> This is the place calling request_symbol(), where i915 module should
> have been loaded dynamically but it failed, likely because of the same
> reason as the firmware loading failure.
> 

Ah, perhaps it does load firmware.  Then I am mistaken on that point.

> 
> Takashi

-- 
- Jeremiah Mahler
