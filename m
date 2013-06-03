Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061Ab3FCWjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:39:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758824Ab3FCWjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:39:04 -0400
Date: Mon, 3 Jun 2013 15:39:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: Serban Constantinescu <serban.constantinescu@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH v4 3/6] staging: android: binder: fix
 BINDER_SET_MAX_THREADS declaration
Message-ID: <20130603223903.GA16711@kroah.com>
References: <1369217581-16285-1-git-send-email-serban.constantinescu@arm.com>
 <1369217581-16285-4-git-send-email-serban.constantinescu@arm.com>
 <CAMP5XgeBsr63tcHxoMb2D5dJPuetyLnxNVi8_2V0FM69+AwFbQ@mail.gmail.com>
 <20130603150252.GA2334@kroah.com>
 <CAMP5XgdHDv_Lr=CXrD51XTrxq1t=16-OK-Q0Ww79wdgm2QXGtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP5XgdHDv_Lr=CXrD51XTrxq1t=16-OK-Q0Ww79wdgm2QXGtA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 02:44:25PM -0700, Arve Hjønnevåg wrote:
> On Mon, Jun 3, 2013 at 8:02 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Fri, May 31, 2013 at 04:17:34PM -0700, Arve Hjønnevåg wrote:
> >> On Wed, May 22, 2013 at 3:12 AM, Serban Constantinescu
> >> <serban.constantinescu@arm.com> wrote:
> >> > This change will fix the BINDER_SET_MAX_THREADS ioctl to use __u32
> >> > instead of size_t for setting the max threads. Thus using the same
> >> > handler for 32 and 64bit kernels.
> >> >
> >> > This value is stored internally in struct binder_proc and set to 15
> >> > on open_binder() in the libbinder API(thus no need for a 64bit size_t
> >> > on 64bit platforms).
> >> >
> >> > The change does not affect existing 32bit ABI.
> >> >
> >> > Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
> >> > ---
> >> >  drivers/staging/android/binder.h |    2 +-
> >> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >> >
> >> > diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
> >> > index 2f94d16..1761541 100644
> >> > --- a/drivers/staging/android/binder.h
> >> > +++ b/drivers/staging/android/binder.h
> >> > @@ -86,7 +86,7 @@ struct binder_version {
> >> >
> >> >  #define BINDER_WRITE_READ              _IOWR('b', 1, struct binder_write_read)
> >> >  #define        BINDER_SET_IDLE_TIMEOUT         _IOW('b', 3, __s64)
> >> > -#define        BINDER_SET_MAX_THREADS          _IOW('b', 5, size_t)
> >> > +#define        BINDER_SET_MAX_THREADS          _IOW('b', 5, __u32)
> >> >  #define        BINDER_SET_IDLE_PRIORITY        _IOW('b', 6, __s32)
> >> >  #define        BINDER_SET_CONTEXT_MGR          _IOW('b', 7, __s32)
> >> >  #define        BINDER_THREAD_EXIT              _IOW('b', 8, __s32)
> >> > --
> >> > 1.7.9.5
> >> >
> >>
> >> Acked-by: Arve Hjønnevåg <arve@android.com>
> >
> > What about patches 1 and 2 in this series?
> >
> 
> I apparently only responded privately to those. I just resent them.

Thanks for that.  I'll wait for the series to be fixed up and resent
before doing anything with them.

greg k-h
