Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbaFLPdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:33:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38633 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161AbaFLPdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:33:09 -0400
Message-ID: <5399C830.8070607@wwwdotorg.org>
Date: Thu, 12 Jun 2014 09:33:04 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org
CC: Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus <magnus.damm@gmail.com>, Simon <horms@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Subject: Re: [PATCH] of: Add vendor 2nd prefix for Asahi Kasei Corp
References: <CAMuHMdWTVBjFzA9L9Eqpq_2Xi9_NHkOCLrb_UjK611SBfwnc=Q@mail.gmail.com>	<87ioo7c0g5.wl%kuninori.morimoto.gx@renesas.com>	<539815E6.2050304@codethink.co.uk>	<20140611165410.GK5099@sirena.org.uk>	<CAMuHMdUT0hEBGbN+W-Oz5zJ0N8S2VDMndqtDO=EtWF3jG2MEew@mail.gmail.com>	<20140611170233.GL5099@sirena.org.uk>	<5398A53D.3020706@wwwdotorg.org>	<20140611190444.GN5099@sirena.org.uk>	<5398AB07.4040304@wwwdotorg.org> <87sinbdk44.wl%kuninori.morimoto.gx@renesas.com>
In-Reply-To: <87sinbdk44.wl%kuninori.morimoto.gx@renesas.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 06:53 PM, Kuninori Morimoto wrote:
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> 
> Current vendor-prefixes.txt already has
> "ak" prefix for Asahi Kasei Corp by
> ae8c4209af2cec065fef15d200a42a04130799f7
> (of: Add vendor prefix for Asahi Kasei Corp.)
> 
> It went through the appropriate review process,
> and is already in use.
> But, almost all Asahi Kasei chip driver is
> using "asahi-kasei" prefix today.

I'm fine with this patch, but just wanted to comment on this part of the
commit description:

What is in the drivers isn't relevant; that's not what drives the ABI.
The issue is that some *DTs* use ak and some use asahi-kasei, so both
those need to be supported.

That said, we should document which one of the two prefixes is
preferred, and use this for any new AK binding.

It would also be nice to ensure the preferred prefix is in all drivers'
of_match_tables, and remove the deprecated prefix from all drivers'
of_match_tables *except* where there's already a DT file that references
the deprecated vendor prefix.

