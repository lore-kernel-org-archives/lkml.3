Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaBCUd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 15:33:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48677 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaBCUd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 15:33:26 -0500
Date: Mon, 3 Feb 2014 21:33:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH -v2] x86, microcode, AMD: Sanity-check initrd image
Message-ID: <20140203203323.GG4281@pd.tnic>
References: <20140128232219.GO815@pd.tnic>
 <20140130151321.GC23342@pd.tnic>
 <52EAAAD5.2010301@oracle.com>
 <20140130195413.GH23342@pd.tnic>
 <20140203175526.GB4281@pd.tnic>
 <52EFEA57.4000709@oracle.com>
 <20140203193000.GD4281@pd.tnic>
 <52EFEFFE.6010608@oracle.com>
 <20140203195212.GF4281@pd.tnic>
 <52EFFC03.8070701@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52EFFC03.8070701@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 03:28:51PM -0500, Boris Ostrovsky wrote:
> On 02/03/2014 02:52 PM, Borislav Petkov wrote:
> >On Mon, Feb 03, 2014 at 02:37:34PM -0500, Boris Ostrovsky wrote:
> >>It exploded when 'if (!container)' check was done *after* relocation,
> >>which made container non-zero. If you do the check *before* then I
> >>think you will catch the fact that container is empty.
> >Ah, right, this was it.
> >
> >Ok, just remove the signature check then and give it a try pls:
> 
> Yes, this fixes the bug. And it loads microcode for a good binary.
> 
> For these two patches:
> Tested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> 
> (You might want to rename the final patch to something else since
> you are not checking the blob anymore).

Yes, will do. It'll be one patch though - it is still small enough. I'll
send it as a reply to this message.

Thanks for your help!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
