Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbaDBOJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:09:06 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55824 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbaDBOJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:09:02 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <533C19FB.8090302@roeck-us.net>
Date: Wed, 02 Apr 2014 07:08:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>, Wim Van Sebroeck <wim@iguana.be>
CC: kernel-janitors@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] watchdog: via_wdt: replace del_timer by del_timer_sync
References: <1396360159-16244-1-git-send-email-Julia.Lawall@lip6.fr> <1396360159-16244-4-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1396360159-16244-4-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 06:49 AM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Use del_timer_sync to ensure that the timer is stopped on all CPUs before
> the driver exits.
>
> This change was suggested by Thomas Gleixner.
>
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @r@
> identifier i,t,ex;
> @@
> struct t i = { .remove = ex, };
>
> @@
> identifier r.ex;
> @@
> ex(...) {
>    <...
> - del_timer
> + del_timer_sync
>      (...)
>    ...>
> }
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>


