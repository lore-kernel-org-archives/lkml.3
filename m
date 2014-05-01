Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750892AbaEAWvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 18:51:18 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:38846
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaEAWvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 18:51:17 -0400
Date: Fri, 2 May 2014 00:51:16 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, serge.hallyn@ubuntu.com,
        eparis@redhat.com, sgrubb@redhat.com, ebiederm@xmission.com
Subject: Re: [PATCH 1/2] namespaces: give each namespace a serial number
Message-ID: <20140501225116.GB25669@mail.hallyn.com>
References: <cover.1398176489.git.rgb@redhat.com>
 <be1358c6da51252cd79c51a51bb30bf157624ccd.1398176489.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be1358c6da51252cd79c51a51bb30bf157624ccd.1398176489.git.rgb@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Richard Guy Briggs (rgb@redhat.com):

Most of this looks reasonable, but I'm curious about something,

> +/**
> + * ns_serial - compute a serial number for the namespace
> + *
> + * Compute a serial number for the namespace to uniquely identify it in
> + * audit records.
> + */
> +unsigned int ns_serial(void)
> +{
> +	static DEFINE_SPINLOCK(serial_lock);
> +	static unsigned int serial = 4; /* reserved for IPC, UTS, user, PID */
> +
> +	unsigned long flags;
> +	unsigned int ret;
> +
> +	spin_lock_irqsave(&serial_lock, flags);
> +	do {
> +		ret = ++serial;
> +	} while (unlikely(!ret));

Why exactly are you doing this?  Surely if serial is going to
wrap around we've got a bigger problem than just wanting go
bump one more time?

> +	spin_unlock_irqrestore(&serial_lock, flags);
> +
> +	return ret;
> +}
