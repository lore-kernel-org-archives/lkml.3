Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbaETX6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 19:58:03 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:32973 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaETX6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 19:58:01 -0400
Date: Tue, 20 May 2014 16:57:56 -0700
From: josh@joshtriplett.org
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Manu Gupta <manugupt1@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8188eu: os_dep: usb_intf.c:  Fix for
 possible null pointer dereference
Message-ID: <20140520235756.GA23550@cloud>
References: <1400621477-7603-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <537BE4BB.4010308@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537BE4BB.4010308@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 06:26:51PM -0500, Larry Finger wrote:
> On 05/20/2014 04:31 PM, Rickard Strandqvist wrote:
> >There is otherwise a risk of a possible null pointer dereference.
> >
> >Was largely found by using a static code analysis program called cppcheck.
> >
> >Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> >---
> >  drivers/staging/rtl8188eu/os_dep/usb_intf.c |  127 ++++++++++++++-------------
> >  1 file changed, 66 insertions(+), 61 deletions(-)
> 
> Although cppcheck's analysis is correct, pointer padapter can never
> be null in any of these routines. In routine rtw_drv_init(),
> rtw_usb_if1_init() is called to allocate memory for struct adapter
> for the driver. If that fails, none of these other routines will
> ever be called as the driver will not be loaded.
> 
> If it is deemed better to fill the code with needless tests because
> some static checker points out a place like this, that is OK with
> me, but I do not see the point.

If it's an invariant of the code that padapter cannot ever be NULL, then
that seems perfectly fine to rely on, and the tool just needs fixing or
silencing.  At most, it might be helpful to add annotations like GCC's
"nonnull", if that helps the checker and the compiler generate more
useful warnings.

- Josh Triplett
