Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab3IQU5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 16:57:46 -0400
Received: from science.horizon.com ([71.41.210.146]:27653 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753271Ab3IQU5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 16:57:46 -0400
Date: 17 Sep 2013 16:57:42 -0400
Message-ID: <20130917205742.16147.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: keescook@chromium.org, penguin-kernel@i-love.sakura.ne.jp
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
Cc: akpm@linux-foundation.org, dan.carpenter@oracle.com, geert@linux-m68k.org,
        JBeulich@suse.com, joe@perches.com, kosaki.motohiro@gmail.com,
        linux-kernel@vger.kernel.org, linux@horizon.com,
        viro@zeniv.linux.org.uk
In-Reply-To: <CAGXu5jL+NeBw2_vXymM81UdtS6UO7KZA2S4rf3gwM_7nSJ2h6g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>   seq_setwidth(m, 21);
>>   seq_printf(m, "%s%d", con->name, con->index);
>>   seq_pad(m, '\n');

> Ooh, I like this a lot! Much cleaner.

That's certainly a good way to do it, too.
My "general principles" filter thinks it should be in a local variable
if it can, but if hiding it in the struct seq_file is fine if people
find that cleaner.

seq_pad could also reset the field to some null value and warn if
it's found in that state.  Not a strong preference, though; the error is
fairly harmless and you might not feel it's worth the code size.
