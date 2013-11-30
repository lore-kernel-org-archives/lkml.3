Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab3K3Lcd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 06:32:33 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34744 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab3K3Lcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 06:32:31 -0500
Date: Sat, 30 Nov 2013 12:32:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Levente Kurusa <levex@linux.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, EDAC <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mcheck: call put_device on device_register failure
Message-ID: <20131130113229.GD4323@pd.tnic>
References: <5298F900.9000208@linux.com>
 <20131129205628.GA20144@pd.tnic>
 <52999419.7040600@linux.com>
 <20131130111214.GB4323@pd.tnic>
 <5299CB38.8090808@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5299CB38.8090808@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 30, 2013 at 12:25:44PM +0100, Levente Kurusa wrote:
> Now this tree makes me wonder if there are devices where the author
> forgot to set a device_release or when the put_device is not called. I
> will take a look into this.

kobject_cleanup() warns about !t->release already.

If you want to fix actual issues and not waste time with potential
issues which have never actually triggered, try building a couple of
randconfigs and look at the output :-)

Also, we have "make W=" which gives you even more :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
