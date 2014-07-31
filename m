Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbaGaAFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:05:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaGaAFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:05:09 -0400
Date: Wed, 30 Jul 2014 17:04:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Fernando =?iso-8859-1?Q?Apestegu=EDa?= 
	<fernando.apesteguia@gmail.com>
Cc: Guillaume Clement <gclement@baobob.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vt6655: staticfy variable
Message-ID: <20140731000440.GA17081@kroah.com>
References: <20140730191638.GA5493@pleinair.baobob.org>
 <CAGwOe2Yhd896GWU=2j2dw+PFgCS1mmP+vkZaoLKed54zi7US2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGwOe2Yhd896GWU=2j2dw+PFgCS1mmP+vkZaoLKed54zi7US2Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 11:20:49PM +0200, Fernando Apesteguía wrote:
> On Wed, Jul 30, 2014 at 9:16 PM, Guillaume Clement <gclement@baobob.org> wrote:
> > Hello,
> >
> >> Add static to variable.
> >> Signed-off-by: Fernando Apesteguia <fernando.apesteguia@gmail.com>
> >> ---
> >>  drivers/staging/vt6655/ioctl.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/staging/vt6655/ioctl.c
> >> b/drivers/staging/vt6655/ioctl.c
> >> index 65e5933..cc6e47b 100644
> >> --- a/drivers/staging/vt6655/ioctl.c
> >> +++ b/drivers/staging/vt6655/ioctl.c
> >> @@ -41,7 +41,7 @@
> >>  static int msglevel = MSG_LEVEL_INFO;
> >>
> >>  #ifdef WPA_SM_Transtatus
> >> -SWPAResult wpa_Result;
> >> +static SWPAResult wpa_Result;
> >>  #endif
> >
> > This changes breaks the compilation (actually the linking). wpa_Result
> > is actually used in device_main.c in device_open with the following:
> 
> Argh... sorry, I missed that.

ALWAYS test-build your patches, don't make me be your first tester...
