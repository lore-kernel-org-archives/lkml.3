Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359AbaFIOKO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 10:10:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43867 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403AbaFIOKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 10:10:10 -0400
Date: Mon, 9 Jun 2014 17:09:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lisa Nguyen <lisa@xenapiadmin.com>, devel@driverdev.osuosl.org,
        Wenliang Fan <fanwlexca@gmail.com>, linux-kernel@vger.kernel.org,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Tugce Sirin <ztugcesirin@gmail.com>, Aldo Iljazi <neonsync1@gmail.com>
Subject: Re: [PATCH] staging: bcm: nvm.c: Cleaning up a array that is filled
 incompletely
Message-ID: <20140609140738.GD5500@mwanda>
References: <1402263928-1961-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1402263928-1961-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402263928-1961-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2014 at 11:45:28PM +0200, Rickard Strandqvist wrote:
> Array 'SigBuff' is filled incompletely.
> Someone forget to multiply for the sizeof type.
> 
> This was partly found using a static code analysis program called cppcheck.
> 

I took a look at code which uses MAX_RW_SIZE and it's really confused
about whether it is in bytes or number of ints.

This code is a real mess.  For example, look at the call to:

			WriteToFlashWithoutSectorErase(Adapter,
                                                       SigBuff,
                                                       eISOWritePart,
                                                       sigOffset,
                                                       MAX_RW_SIZE);

If you look at it, that function says it takes int pointers but really
I think it wants u8 pointers.

I think this is the real fix here, to change
WriteToFlashWithoutSectorErase() to take char pointers and then make the
SigBuff buffer an array of u8.

I think this is the correct way to fix this code, but this driver is
very horrible so I could be wrong.  Please check.

regards,
dan carpenter

PS: These days I add everything to the TODO so we don't forget about it.

TODO-list: 2014-06-09: bcm: make SigBuff in BcmCopyISO() an array of u8.


