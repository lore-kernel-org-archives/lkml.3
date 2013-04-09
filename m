Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935677Ab3DISy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:54:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57970 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932780Ab3DISyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:54:24 -0400
Date: Tue, 9 Apr 2013 20:52:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, mce: Print warning if MCE handler fails to register
 /dev/mcelog
Message-ID: <20130409185221.GA5077@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Luck, Tony" <tony.luck@intel.com>,
	Khalid Aziz <khalid.aziz@oracle.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1365531571.8447.4.camel@concerto>
 <3908561D78D1C84285E8C5FCA982C28F1EA41C2B@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1EA41C2B@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 06:30:58PM +0000, Luck, Tony wrote:
> -	misc_register(&mce_chrdev_device);
> +	if (misc_register(&mce_chrdev_device) != 0)
> +		pr_warn("Failed to register mcelog device\n");
> 
> Did this actually happen to you?  Or is this just "good practice" to check the
> return value from misc_register?

I'm very sceptical this actually happens - we would've otherwise seen
reports about mcelog not starting correctly.

Hmm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
