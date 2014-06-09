Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523AbaFIO0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 10:26:04 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:37678 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933439AbaFIO0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 10:26:03 -0400
Date: Mon, 9 Jun 2014 15:25:59 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH] x86/boot: EFI_MIXED should not prohibit loading above 4G
Message-ID: <20140609142559.GE27302@console-pimps.org>
References: <1402140380-15377-1-git-send-email-matt@console-pimps.org>
 <20140609125427.GA16256@redhat.com>
 <CADknwL7Jeh82W3=rEqGqh=37zpqhmMuP1jy+DDq9vb2gQ+9hzg@mail.gmail.com>
 <20140609141512.GA22049@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609141512.GA22049@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun, at 10:15:12AM, Vivek Goyal wrote:
> 
> Ok, thanks. Or I can check whether EFI run time map is there or not. I am
> assuming that efi runtime services are not enabled, then run time map
> will not be there either.

Yes, if runtime services are unavailable then the runtime map will not
be exported.

Now, you can check for the presence of the runtime map from userland but
please don't use that as your check inside the kernel - this is exactly
what efi_enabled() is for.

-- 
Matt Fleming, Intel Open Source Technology Center
