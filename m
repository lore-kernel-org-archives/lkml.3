Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaHTSQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 14:16:57 -0400
Received: from mail.cs.hut.fi ([130.233.192.7]:52956 "EHLO mail.cs.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbaHTSQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 14:16:56 -0400
Date: Wed, 20 Aug 2014 21:16:52 +0300 (EEST)
From: Ari Sundholm <asundhol@cs.hut.fi>
X-X-Sender: asundhol@hutcs
To: platform-driver-x86@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH] Revert "platform/x86/toshiba-apci.c possible bad if
 test?"
In-Reply-To: <alpine.GSO.2.00.1408201955290.8292@hutcs>
Message-ID: <alpine.GSO.2.00.1408202114140.8435@hutcs>
References: <alpine.GSO.2.00.1408201955290.8292@hutcs>
User-Agent: Alpine 2.00 (GSO 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 20 Aug 2014, Ari Sundholm wrote:

> -	if (sscanf(buf, "%i", &mode) != 1  || (mode != 2 || mode != 1))
> +	if (sscanf(buf, "%i", &mode) != 1 && (mode != 2 || mode != 1))
>  		return -EINVAL;

Note that the condition still looks wrong even after the revert, as
(mode != 2 || mode != 1) is always true. Anybody guess what the actual 
intent was?

Best regards,
Ari Sundholm
asundhol@cs.hut.fi
