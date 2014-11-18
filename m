Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaKREIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 23:08:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaKREIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 23:08:10 -0500
Date: Mon, 17 Nov 2014 20:06:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Tobenna Peter, Igwe" <ptigwe@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH] staging:rtl8723au: Fix sparse warning cast to restricted
 __le16
Message-ID: <20141118040651.GA5130@kroah.com>
References: <20141118014529.GA937@Tobenna-Peter-Igwes-MacBook-Pro.local>
 <20141118015947.GA21650@kroah.com>
 <20141118025144.GA1041@Tobenna-Peter-Igwes-MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118025144.GA1041@Tobenna-Peter-Igwes-MacBook-Pro.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 02:51:45AM +0000, Tobenna Peter, Igwe wrote:
> On Mon, Nov 17, 2014 at 05:59:47PM -0800, Greg KH wrote:
> > On Tue, Nov 18, 2014 at 01:45:41AM +0000, Tobenna P. Igwe wrote:
> > > This patch fixes the following sparse warning:
> > > 
> > > drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c:343:36: warning:
> > > cast to restricted __le16
> > > 
> > > by using the le16_to_cpus function.
> > > 
> > > Signed-off-by: Tobenna P. Igwe <ptigwe@gmail.com>
> > > ---
> > >  drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
> > > index d80ea4e..78665ee 100644
> > > --- a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
> > > +++ b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
> > > @@ -340,7 +340,7 @@ static u8 bthci_GetAssocInfo(struct rtw_adapter *padapter, u8 EntryNum)
> > >  			tempBuf, TotalLen-BaseMemoryShift);
> > >  
> > >  		pAmpAsoc = (struct amp_assoc_structure *)tempBuf;
> > > -		pAmpAsoc->Length = le16_to_cpu(pAmpAsoc->Length);
> > > +		le16_to_cpus(&pAmpAsoc->Length);
> > 
> > This doesn't change the logic, and you should still have the same
> > warning.  How about fixing up Length to be the proper endian type?
> > 
> > thanks,
> > 
> > greg k-h
> 
> I've checked and sparse doesn't return the warning anymore. Also, I
> backtracked through the file and Length seems to be set to its
> correct endian type. The reason for the conversion is tempBuf being
> an array of 'u8'.

Ah, that makes sense, ok, I'll queue this up in a few days when I get a
chance.

thanks,

greg k-h
