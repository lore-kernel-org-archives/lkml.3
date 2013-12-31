Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab3LaLSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 06:18:48 -0500
Received: from s16892447.onlinehome-server.info ([82.165.15.123]:33025 "EHLO
	s16892447.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752630Ab3LaLSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 06:18:46 -0500
X-Greylist: delayed 1217 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Dec 2013 06:18:46 EST
Message-ID: <52C2A2E5.3020100@ilande.co.uk>
Date: Tue, 31 Dec 2013 10:56:37 +0000
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <52C21CE3.3020402@lwfinger.net>
In-Reply-To: <52C21CE3.3020402@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 93.96.132.220
X-SA-Exim-Mail-From: mark.cave-ayland@ilande.co.uk
Subject: Re: Question on compiler warning
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 02:45:44 +0000)
X-SA-Exim-Scanned: Yes (on s16892447.onlinehome-server.info)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/12/13 01:24, Larry Finger wrote:

> In his regular article entitled Build regressions/improvements in
> v3.13-rc6"
> (http://lkml.indiana.edu/hypermail/linux/kernel/1312.3/01550.html),
> Geert Uytterhoeven reports the following warning regression:
>
> + /scratch/kisskb/src/drivers/net/wireless/b43/phy_n.c: warning:
> 'val_addr' may be used uninitialized in this function [-Wuninitialized]:
> => 178:21
>
> This warning does not show up on any of my compilers, and it should not
> as the initialization and usage of that variable both take place in
> conditional branches that are testing exactly the same pointer.

Hi Larry,

Could it be that you don't see the issue the locally because you've got 
different compiler optimisation settings? I've seen a similar bug 
recently on another project where the "may be used uninitialized" 
warning appears with -O0 and -O1 but magically disappears with the 
default -O2 setting (presumably because the optimiser performs some kind 
of inlining/reordering that makes the issue go away).


HTH,

Mark.
