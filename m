Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaEBG7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 02:59:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbaEBG7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 02:59:52 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        Larry.Finger@lwfinger.net, mguzik@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: rtl8723au: fix potential leak in update_bcn_wps_ie()
References: <20140502001118.5ab306d8@spike>
Date: Fri, 02 May 2014 08:59:40 +0200
In-Reply-To: <20140502001118.5ab306d8@spike> (Christian Engelmayer's message
	of "Fri, 2 May 2014 00:11:18 +0200")
Message-ID: <wrfj1twcwtr7.fsf@ultrasam.lan.trained-monkey.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Engelmayer <cengelma@gmx.at> writes:
> Fix a potential leak in the error path of function update_bcn_wps_ie().
> Move the affected input verification to the beginning of the function so
> that it may return directly without leaking already allocated memory.
> Detected by Coverity - CID 1077718.
>
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
> v2: Added change suggested by Mateusz Guzik:
>
>     Move the check before allocating the memory instead of freeing the
>     resource afterwards in the error path.
>
> Compile tested and applies against branch staging-next of tree
> git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> ---
>  drivers/staging/rtl8723au/core/rtw_ap.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Added to the 8723au tree

Thanks!

Jes
