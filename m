Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaDWIuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:50:05 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60112 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752520AbaDWIuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:50:00 -0400
X-Sasl-enc: z7g1MWm9JZsu6wnEghhkEkpGaavrZEX0IO325cmsRS1I 1398242999
Message-ID: <53577E96.10106@fastmail.fm>
Date: Wed, 23 Apr 2014 16:49:26 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] staging: gdm72xx: Minor cleanup
References: <532BF9B0.2080008@fastmail.fm> <20140418225229.GA28077@kroah.com> <53534051.2020504@fastmail.fm> <53534116.3040705@fastmail.fm> <20140422093743.GC26890@mwanda> <53570BAA.3080709@fastmail.fm> <20140423080447.GS26890@mwanda>
In-Reply-To: <20140423080447.GS26890@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 04:04 PM, Dan Carpenter wrote:
> On Wed, Apr 23, 2014 at 08:39:06AM +0800, Michalis Pappas wrote:
>> After all patches have been applied, the only remaining issue on the
>> TODO list is to conform to the coding standards.  The remaining issues
>> reported by checkpatch.pl are probably pedantic, so if agreed, that
>> task can be removed from the list too.
> 
> So I did a:
> for i in $(find drivers/staging/gdm72xx/ -name \*.c) ; do ./scripts/checkpatch.pl --strict -f $i 2>&1 ; done | tee err-list
> 

Hi Dan, thanks for looking at this. From the above snippet I realize that I wasn't aware of the strict flag, so significantly less errors were produced.

The issues I was referring to as pedantic are:

WARNING: unchecked sscanf return value
#296: FILE: gdm_wimax.c:296:
+               sscanf(e->dev->name, "wm%d", &idx);

does this really need to be checked?

ERROR: Macros with complex values should be enclosed in parenthesis
#34: FILE: usb_ids.h:34:
+#define USB_DEVICE_BOOTLOADER(vid, pid)	\
+	{USB_DEVICE((vid), ((pid)&BL_PID_MASK)|B_DOWNLOAD)},	\
+	{USB_DEVICE((vid), ((pid)&BL_PID_MASK)|B_DOWNLOAD|B_DIFF_DL_DRV)}

these macros are only used for brevity in a subsequent array declaration, so it seems that the parenthesis are not really needed.

Moreover, due to recent commits on checkpatch.pl, a few more issues are now reported, even when not using the strict flag. In any case, I can re-run using strict and submit an additional set of patches for the remaining issues.

Regards,

Michalis

