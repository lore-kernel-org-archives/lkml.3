Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaBCTaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:30:06 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36233 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbaBCTaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:30:04 -0500
Date: Mon, 3 Feb 2014 20:30:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH -v2] x86, microcode, AMD: Sanity-check initrd image
Message-ID: <20140203193000.GD4281@pd.tnic>
References: <52E81B90.8040604@oracle.com>
 <20140128213030.GM815@pd.tnic>
 <52E8230F.7080300@oracle.com>
 <52E83903.5040908@oracle.com>
 <20140128232219.GO815@pd.tnic>
 <20140130151321.GC23342@pd.tnic>
 <52EAAAD5.2010301@oracle.com>
 <20140130195413.GH23342@pd.tnic>
 <20140203175526.GB4281@pd.tnic>
 <52EFEA57.4000709@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52EFEA57.4000709@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 02:13:27PM -0500, Boris Ostrovsky wrote:
> I thought that it may be sufficient to check for !container in
> save_microcode_in_initrd_amd() before performing relocation. If the
> signature was wrong, we would have found out about it in
> load_ucode_bsp() -> apply_ucode_in_initrd() and returned right away,

Your original test case which exploded had exactly that scenario - it
was pointing to Intel ucode so container wasn't NULL. Thus we need to
check the sig in find_ucode_in_initrd().

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
