Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab3IBFZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 01:25:40 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:45029 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab3IBFZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 01:25:39 -0400
Subject: Re: [PATCH 0/10] Add additional security checks when module
 loading is restricted
From: joeyli <jlee@suse.com>
To: Kees Cook <keescook@chromium.org>
Cc: Lenny Szubowicz <lszubowi@redhat.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>
In-Reply-To: <CAGXu5jKQtx1OEn8qT8+LgHL+xFgK_pHGrxtdwFfKT1q3FHhaNg@mail.gmail.com>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
	 <1241952070.8587861.1377729463830.JavaMail.root@redhat.com>
	 <1377729714.27493.2.camel@x230>
	 <761791749.8594444.1377730692707.JavaMail.root@redhat.com>
	 <CAGXu5jKQtx1OEn8qT8+LgHL+xFgK_pHGrxtdwFfKT1q3FHhaNg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Sep 2013 13:22:57 +0800
Message-ID: <1378099377.7080.113.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2013-08-28 於 16:07 -0700，Kees Cook 提到：
> On Wed, Aug 28, 2013 at 3:58 PM, Lenny Szubowicz <lszubowi@redhat.com> wrote:
> >
> >
> > ----- Original Message -----
> >> From: "Matthew Garrett" <matthew.garrett@nebula.com>
> >> To: "Lenny Szubowicz" <lszubowi@redhat.com>
> >> Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, jwboyer@redhat.com, keescook@chromium.org
> >> Sent: Wednesday, August 28, 2013 6:41:55 PM
> >> Subject: Re: [PATCH 0/10] Add additional security checks when module loading is restricted
> >>
> >> On Wed, 2013-08-28 at 18:37 -0400, Lenny Szubowicz wrote:
> >>
> >> > Did you purposely exclude similar checks for hibernate that were covered
> >> > by earlier versions of your patch set?
> >>
> >> Yes, I think it's worth tying it in with the encrypted hibernation
> >> support. The local attack is significantly harder in the hibernation
> >> case - in the face of unknown hardware it basically involves a
> >> pre-generated memory image corresponding to your system or the ability
> >> to force a reboot into an untrusted environment. I think it's probably
> >> more workable to just add a configuration option for forcing encrypted
> >> hibernation when secure boot is in use.
> >>
> >> --
> >> Matthew Garrett <matthew.garrett@nebula.com>
> >
> > I'm root. So I can write anything I want to the swap file that looks
> > like a valid hibernate image but is code of my choosing. I can read
> > anything I need from /dev/mem or /dev/kmem to help me do that.
> > I can then immediately initiate a reboot.
> 
> Strictly speaking, RAM contents are not available via /dev/*mem, even
> to root. However, you can request a suspend image be written, but to
> not enter hibernation. Then modify the image, and request a resume
> from it.
> 
> -Kees
> 

I agreed!

As a userland hibernate tool, it possible trigger kernel to generate a
snapshot image of current memory, read the snapshot, modify and upload
it back to the temporary memory space of snapshot, trigger S4 resume to
restore it.

The signature check of S4 snapshot can prevent this attack because the
patches put the signature of snapshot image to snapshot header. Even
attacker change the signature of header or modified the data page in
snapshot. The modified snapshot image will not pass by signature check.


Thanks a lot!
Joey Lee

