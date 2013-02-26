Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab3BZFrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 00:47:46 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:33639 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab3BZFrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 00:47:42 -0500
Date: Tue, 26 Feb 2013 09:47:38 +0400
From: Artem Savkov <artem.savkov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ibm-acpi-devel@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        ibm-acpi@hmh.eng.br, matthew.garrett@nebula.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad_acpi: moved hotkey_thread_mutex lock after
 set_freezable()
Message-ID: <20130226054738.GA4191@thinkpad.lan>
References: <1361697722-4575-1-git-send-email-artem.savkov@gmail.com>
 <20130225155445.d3eef1ad.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130225155445.d3eef1ad.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 03:54:45PM -0800, Andrew Morton wrote:
> On Sun, 24 Feb 2013 13:22:02 +0400
> Artem Savkov <artem.savkov@gmail.com> wrote:
> 
> > set_freezable() checks freezing during which no locks should be held.
> > hotkey_thread_mutex lock should be moved closer to where it is actually needed.
> > 
> 
> Thanks.
> 
> When fixing a bug, we always like to see a full description of that bug
> so we can better work out which kernel versions need the fix.
Sorry, will do thah in future.

> Did you actually hit a lockup because of this?  Or was it just from
> code inspection?  Or ...  ?
I didn't hit an actual lockup, but I did hit a warning during boot. The
warning was added by "lockdep: check that no locks held at freeze time"
patch (2f2ff7b8979c50491b3cbce622d7bea4d44a8682 in linux-next.git)


-- 
Kind regards,
Artem
