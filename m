Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaEAMWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 08:22:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbaEAMWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 08:22:34 -0400
Date: Thu, 1 May 2014 14:22:17 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: devel@driverdev.osuosl.org, Larry.Finger@lwfinger.net,
        Jes.Sorensen@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: fix potential leak in
 update_bcn_wps_ie()
Message-ID: <20140501122216.GC1806@mguzik.redhat.com>
References: <20140501135727.467d6bf2@spike>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140501135727.467d6bf2@spike>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 01:57:27PM +0200, Christian Engelmayer wrote:
> Fix a potential leak in the error path of function update_bcn_wps_ie().
> Make sure that allocated memory for 'pbackup_remainder_ie' is freed
> upon return. Detected by Coverity - CID 1077718.
> 

        if (remainder_ielen > 0) {
                pbackup_remainder_ie = kmalloc(remainder_ielen, GFP_ATOMIC);
                if (pbackup_remainder_ie)
                        memcpy(pbackup_remainder_ie, premainder_ie,
                               remainder_ielen);
        }

        pwps_ie_src = pmlmepriv->wps_beacon_ie;
        if (pwps_ie_src == NULL)
                return;


Maybe just check pwps_ie_src earlier?

-- 
Mateusz Guzik
