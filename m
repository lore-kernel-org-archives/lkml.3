Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaKLOBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:01:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40606 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbaKLOBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:01:51 -0500
Message-ID: <1415800911.1761.21.camel@linux-0dmf.site>
Subject: Re: [V2 PATCH 04/10] added media agnostic (MA) USB packet handling
From: Oliver Neukum <oneukum@suse.de>
To: Stephanie Wallick <stephanie.s.wallick@intel.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        "Sean O. Stalley" <sean.stalley@intel.com>
Date: Wed, 12 Nov 2014 15:01:51 +0100
In-Reply-To: <1415671781-11351-4-git-send-email-stephanie.s.wallick@intel.com>
References: <MA USB drivers>
	 <1415671781-11351-1-git-send-email-stephanie.s.wallick@intel.com>
	 <1415671781-11351-4-git-send-email-stephanie.s.wallick@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-10 at 18:09 -0800, Stephanie Wallick wrote:
> +/**
> + * Compares 2 request IDs. Returns true if a is less than b. Handles
> request id
> + * wraparound.
> + */
> +bool mausb_req_id_lt(u8 a, u8 b)

Unify such functions. It's just silly to have so many of them.

> +/**
> + * Calculates the total length of data contained in an ms_pkt (in
> bytes).
> + * Returns the length of the kvec, or 0 on an error.
> + */
> +static int mausb_ms_data_length(struct ms_pkt *pkt)
> +{
> +       int             i;
> +       int             total_length;
> +       struct kvec     *current_kvec;
> +
> +       for (i = 0; i < pkt->nents; ++i) {
> +               current_kvec = &pkt->kvec[i];
> +               if (NULL == current_kvec)
> +                       return -EINVAL;
> +               else
> +                       total_length += current_kvec->iov_len;
> +       }
> +
> +       return total_length;
> +}
> +

	Regards
		Oliver

-- 
Oliver Neukum <oneukum@suse.de>

