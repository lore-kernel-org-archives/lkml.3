Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761019Ab3D3QRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:17:18 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:56360 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760962Ab3D3QRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:17:13 -0400
Date: Tue, 30 Apr 2013 09:17:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: =?UTF-8?Q?Vincent_Stehl=C3=A9?= <vincent.stehle@laposte.net>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memory hotplug: fix warnings
In-Reply-To: <1367310697-6332-1-git-send-email-vincent.stehle@laposte.net>
Message-ID: <alpine.DEB.2.02.1304300916500.10368@chino.kir.corp.google.com>
References: <1367310697-6332-1-git-send-email-vincent.stehle@laposte.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-888928222-1367338632=:10368"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-888928222-1367338632=:10368
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 30 Apr 2013, Vincent Stehlé wrote:

> diff --git a/include/linux/memory.h b/include/linux/memory.h
> index 73817af..85c31a8 100644
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
> @@ -137,7 +137,7 @@ enum mem_add_context { BOOT, HOTPLUG };
>  #define register_hotmemory_notifier(nb)		register_memory_notifier(nb)
>  #define unregister_hotmemory_notifier(nb) 	unregister_memory_notifier(nb)
>  #else
> -#define hotplug_memory_notifier(fn, pri)	(0)
> +#define hotplug_memory_notifier(fn, pri)	({ 0; })
>  /* These aren't inline functions due to a GCC bug. */
>  #define register_hotmemory_notifier(nb)    ({ (void)(nb); 0; })
>  #define unregister_hotmemory_notifier(nb)  ({ (void)(nb); })

You can't use the standard do {} while (0)?
--531381512-888928222-1367338632=:10368--
