Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab3CNAjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 20:39:09 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:59158 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab3CNAjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 20:39:07 -0400
Date: Wed, 13 Mar 2013 17:38:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benson Leung <bleung@chromium.org>
Cc: rydberg@euromail.se, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org, djkurtz@chromium.org,
        dudl@cypress.com
Subject: Re: [PATCH 2/4] Input: cyapa - Firmware update via request firmware
Message-ID: <20130314003837.GA11886@core.coreip.homeip.net>
References: <1363218651-22457-1-git-send-email-bleung@chromium.org>
 <1363218651-22457-3-git-send-email-bleung@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363218651-22457-3-git-send-email-bleung@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 04:50:49PM -0700, Benson Leung wrote:
> +
> +#define BYTE_PER_LINE  8
> +void cyapa_dump_data(struct cyapa *cyapa, size_t length, const u8 *data)
> +{
> +#ifdef DEBUG
> +	struct device *dev = &cyapa->client->dev;
> +	int i;
> +	char buf[BYTE_PER_LINE * 3 + 1];
> +	char *s = buf;
> +
> +	for (i = 0; i < length; i++) {
> +		s += sprintf(s, " %02x", data[i]);
> +		if ((i + 1) == length || ((i + 1) % BYTE_PER_LINE) == 0) {
> +			dev_dbg(dev, "%s\n", buf);
> +			s = buf;
> +		}
> +	}
> +#endif
> +}
> +#undef BYTE_PER_LINE

We have dev_dbg("%*ph\n", BYTES_PER_LINE, data[...]); for this.

Thanks.

-- 
Dmitry
