Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652Ab3IPQjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:39:21 -0400
Received: from science.horizon.com ([71.41.210.146]:65453 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751179Ab3IPQjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:39:20 -0400
Date: 16 Sep 2013 12:39:19 -0400
Message-ID: <20130916163919.17829.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: joe@perches.com, linux@horizon.com
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
Cc: akpm@linux-foundation.org, dan.carpenter@oracle.com, JBeulich@suse.com,
        keescook@chromium.org, kosaki.motohiro@gmail.com,
        linux-kernel@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        viro@zeniv.linux.org.uk
In-Reply-To: <1379347993.1934.16.camel@joe-AO722>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> %*p<new_type><pad_char> (space assumed if not existing)

Yes, that's the fallback, but it requires an ugly dummy pointer argument.
And some extra kludgery in the code because pointer() doesn't have access
to the start-of-buffer address.

I'd prefer something that could be detected with the information available
in the switch(spec.type) in vsnprintf() itself.

It is, however, available as a last resort.
