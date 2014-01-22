Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbaAVB5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 20:57:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbaAVB5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 20:57:17 -0500
Date: Tue, 21 Jan 2014 17:57:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tvboxspy@gmail.com
Subject: Re: staging: vt6656: device.h Remove typedef enum __device_init_type.
Message-ID: <20140122015753.GA20560@kroah.com>
References: <20140121002130.38BFD660F3F@gitolite.kernel.org>
 <20140121151643.GA19358@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121151643.GA19358@redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 10:16:43AM -0500, Dave Jones wrote:
> On Tue, Jan 21, 2014 at 12:21:30AM +0000, Linux Kernel wrote:
>  > Gitweb:     http://git.kernel.org/linus/;a=commit;h=302433daf47aeb7d21d66e55fb84d6a8fffd4aed
>  > Commit:     302433daf47aeb7d21d66e55fb84d6a8fffd4aed
>  > Parent:     a72f8beeedc97b776799a1a80c04eb5312980c9b
>  > Author:     Malcolm Priestley <tvboxspy@gmail.com>
>  > AuthorDate: Sun Nov 3 17:40:51 2013 +0000
>  > Committer:  Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>  > CommitDate: Mon Nov 11 16:31:00 2013 -0800
>  > 
>  >     staging: vt6656: device.h Remove typedef enum __device_init_type.
>  >     
>  >     Since typedef enum __device_init_type is only ever called
>  >     in one state.
>  >     
>  >     Remove the typedef from main_usb.c:device_init_registers and
>  >     replace with macro values. The other values may be needed later.
>  >     
>  >     Apply cold value to sInitCmd.byInitClass.
>  >     
>  >     Remove if braces and correct formatting within.
> 
>  ...
> 
>  >  	/* load power table */
>  >  	for (ii = 0; ii < 14; ii++) {
>  > -            pDevice->abyCCKPwrTbl[ii] = pDevice->abyEEPROM[ii + EEP_OFS_CCK_PWR_TBL];
>  > -            if (pDevice->abyCCKPwrTbl[ii] == 0)
>  > -                pDevice->abyCCKPwrTbl[ii] = pDevice->byCCKPwr;
>  > -            pDevice->abyOFDMPwrTbl[ii] = pDevice->abyEEPROM[ii + EEP_OFS_OFDM_PWR_TBL];
>  > -            if (pDevice->abyOFDMPwrTbl[ii] == 0)
>  > -                pDevice->abyOFDMPwrTbl[ii] = pDevice->byOFDMPwrG;
>  > -        }
>  > +		pDevice->abyCCKPwrTbl[ii] =
>  > +			pDevice->abyEEPROM[ii + EEP_OFS_CCK_PWR_TBL];
>  > +
>  > +		if (pDevice->abyCCKPwrTbl[ii] == 0)
>  > +			pDevice->abyCCKPwrTbl[ii] = pDevice->byCCKPwr;
>  > +			pDevice->abyOFDMPwrTbl[ii] =
>  > +				pDevice->abyEEPROM[ii + EEP_OFS_OFDM_PWR_TBL];
>  > +		if (pDevice->abyOFDMPwrTbl[ii] == 0)
>  > +			pDevice->abyOFDMPwrTbl[ii] = pDevice->byOFDMPwrG;
>  > +	}
> 
> Wrong indentation of the pDevice->abyOFDMPwrTbl[ii] assignment.
> Wrapping this to 80 columns has actually made this less readable imo.

Good catch, I'll fix that up after 3.14-rc1 is out, thanks for finding
it.

greg k-h
