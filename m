Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760895AbaGYQqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:46:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35735 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbaGYQqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:46:21 -0400
Date: Fri, 25 Jul 2014 18:46:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 6/8] x86, microcode, intel: total_size is valid only when
 data_size != 0
Message-ID: <20140725164614.GE4421@pd.tnic>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-7-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406146251-8540-7-git-send-email-hmh@hmh.eng.br>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 05:10:49PM -0300, Henrique de Moraes Holschuh wrote:
> According to the Intel SDM vol 3A (order code 253668-051US, June 2014),
> on section 9.11.1, page 9-28:
> 
> "For microcode updates with a data size field equal to 00000000H, the
> size of the microcode update is 2048 bytes. The first 48 bytes contain
> the microcode update header. The remaining 2000 bytes contain encrypted
> data."
> 
> "For microcode updates with a data size not equal to 00000000H, the total
> size field specifies the size of the microcode update"
> 
> We were incorrectly assuming that total_size is valid when it is
> non-zero, instead of checking data_size to be non-zero.  IOW, we were
> trusting a reserved field to be zero in a situation where it was, in
> fact, undefined.

I'm perfectly fine with the patch except this statement above. I can't
parse it. What reserved field?

I'd guess the packages they distribute always have total_size
initialized properly, i.e. in the case where data_size is 0, total_size
is 2048 anyway. This is maybe the reason why nobody hit this bug as
get_totalsize() returning always the correct number.

Right?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
