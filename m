Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaEUHZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 03:25:35 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48964 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaEUHZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 03:25:34 -0400
Date: Wed, 21 May 2014 10:24:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: josh@joshtriplett.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Manu Gupta <manugupt1@gmail.com>
Subject: Re: [PATCH] staging: rtl8188eu: os_dep: usb_intf.c:  Fix for
 possible null pointer dereference
Message-ID: <20140521072450.GT15585@mwanda>
References: <1400621477-7603-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <537BE4BB.4010308@lwfinger.net>
 <20140520235756.GA23550@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520235756.GA23550@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 04:57:56PM -0700, josh@joshtriplett.org wrote:
> On Tue, May 20, 2014 at 06:26:51PM -0500, Larry Finger wrote:
> > On 05/20/2014 04:31 PM, Rickard Strandqvist wrote:
> > >There is otherwise a risk of a possible null pointer dereference.
> > >
> > >Was largely found by using a static code analysis program called cppcheck.
> > >
> > >Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> > >---
> > >  drivers/staging/rtl8188eu/os_dep/usb_intf.c |  127 ++++++++++++++-------------
> > >  1 file changed, 66 insertions(+), 61 deletions(-)
> > 
> > Although cppcheck's analysis is correct, pointer padapter can never
> > be null in any of these routines. In routine rtw_drv_init(),
> > rtw_usb_if1_init() is called to allocate memory for struct adapter
> > for the driver. If that fails, none of these other routines will
> > ever be called as the driver will not be loaded.
> > 
> > If it is deemed better to fill the code with needless tests because
> > some static checker points out a place like this, that is OK with
> > me, but I do not see the point.
> 
> If it's an invariant of the code that padapter cannot ever be NULL, then
> that seems perfectly fine to rely on, and the tool just needs fixing or
> silencing.  At most, it might be helpful to add annotations like GCC's
> "nonnull", if that helps the checker and the compiler generate more
> useful warnings.

The tool is complaining that the existing checks for NULL don't make
sense.  Rickard changed them to cover all the dereferences but really we
should just remove the checks.

Btw, speaking of GCC, it now silently removes inconsistent NULL
checking.  It takes the opposite of the normall kernel programmer
approach of adding checks everywhere.  :P  The glibc people recently
annotated qsort() to say that the function pointer can't be NULL even
though this "worked" in the past.  Hillarity!

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61236

regards,
dan carpenter

