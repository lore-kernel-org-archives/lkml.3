Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaKEFYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 00:24:34 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:46917 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702AbaKEFYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 00:24:32 -0500
Date: Wed, 5 Nov 2014 10:53:35 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "pmladek@suse.cz" <pmladek@suse.cz>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "peter.chen@freescale.com" <peter.chen@freescale.com>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [Regression][v3.17][v3.18]   USB: Fix persist resume of some SS
 USB devices
Message-ID: <20141105052335.GB2517@pratyush-vbox>
References: <54595116.1050802@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <54595116.1050802@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-05_03:2014-11-04,2014-11-05,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joe,

On Wed, Nov 05, 2014 at 06:20:06AM +0800, Joseph Salisbury wrote:
> Hello Pratyush,
> 
> A kernel bug report was opened against Ubuntu [0].  After a kernel
> bisect, it was found that reverting the following commit resolved this bug:
> 
> commit a40178b2fa6ad87670fb1e5fa4024db00c149629
> Author: Pratyush Anand <pratyush.anand@st.com>
> Date:   Fri Jul 18 12:37:10 2014 +0530
> 
>     USB: Fix persist resume of some SS USB devices
> 
> The regression was introduced as of v3.17-rc1.  The regression still
> exists in the 3.18-rc3 mainline kernel, and has made it's way into the
> stable kernels.

Its strange, as per my understanding patch does not introduce any side
effect for devices whose resume time is normal. So, if a device is
connected to the SS port and it was working after resume from
suspend to ram without this patch, then that device should still work
with this patch.

Infact this has resolved another bug reported to bugzilla
https://bugzilla.kernel.org/show_bug.cgi?id=53211


> 
> I was hoping to get your feedback, since you are the patch author.  Do
> you think gathering any additional data will help diagnose this issue,

Yaa, sure additional info will help to understand the issue.
-- dmesg log of suspend resume when this patch is not applied and also
when applied.
-- dmesg log with following additional debug print.
@@ -3318,6 +3318,7 @@ static int wait_for_ss_port_enable(struct usb_device *udev,
        int status = 0, delay_ms = 0;
         
        while (delay_ms < 2000) {
+               printk("%s:portstatus is %x and portchange is %x\n", __func__, *portstatus, *portchange);
               if (status || *portstatus & USB_PORT_STAT_CONNECTION)
                        break;

> or would it be best to submit a revert request?

Let me see what is the portstatus value and why didn't it break loop in first
iteration if device was OK.

Regards
Pratyush

>    
> 
> Thanks,
>    
> Joe
> 
> [0] http://pad.lv/1384041
