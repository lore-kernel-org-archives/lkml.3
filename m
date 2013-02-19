Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab3BSBdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 20:33:21 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:52345 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591Ab3BSBdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 20:33:19 -0500
Message-ID: <1361237574.3263.20.camel@thor.lan>
Subject: Re: kernel BUG at mm/slub.c:3409, 3.8.0-rc7
From: Peter Hurley <peter@hurleysoftware.com>
To: Christoph Lameter <cl@linux.com>, Denys Fedoryshchenko <denys@visp.net.lb>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, dri-devel@lists.freedesktop.org,
        penberg@kernel.org, mpm@selenic.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Mon, 18 Feb 2013 20:32:54 -0500
In-Reply-To: <0000013cefd3a4bc-f5472b15-2ac5-4898-854a-07c65e81f771-000000@email.amazonses.com>
References: <9699daeed06dc8837f792bfdf486da45@visp.net.lb>
	 <0000013cefd3a4bc-f5472b15-2ac5-4898-854a-07c65e81f771-000000@email.amazonses.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Marcin Slusarz, dri-devel]

On Tue, 2013-02-19 at 00:21 +0000, Christoph Lameter wrote:
> The problem is that the subsystem attempted to call kfree with a pointer
> that was not obtained via a slab allocation.
> 
> On Sat, 16 Feb 2013, Denys Fedoryshchenko wrote:
> 
> > Hi
> >
> > Worked for a while on 3.8.0-rc7, generally it is fine, then suddenly laptop
> > stopped responding to keyboard and mouse.
> > Sure it can be memory corruption by some other module, but maybe not. Worth to
> > report i guess.
> > After reboot checked logs and found this:
> >
> > Feb 16 00:40:17 localhost kernel: [23260.079253] ------------[ cut here
> > ]------------
> > Feb 16 00:40:17 localhost kernel: [23260.079257] kernel BUG at mm/slub.c:3409!
> > Feb 16 00:40:17 localhost kernel: [23260.079259] invalid opcode: 0000 [#1] SMP
> > Feb 16 00:40:17 localhost kernel: [23260.079262] Modules linked in:
> > ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
> > xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle iptable_filter
> > ip_tables tun bridge stp llc nouveau snd_hda_codec_hdmi coretemp kvm_intel

Was there an allocation failure earlier in the log?

Might be this nouveau bug (linux-next at the time was 3.8 now):
https://bugs.freedesktop.org/show_bug.cgi?id=58087

I think this was fixed but neither bug report has a cross reference :(

The original report is here:
https://bugzilla.kernel.org/show_bug.cgi?id=51291

Pekka,
Can you please re-assign the bugzilla #51291 above to DRI? Thanks.

Regards,
Peter Hurley

