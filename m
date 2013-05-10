Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab3EJNu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:50:28 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:60625 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751271Ab3EJNuZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:50:25 -0400
From: Stephen GALLIMORE <stephen.gallimore@st.com>
To: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Stuart MENEFY <stuart.menefy@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Date: Fri, 10 May 2013 15:50:16 +0200
Subject: RE: [RFC 1/8] serial:st-asc: Add ST ASC driver.
Thread-Topic: [RFC 1/8] serial:st-asc: Add ST ASC driver.
Thread-Index: Ac5MAZt6GB2onu7ySGeL3ypSBxqboQAAQQRQAF/KzsA=
Message-ID: <A3BF01DB4A606149A4C20C4C4C808F6C3189F9A245@SAFEX1MAIL1.st.com>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
 <1368022248-2153-1-git-send-email-srinivas.kandagatla@st.com>
 <201305081634.43498.arnd@arndb.de> <20130508153459.GA17186@kroah.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Wed, May 08, 2013 at 04:34:43PM +0200, Arnd Bergmann wrote:
> > > +#define ASC_MAJOR		204
> > > +#define ASC_MINOR_START		40
> > 
> > I don't know what the current policy is on allocating major/minor 
> > numbers, but I'm sure you cannot just reuse one that is already used.
>
> First, our apologies, this issue was raised internally and then got forgotten about, there's always something I guess.
> 
> > >I agree, why are you trying to create a new tty device name?  Can't 
> > >you use the existing ttyS name and minor number as you will not have any other type of serial device on this system?
>
> That is an interesting question Greg; I believe it probably stems from historic ST SoCs that had two different types of serial devices,
> something that is no longer the case. We will review our approach to this again, although we are not sure we can use the
> existing ttyS major/minor (even if that is an acceptable thing to do) because of the (remote) possibility of someone using 
> a standard PCIe attached serial card.

Greg, having looked at this we have concluded that we should just go dynamic, as others have mentioned with udev on a full system
or devtmpfs on a minimal initramfs system there is no reason to use a static major/minor. However the view here is that we
would prefer to keep the unique name, as for example the lantiq driver which is also dynamic does, for the reason previously
mentioned regarding PCIe cards.

Is that acceptable?

Regards,
-stephen
