Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbaAVTP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:15:28 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36772 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbaAVTP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:15:27 -0500
Message-ID: <1390418113.3540.23.camel@canaries32-MCP7A>
Subject: Re: staging: vt6656: device.h Remove typedef enum
 __device_init_type.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 22 Jan 2014 19:15:13 +0000
In-Reply-To: <1390356108.31946.20.camel@joe-AO722>
References: <20140121002130.38BFD660F3F@gitolite.kernel.org>
	 <20140121151643.GA19358@redhat.com> <20140122015753.GA20560@kroah.com>
	 <1390356108.31946.20.camel@joe-AO722>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-21 at 18:01 -0800, Joe Perches wrote:
> On Tue, 2014-01-21 at 17:57 -0800, Greg KH wrote:
> > On Tue, Jan 21, 2014 at 10:16:43AM -0500, Dave Jones wrote:
> > > On Tue, Jan 21, 2014 at 12:21:30AM +0000, Linux Kernel wrote:
> > >  > Gitweb:     http://git.kernel.org/linus/;a=commit;h=302433daf47aeb7d21d66e55fb84d6a8fffd4aed
> > >  > Commit:     302433daf47aeb7d21d66e55fb84d6a8fffd4aed
> > >  > Parent:     a72f8beeedc97b776799a1a80c04eb5312980c9b
> > >  > Author:     Malcolm Priestley <tvboxspy@gmail.com>
> > >  > AuthorDate: Sun Nov 3 17:40:51 2013 +0000
> > >  > Committer:  Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >  > CommitDate: Mon Nov 11 16:31:00 2013 -0800
> > >  > 
> > >  >     staging: vt6656: device.h Remove typedef enum __device_init_type.
> > >  >     
> > >  >     Since typedef enum __device_init_type is only ever called
> > >  >     in one state.
> > >  >     
> > >  >     Remove the typedef from main_usb.c:device_init_registers and
> > >  >     replace with macro values. The other values may be needed later.
> > >  >     
> > >  >     Apply cold value to sInitCmd.byInitClass.
> > >  >     
> > >  >     Remove if braces and correct formatting within.
> > > 
> > >  ...
> > > 
> > >  >  	/* load power table */
> > >  >  	for (ii = 0; ii < 14; ii++) {
> > >  > -            pDevice->abyCCKPwrTbl[ii] = pDevice->abyEEPROM[ii + EEP_OFS_CCK_PWR_TBL];
> > >  > -            if (pDevice->abyCCKPwrTbl[ii] == 0)
> > >  > -                pDevice->abyCCKPwrTbl[ii] = pDevice->byCCKPwr;
> > >  > -            pDevice->abyOFDMPwrTbl[ii] = pDevice->abyEEPROM[ii + EEP_OFS_OFDM_PWR_TBL];
> > >  > -            if (pDevice->abyOFDMPwrTbl[ii] == 0)
> > >  > -                pDevice->abyOFDMPwrTbl[ii] = pDevice->byOFDMPwrG;
> > >  > -        }
> > >  > +		pDevice->abyCCKPwrTbl[ii] =
> > >  > +			pDevice->abyEEPROM[ii + EEP_OFS_CCK_PWR_TBL];
> > >  > +
> > >  > +		if (pDevice->abyCCKPwrTbl[ii] == 0)
> > >  > +			pDevice->abyCCKPwrTbl[ii] = pDevice->byCCKPwr;
> > >  > +			pDevice->abyOFDMPwrTbl[ii] =
> > >  > +				pDevice->abyEEPROM[ii + EEP_OFS_OFDM_PWR_TBL];
> > >  > +		if (pDevice->abyOFDMPwrTbl[ii] == 0)
> > >  > +			pDevice->abyOFDMPwrTbl[ii] = pDevice->byOFDMPwrG;
> > >  > +	}
> > > 
> > > Wrong indentation of the pDevice->abyOFDMPwrTbl[ii] assignment.
> > > Wrapping this to 80 columns has actually made this less readable imo.
Thanks Dave

> > 
> > Good catch, I'll fix that up after 3.14-rc1 is out, thanks for finding
> > it.
> 
> It'd also be nice to eventually do away with the
> semi-Hungarian notation aby, p, by, etc prefixes
> and camelcase naming.
> 
I am slowly working through it by function.

There is still a lot of dead code.



