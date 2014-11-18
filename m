Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaKRCvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 21:51:54 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:49706 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaKRCvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 21:51:53 -0500
Date: Tue, 18 Nov 2014 02:51:45 +0000
From: "Tobenna Peter, Igwe" <ptigwe@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH] staging:rtl8723au: Fix sparse warning cast to restricted
 __le16
Message-ID: <20141118025144.GA1041@Tobenna-Peter-Igwes-MacBook-Pro.local>
References: <20141118014529.GA937@Tobenna-Peter-Igwes-MacBook-Pro.local>
 <20141118015947.GA21650@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118015947.GA21650@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 05:59:47PM -0800, Greg KH wrote:
> On Tue, Nov 18, 2014 at 01:45:41AM +0000, Tobenna P. Igwe wrote:
> > This patch fixes the following sparse warning:
> > 
> > drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c:343:36: warning:
> > cast to restricted __le16
> > 
> > by using the le16_to_cpus function.
> > 
> > Signed-off-by: Tobenna P. Igwe <ptigwe@gmail.com>
> > ---
> >  drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
> > index d80ea4e..78665ee 100644
> > --- a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
> > +++ b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
> > @@ -340,7 +340,7 @@ static u8 bthci_GetAssocInfo(struct rtw_adapter *padapter, u8 EntryNum)
> >  			tempBuf, TotalLen-BaseMemoryShift);
> >  
> >  		pAmpAsoc = (struct amp_assoc_structure *)tempBuf;
> > -		pAmpAsoc->Length = le16_to_cpu(pAmpAsoc->Length);
> > +		le16_to_cpus(&pAmpAsoc->Length);
> 
> This doesn't change the logic, and you should still have the same
> warning.  How about fixing up Length to be the proper endian type?
> 
> thanks,
> 
> greg k-h

I've checked and sparse doesn't return the warning anymore. Also, I
backtracked through the file and Length seems to be set to its
correct endian type. The reason for the conversion is tempBuf being
an array of 'u8'.

Kind Regards,
Tobenna P. Igwe
