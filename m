Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760469Ab3BMUQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 15:16:14 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37820 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3BMUQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 15:16:12 -0500
Date: Wed, 13 Feb 2013 21:16:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Goswin von Brederlow <goswin-v-b@web.de>, Li Fei <fei.li@intel.com>,
        len.brown@intel.com, mingo@redhat.com, peterz@infradead.org,
        biao.wang@intel.com, linux-pm@vger.kernel.org,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Subject: Re: Getting rid of freezer for suspend [was Re: [fuse-devel]
 [PATCH] fuse: make fuse daemon frozen along with kernel threads]
Message-ID: <20130213201609.GA4296@amd.pavel.ucw.cz>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <2964781.rPUOipNRNb@vostro.rjw.lan>
 <CAJfpegtNUr+AJXZcKmLEGBYqu20DVFwzg-OvOk_nS3fBS3wd=Q@mail.gmail.com>
 <1660768.prnx6s70rD@vostro.rjw.lan>
 <CAJfpegt2B3n-QNK_W7O2H0JVfS=4jcUOzV_+w8ELPq19RJPewQ@mail.gmail.com>
 <20130212104608.GA24042@amd.pavel.ucw.cz>
 <CAJfpegvdVfEFTU5haMMi94PD1iZ1XyCRjg0O9vDjDg1yyaM-yA@mail.gmail.com>
 <CAJfpegvV0zQ5Lftx=ELP0MAH1-7oY5HfT-CSYEaFUWJLmXoD7A@mail.gmail.com>
 <CAJfpegsFThkzv3uF60AMXO7Y-yEzU_20HeGyPra0O8Vk5OqCGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsFThkzv3uF60AMXO7Y-yEzU_20HeGyPra0O8Vk5OqCGQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-02-13 18:34:16, Miklos Szeredi wrote:
> On Tue, Feb 12, 2013 at 2:17 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > On Tue, Feb 12, 2013 at 2:13 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >> On Tue, Feb 12, 2013 at 11:46 AM, Pavel Machek <pavel@ucw.cz> wrote:
> >>
> >>> (After all, with FUSE, filesystem clients are just doing IPC. In ideal
> >>> world, that would be freezeable and killable with -9).
> 
> Well, I thought this can be constrained to locks directly related to
> the fuse filesystem itself, but it can't...  The reason is page

And it looked so easy and nice...

> faults.  Pretty much everyone and their brother uses get_user_pages*,
> holding various locks (mmap_sem for sure but others as well).  A fuse
> filesystem frozen during a page read will block those.

Is it even valid for get_user_pages to be used on FUSE?

What happens if fused tries to do some operation (it is userspace, it
can do lot of operations) that needs one of those locks?

It seems to me that fused will want to do operations hibernation would
want to do, at the very least (reading/writing block devices). Thus,
if it does not deadlock with fused, it should not deadlock with
hibernation, either...

[Or am i mistaken and FUSE's get_user_pages* needs FUSE locks but does
not wait for fused to finish the operation?]

> Separating those parts of the kernel that can be frozen from those
> that can't looks increasingly difficult.

:-(.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
