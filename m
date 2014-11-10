Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaKJLWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 06:22:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:45531 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbaKJLWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 06:22:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,352,1413270000"; 
   d="scan'208";a="629474462"
Message-ID: <1415618533.14686.239.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] rtc: Disable EFI rtc for x86
From: Matt Fleming <matt.fleming@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Mark Salter <msalter@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Date: Mon, 10 Nov 2014 11:22:13 +0000
In-Reply-To: <20141109182231.GA29337@pd.tnic>
References: <1412339576-17972-1-git-send-email-matt@console-pimps.org>
	 <1412348517.5410.13.camel@deneb.redhat.com> <201411091837.47354@pali>
	 <20141109182231.GA29337@pd.tnic>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [163.33.239.180]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-09 at 19:22 +0100, Borislav Petkov wrote:
> On Sun, Nov 09, 2014 at 06:37:46PM +0100, Pali Rohár wrote:
> > this patch totally disabled efi rfc driver on x86 machines at 
> > compile time. But on some x86 machines it working without crash 
> > and reading from file /sys/class/rtc/rtc*/since_epoch returns 
> > correct information. So why to disable compiling driver on 
> > machines where driver working?
> 
> Sounds like we need an efi=rtc_enable knob for people who what to use
> it...

I'm not so sure. By and large, the EFI runtime Time services just don't
work very well on x86. Just because they work sometimes, doesn't
actually mean it's a good idea to use them.

The one scenario where the time services are useful is early on during
boot when we want to get the timezone information. I have vague
recollections of someone working on that.

