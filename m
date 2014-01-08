Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbaAHTHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 14:07:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbaAHTHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 14:07:18 -0500
Date: Wed, 8 Jan 2014 11:07:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@i4.cs.fau.de,
        Martin Hofmann <martin.hofmann@studium.uni-erlange.de>,
        linux-kernel@vger.kernel.org,
        Michael Gunselmann <michael.gunselmann@studium.uni-erlange.de>,
        martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net
Subject: Re: [PATCHv2 7/7] vt6655: Remove typedefs in 80211hdr.h
Message-ID: <20140108190747.GA7326@kroah.com>
References: <1389096711-8595-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
 <1389096711-8595-8-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389096711-8595-8-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 01:11:51PM +0100, Michael Gunselmann wrote:
> From: Martin Hofmann <martin.hofmann@studium.uni-erlangen.de>
> 
> The file 80211hdr.h contained typedefs for 5 types. To satisfy checkpatch,
> this commit removes them. In 11 other files, every occurence of a now deleted
> type has been substituted with the correct struct ... syntax.

Why not split this into 5 patches, one for each typedef?  That way the
one I don't like, I could have ignored, and taken the other 4 patches?
:)

> -typedef union tagUWLAN_80211HDR {
> -	WLAN_80211HDR_A2        sA2;
> -	WLAN_80211HDR_A3        sA3;
> -	WLAN_80211HDR_A4        sA4;
> -} UWLAN_80211HDR, *PUWLAN_80211HDR;
> +} __attribute__((__packed__));
> +
> +union UWLAN_80211HDR {
> +	struct WLAN_80211HDR_A2 sA2;
> +	struct WLAN_80211HDR_A3 sA3;
> +	struct WLAN_80211HDR_A4 sA4;
> +};

This really should be a struct of a union, right?  Then you don't have
these "odd" casts to do:

> -	pFrame->pHdr = (PUWLAN_80211HDR)pFrame->pBuf;
> +	pFrame->pHdr = (union UWLAN_80211HDR *)pFrame->pBuf;

And are these casts even needed?

thanks,

greg k-h
