Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbaAUPYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 10:24:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbaAUPYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:24:14 -0500
Date: Tue, 21 Jan 2014 10:16:43 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: tvboxspy@gmail.com, gregkh@linuxfoundation.org
Subject: Re: staging: vt6656: device.h Remove typedef enum __device_init_type.
Message-ID: <20140121151643.GA19358@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	tvboxspy@gmail.com, gregkh@linuxfoundation.org
References: <20140121002130.38BFD660F3F@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121002130.38BFD660F3F@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 12:21:30AM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=302433daf47aeb7d21d66e55fb84d6a8fffd4aed
 > Commit:     302433daf47aeb7d21d66e55fb84d6a8fffd4aed
 > Parent:     a72f8beeedc97b776799a1a80c04eb5312980c9b
 > Author:     Malcolm Priestley <tvboxspy@gmail.com>
 > AuthorDate: Sun Nov 3 17:40:51 2013 +0000
 > Committer:  Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 > CommitDate: Mon Nov 11 16:31:00 2013 -0800
 > 
 >     staging: vt6656: device.h Remove typedef enum __device_init_type.
 >     
 >     Since typedef enum __device_init_type is only ever called
 >     in one state.
 >     
 >     Remove the typedef from main_usb.c:device_init_registers and
 >     replace with macro values. The other values may be needed later.
 >     
 >     Apply cold value to sInitCmd.byInitClass.
 >     
 >     Remove if braces and correct formatting within.

 ...

 >  	/* load power table */
 >  	for (ii = 0; ii < 14; ii++) {
 > -            pDevice->abyCCKPwrTbl[ii] = pDevice->abyEEPROM[ii + EEP_OFS_CCK_PWR_TBL];
 > -            if (pDevice->abyCCKPwrTbl[ii] == 0)
 > -                pDevice->abyCCKPwrTbl[ii] = pDevice->byCCKPwr;
 > -            pDevice->abyOFDMPwrTbl[ii] = pDevice->abyEEPROM[ii + EEP_OFS_OFDM_PWR_TBL];
 > -            if (pDevice->abyOFDMPwrTbl[ii] == 0)
 > -                pDevice->abyOFDMPwrTbl[ii] = pDevice->byOFDMPwrG;
 > -        }
 > +		pDevice->abyCCKPwrTbl[ii] =
 > +			pDevice->abyEEPROM[ii + EEP_OFS_CCK_PWR_TBL];
 > +
 > +		if (pDevice->abyCCKPwrTbl[ii] == 0)
 > +			pDevice->abyCCKPwrTbl[ii] = pDevice->byCCKPwr;
 > +			pDevice->abyOFDMPwrTbl[ii] =
 > +				pDevice->abyEEPROM[ii + EEP_OFS_OFDM_PWR_TBL];
 > +		if (pDevice->abyOFDMPwrTbl[ii] == 0)
 > +			pDevice->abyOFDMPwrTbl[ii] = pDevice->byOFDMPwrG;
 > +	}

Wrong indentation of the pDevice->abyOFDMPwrTbl[ii] assignment.
Wrapping this to 80 columns has actually made this less readable imo.

	Dave

