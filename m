Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbaHKLpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:45:16 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:61567 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaHKLpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:45:15 -0400
Date: Mon, 11 Aug 2014 04:45:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Guenter Roeck <linux@roeck-us.net>
cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: Do not use BUG_ON(!spin_is_locked())
In-Reply-To: <1407731491-22446-1-git-send-email-linux@roeck-us.net>
Message-ID: <alpine.DEB.2.02.1408110439580.15519@chino.kir.corp.google.com>
References: <1407731491-22446-1-git-send-email-linux@roeck-us.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Aug 2014, Guenter Roeck wrote:

> spin_is_locked() always returns false in uniprocessor configurations
> and can therefore not be used with BUG_ON. Replace it with
> assert_spin_locked(), which exists for that very purpose.
> 

It may be helpful to assess whether any of these sites should be converted 
to lockdep_assert_held() so they have no cost when lockdep isn't enabled 
but still reveal problems when debugging.
