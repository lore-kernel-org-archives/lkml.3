Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbaHKUxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 16:53:51 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:39836 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbaHKUxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 16:53:50 -0400
Date: Mon, 11 Aug 2014 13:53:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: sanjeev sharma <sanjeevsharmaengg@gmail.com>
cc: Guenter Roeck <linux@roeck-us.net>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm: Do not use BUG_ON(!spin_is_locked())
In-Reply-To: <CAGUYZuSk4u5jyPcrYTjwjXmQRyr0kCEvxkgFfjcyP+ex544CLA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1408111352090.24240@chino.kir.corp.google.com>
References: <1407731491-22446-1-git-send-email-linux@roeck-us.net> <alpine.DEB.2.02.1408110439580.15519@chino.kir.corp.google.com> <CAGUYZuS=_rFpukssRebxXBccPrJAen15i8Qf3K+1YyF+feShdQ@mail.gmail.com>
 <CAGUYZuSk4u5jyPcrYTjwjXmQRyr0kCEvxkgFfjcyP+ex544CLA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2014, sanjeev sharma wrote:

> Hello David,
> 
> Here is the old discussion carried out on this.
> 
> http://linux-kernel.2935.n7.nabble.com/Is-spin-is-locked-safe-to-use-with-BUG-ON-WARN-ON-td654800.html#a921802
> 

I'm suggesting that if you don't want to incur the cost of the conditional 
everytime you call a certain function with assert_spin_locked() that you 
could covert these to lockdep_assert_held() so the check is only done when 
lockdep is enabled for debugging.
