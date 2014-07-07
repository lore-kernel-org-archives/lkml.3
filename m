Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaGGPUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:20:34 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:46071 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbaGGPUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:20:31 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1407071655171.4757@hadrien>
References: <20140706070800.GA2927@himangi-Dell>
	<20140707144832.GL30458@sirena.org.uk>
	<alpine.DEB.2.10.1407071655171.4757@hadrien>
Date: Mon, 7 Jul 2014 12:20:28 -0300
Message-ID: <CAOMZO5AiFCnfTzo4TyB5e5c+xiHQiHUbhRVY7z=AbjOWZDX3NA@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: sgtl5000: Use devm_ functions
From: Fabio Estevam <festevam@gmail.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Mark Brown <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2014 at 11:58 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:

> Nevertheless, there is already a call to devm_regulator_bulk_get in
> sgtl5000_enable_regulators which calls sgtl5000_replace_vddd_with_ldo
> which calls ldo_regulator_register.  That call was introduced by
>
> commit 63e54cd9caa3ce03635810608519e2b37d8bc706
> Author: Fabio Estevam <fabio.estevam@freescale.com>
> Date:   Thu Apr 24 14:13:08 2014 -0300
>
> It seems that that patch should be reverted?

I think so. Russell also reported a kernel oops when unbinding this
module, so I will prepare a patch reverting it.

Thanks
