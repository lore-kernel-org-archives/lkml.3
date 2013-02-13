Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab3BMTOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 14:14:03 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53407 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759057Ab3BMTOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 14:14:01 -0500
Date: Wed, 13 Feb 2013 20:13:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: Scan Subscription <scan-subscription@coverity.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: New Defect(s) reported by Coverity Scan
Message-ID: <20130213191352.GC18013@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Scan Subscription <scan-subscription@coverity.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>,
	David Woodhouse <dwmw2@infradead.org>
References: <C0A4ACBB26D853488EA0C68388B70268172CCF11@BLUPRD0512MB628.namprd05.prod.outlook.com>
 <20130213183842.GC26948@pd.tnic>
 <C0A4ACBB26D853488EA0C68388B70268172CD159@BLUPRD0512MB628.namprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <C0A4ACBB26D853488EA0C68388B70268172CD159@BLUPRD0512MB628.namprd05.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 06:55:03PM +0000, Scan Subscription wrote:
> Hi Boris
> 
> There is no fclose(file) call in parse_zoffset() function
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob_plain;f=arch/x86/boot/tools/build.c;hb=HEAD 
> 
> There is only one flcose call in this file and it is in the main() function
> Let us know if I am missing anything

Right, I was staring at older sources, sorry.

This parse_zoffset() thing has come in just recently with

commit 99f857db8857aff691c51302f93648263ed07eb1
Author: David Woodhouse <David.Woodhouse@intel.com>
Date:   Thu Jan 10 14:31:59 2013 +0000

    x86, build: Dynamically find entry points in compressed startup code

and it might really need fclose() there for correctness' sake.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
