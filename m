Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaEHFQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 01:16:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbaEHFQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 01:16:35 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, mguzik@redhat.com,
        linux-kernel@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH v3] staging: rtl8188eu: fix potential leak in update_bcn_wps_ie()
References: <20140507214227.621a814d@spike>
Date: Thu, 08 May 2014 07:16:22 +0200
In-Reply-To: <20140507214227.621a814d@spike> (Christian Engelmayer's message
	of "Wed, 7 May 2014 21:42:27 +0200")
Message-ID: <wrfjd2fokfyx.fsf@ultrasam.lan.trained-monkey.org>
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
> v3: Resend after v2 failed to apply
>
>   * rebased against staging-next - commit 09c3fbba (staging: rtl8188eu:
>     Remove 'u8 *pbuf' from struct recv_buf)
>   * fixed mua: no multipart, 7bit text/plain us-ascii
>
> v2: Added change suggested by Mateusz Guzik for the rtl8723au variant:
>
>     Move the check before allocating the memory instead of freeing the
>     resource afterwards in the error path.
>
> Compile tested and applies against branch staging-next of tree
> git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> ---
>  drivers/staging/rtl8188eu/core/rtw_ap.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>
